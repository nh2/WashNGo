-- © 2001-2005 Peter Thiemann
module WASH.CGI.BaseCombinators
{-- interface
  (ask		-- WithHTML x CGI a -> CGI ()
  ,tell		-- CGIOutput a => a -> CGI ()
  ,htell 	-- WithHTML x IO () -> CGI ()
  ,run		-- CGI () -> IO ()
  ,runWithHook 	-- ([String] -> CGI ()) -> CGI () -> IO ()
  )
--}
where

import Control.Monad
import Data.Maybe
import System.Exit
import System.IO

import WASH.Utility.Auxiliary
import qualified WASH.Utility.Base64 as Base64
import WASH.CGI.CookieIO
import WASH.CGI.CGIMonad
import WASH.CGI.CGIOutput
import WASH.CGI.CGITypes
import WASH.CGI.EventHandlers
import WASH.CGI.Fields
import WASH.CGI.Frames
import WASH.CGI.LogEntry
import WASH.CGI.CGIHistory
import qualified WASH.CGI.HTMLWrapper as H hiding (map,head)
import WASH.CGI.Images
import WASH.Utility.JavaScript
import qualified WASH.Utility.RFC2279 as RFC2279
import qualified WASH.Utility.RFC2397 as RFC2397
import WASH.CGI.RawCGIInternal hiding (CGIEnv (..), getSessionMode)
import qualified WASH.Utility.URLCoding as URLCoding

import WASH.CGI.CGIConfig


-- |Safe embedding of an 'IO' action into the 'CGI' monad. Intentionally not
-- parameterized óver its monad to avoid its use inside of transactions.
io :: (Read a, Show a) => IO a -> CGI a
io ioa =
  once (unsafe_io ioa)

-- |Runs a 'CGI' state transformer forever. Its specification is just
--
-- > feedback f x = f x >>= feedback f
-- 
-- However, 'feedback' is more efficient because it avoids the 
-- buildup of long interaction logs by cutting back every time just before 'f' 
-- is invoked. Unfortunately, it's useless due to typing restrictions.
feedback :: (CGIMonad cgi, Read a, Show a) => (a -> cgi a) -> a -> cgi a
feedback f x = 
  wrapCGI (\ cgistate ->
  case inparm cgistate of
    -- if we've got a value in the log,
    -- ignore the parameter x and just use the logged value
    PAR_MARK _ : PAR_RESULT code : rest ->
      case reads code of
	(result, ""):_ ->
	  return (result
	         ,cgistate { inparm = rest })
	_ ->
	  reportError "Result unreadable"
	  	(H.text_S "Cannot read " >> H.text (show code)) cgistate
    [] ->
      let stid = stateID cgistate 
	  newparm = PAR_MARK stid
	  newvalue = PAR_RESULT (show x)
	  in
      do (nextx, cgistate') <- 
	   unwrapCGI (f x) cgistate { outparm = newvalue : newparm : outparm cgistate
				, stateID = nextstid (nextstid stid newparm) newvalue }
	 let (oldstid, outparm') = popToMark $ outparm cgistate'
	 unwrapCGI (feedback f nextx)
	       cgistate { inparm =  inparm cgistate'
			, outparm = outparm'
			, stateID = oldstid
			, cookieMap = cookieMap cgistate' 
			, cookiesToSend = cookiesToSend cgistate' }
    _ -> 
      reportError "Out of sync" H.empty cgistate)

-- |Control operator for the 'CGI' monad. Its specification is
--
-- > callWithCurrentHistory (\backto x -> action x >>= backto) x
-- > ==
-- > action x >>= callWithCurrentHistory (\backto x -> action x >>= backto)
-- 
-- However, 'callWithCurrentHistory' is more efficient because it avoids the 
-- buildup of long interaction logs by cutting back every time just before
-- 'action' gets executed. 
callWithCurrentHistory :: (CGIMonad cgi, Read a, Show a) =>
			  ((a -> cgi ()) -> a -> cgi ()) -> a -> cgi ()
callWithCurrentHistory g x = 
  wrapCGI (\ cgistate ->
  let
    prompt stid x =
      wrapCGI (\ cgistate' ->
	let outparm' = popTo stid (outparm cgistate') 
	in
	unwrapCGI (callWithCurrentHistory g x) 
	      cgistate { inparm =  inparm cgistate'
		       , outparm = outparm'
		       , stateID = stid
		       , cookieMap = cookieMap cgistate' 
		       , cookiesToSend = cookiesToSend cgistate' } )
    popTo stid [] = error "popTo did not find its mark"
    popTo stid (PAR_MARK stid' : rest) | stid' == stid = rest
    popTo stid (_ : rest) = popTo stid rest
  in
  case inparm cgistate of
    -- if we've got a value in the log,
    -- ignore the parameter x and just use the logged value
    PAR_MARK stid : PAR_RESULT code : rest ->
      case reads code of
	(result, ""):_ ->
	  unwrapCGI (g (prompt stid) result) cgistate { inparm = rest }
	_ ->
	  reportError "Result unreadable"
	  	(H.text_S "Cannot read " >> H.text (show code)) cgistate
    [] ->
      let stid = stateID cgistate 
	  newmark = PAR_MARK stid
	  newvalue = PAR_RESULT (show x)
	  in
      unwrapCGI (g (prompt stid) x)
	cgistate { outparm = newvalue : newmark : outparm cgistate
		 , stateID = nextstid (nextstid stid newmark) newvalue }
    _ -> 
      reportError "Out of sync" H.empty cgistate)

-- |Brackets a 'CGI' action so that only its result is visible. Improves
-- efficiency by not executing the bracketed action after it has been performed
-- once. Use this for avoiding the inefficient buildup of long interaction logs.
once :: (CGIMonad cgi, Read a, Show a) => cgi a -> cgi a
once cgi = 
  wrapCGI (\ cgistate ->
  case inparm cgistate of
    PAR_RESULT code : rest ->
      case reads code of
	(result, ""):_ ->
	  return (result
	         ,cgistate { inparm = rest })
	_ ->
	  reportError "Result unreadable"
	  	(H.text_S "Cannot read " >> H.text (show code)) cgistate
    [] ->
      let stid = stateID cgistate 
	  newparm = PAR_MARK stid in
      unwrapCGI cgi cgistate { outparm = newparm : outparm cgistate
			 , stateID = nextstid stid newparm }
      >>= finish cgistate
    PAR_MARK _ : rest -> 
      unwrapCGI cgi cgistate { inparm = rest } >>= finish cgistate
    _ -> 
      reportError "Out of sync" H.empty cgistate)
  where finish cgistate (v, cgistate') =
 	  let (oldstid, outparm') = popToMark $ outparm cgistate'
	      newparm = PAR_RESULT (show v)
	  in
	  return (v
	      	 ,cgistate { inparm = inparm cgistate'
			   , outparm = newparm : outparm'
			   , stateID = nextstid oldstid newparm
			   , cookieMap = cookieMap cgistate' 
			   , cookiesToSend = cookiesToSend cgistate' })

-- |Repeats a 'CGI' action without saving its state so that the size of the
-- interaction log remains constant.
forever :: (CGIMonad cgi) => cgi () -> cgi ()
forever cgi = 
  wrapCGI (\ cgistate ->
  case inparm cgistate of
    [] ->
      let stid = stateID cgistate 
	  newparm = PAR_MARK stid in
      unwrapCGI cgi cgistate { outparm = newparm : outparm cgistate
			 , stateID = nextstid stid newparm }
      >>= 
      const (reportError "Black hole" H.empty cgistate)
    PAR_MARK _ : rest -> 
      unwrapCGI cgi cgistate { inparm = rest } >>= finish (mcount cgistate)
    _ -> 
      reportError "Out of sync" H.empty cgistate)
  where finish previousMcount (v, cgistate') =
	  let (oldstid, outparm') = popToMark $ outparm cgistate'
	      newparm_ignored = PAR_RESULT (show v)
	      newparm = PAR_MARK oldstid
	  in
	  unwrapCGI cgi 
	    cgistate' { inparm = []
		      , outparm = newparm : outparm'
		      , stateID = nextstid oldstid newparm
		      , mcount = previousMcount }

-- |Unsafe variant of 'once':  returns the computed value only the first time
-- and returns a default value in all later invocations.
-- [deprecated]
onceAndThen :: (CGIMonad cgi, Read a, Show a) => a -> cgi a -> cgi a
onceAndThen a cgi = 
  wrapCGI (\ cgistate ->
  case inparm cgistate of
    PAR_IGNORED : rest ->
      return (a
	     ,cgistate { inparm = rest })
    [] ->
      unwrapCGI cgi cgistate { outparm = PAR_MARK (stateID cgistate) : outparm cgistate }
      >>= finish
    PAR_MARK _ : rest -> 
      unwrapCGI cgi cgistate { inparm = rest } >>= finish
    _ -> 
      reportError "Out of sync" H.empty cgistate)
  where popToMark [] = []
	popToMark (PAR_MARK _: rest) = rest
	popToMark (_: rest) = popToMark rest
	finish (v, cgistate') =
 	  let out = outparm cgistate' in
	  return (v
	      	 ,cgistate' { outparm = PAR_IGNORED : popToMark out })

-- internal helper function
popToMark [] = error "popToMark did not find MARK"
popToMark (PAR_MARK v: rest) = (v, rest)
popToMark (_: rest) = popToMark rest

-- |Directly lifts the 'IO' monad into the 'CGI' monad. This is generally unsafe
-- and should be avoided. Use 'io' instead.
unsafe_io :: IO a -> CGI a
unsafe_io = lift

-- |Takes a monadic value that constructs a HTML page and delivers this
-- page to the browser. This page may contain forms and input widgets.
ask :: (CGIMonad cgi) => H.WithHTML x cgi a -> cgi ()
ask ma =
  do sessionMode <- getSessionMode
     case sessionMode of
       LogOnly -> 
	 askResumptive ma
       _ ->
	 askContinuously ma

-- |Implementation of `ask` for the pure logged variant.
askResumptive :: (CGIMonad cgi) => H.WithHTML x cgi a -> cgi ()
askResumptive ma =
  do wrapCGI (\cgistate -> 
       return ((), cgistate { pageInfo = initialPageInfo cgistate }))
     setAction tell
     elem <- H.build_document ma 
     wrapCGI $
       \cgistate -> let
	 pi = pageInfo cgistate
	 atable = actionTable pi
	 mbnds = bindings pi
	 msubmitter = mbnds >>= assocParm subVar
	 maction = msubmitter >>= \x -> lookup x atable
	 nextState = nextCGIState cgistate
	 defsubmission = liftM snd $ listToMaybe (reverse atable)
	 defaction = maybe (rawTell) 
			   (const (maybe (tellError "Unspecified action")
					 id
					 defsubmission))
			   mbnds
	 go = (maybe defaction id maction) elem nextState
	 oldgo = (nextaction pi elem) nextState
       in
	 -- appendDebugFile "/tmp/ask" (show (List.map fst atable, msubmitter)) >>
	 go

-- |Experimental implementation of continuous version.
askContinuously :: (CGIMonad cgi) => H.WithHTML x cgi a -> cgi ()
askContinuously ma =
  fromCGIstate id >>= \initialState -> 
  let
    scriptName = cgiScriptName (cgiInfo initialState)
    parentID = (scriptName, stateID initialState)
    askLoop = do 
      wrapCGI (\cgistate -> 
	   return ((), cgistate { pageInfo = initialPageInfo cgistate })) 
      setAction tellContinuously			    -- is this still required?
      elem <- H.build_document ma 
      wrapCGI $
       \cgistate -> let
	 tellAction x = \ cst ->
	   do rawTellContinuously x cst
	      hClose (cgiHandle (cgiInfo cgistate))
	      (decoded_parameters, hout) <- readParameters parentID
	      -- newparm :: CGIParameters
	      let newparm = PAR_VALUES $ dropSpecialParameters decoded_parameters
		  newState = initialState { inparm = [newparm]
					  , outparm = newparm : outparm initialState
					  , cgiInfo = (cgiInfo initialState) { cgiHandle = hout}
					  }
	      unwrapCGI askLoop newState
		    
	 pi = pageInfo cgistate
	 atable = actionTable pi
	 mbnds = bindings pi
	 msubmitter = mbnds >>= assocParm subVar
	 maction = msubmitter >>= \x -> lookup x atable
	 nextState = nextCGIState cgistate
	 defsubmission = liftM snd $ listToMaybe (reverse atable)
	 nextparam = head (inparm cgistate)
	 myID = (scriptName, nextstid (snd parentID) nextparam)
	 boost maction =
	   maction >>= \ cgiact -> 
	   return (\ elem -> 
		     unwrapCGI (lift (createEntry myID (Just parentID) nextparam Nothing)
				 >> wrapCGI (cgiact elem)))
	 defaction = maybe tellAction
			   (const (maybe (tellError "Unspecified action")
					 id
					 (boost defsubmission)))
			   mbnds
       in 
	 (maybe defaction id (boost maction)) elem nextState
  in askLoop


-- |Like 'ask', but passes the constructed HTML page to the @elementAction@
-- parameter. This function may send the page via Email or store it into a
-- file. Anyone loading this page in a browser can resume the interaction.
askOffline :: (CGIMonad cgi) => H.WithHTML x cgi a -> (H.Element -> IO ()) -> cgi ()
askOffline ma elementAction =
  do wrapCGI (\cgistate -> return ((), cgistate { pageInfo = initialPageInfo cgistate }))
     setAction tell
     elem <- H.build_document ma 
     wrapCGI $
       \cgistate ->
       case bindings (pageInfo cgistate) of
         Nothing ->
	   elementAction elem >> return ((), cgistate)
	 Just _ ->
	   (nextaction (pageInfo cgistate) elem) (nextCGIState cgistate)

-- |Turns a 'CGI' action into an 'IO' action. Used to turn the main 'CGI' action
-- into the @main@ function of the program. Typical use:
-- 
-- > main = run mainCGI
run :: CGI () -> IO ()
run =
  runWithOptions []

-- |Turns a 'CGI' action into an 'IO' action. Used to turn the main 'CGI' action
-- into the @main@ function of the program. Takes additional low-level
-- options. Typical use: 
-- 
-- > main = runWithOptions [] mainCGI
runWithOptions :: CGIOptions -> CGI () -> IO ()
runWithOptions options =
  runInternal options (fallbackTranslator Nothing)

-- |Variant of 'run' where an additional argument @cgigen@ specifies an action
-- taken when the script is invoked with a non-empty query string as in
-- @script-name?query-string@ 
runWithHook :: CGIOptions -> ([String] -> CGI ()) -> CGI () -> IO ()
runWithHook options cgigen =
  runInternal options (fallbackTranslator (Just cgigen))

runInternal options cgigen cgiProg =
  start options $ makeServletInternal cgigen cgiProg

-- |Transform a CGI action into a servlet suitable for running from Marlow's web
-- server.
makeServlet :: CGI () -> CGIProgram
makeServlet cgiProg = 
  makeServletInternal (fallbackTranslator Nothing) cgiProg

-- |Like 'makeServlet' with additional CGI generator as in 'runWithHook'.
makeServletWithHook :: ([String] -> CGI ()) -> CGI () -> CGIProgram
makeServletWithHook cgigen cgiProg =
  makeServletInternal (fallbackTranslator $ Just cgigen) cgiProg

makeServletInternal cgigen (CGI cgi) = \ info decoded_parameters ->
  let maybecgiparm = assocParm "=CGI=parm=" decoded_parameters in
  let maybecgistid = assocParm "=CGI=stid=" decoded_parameters in
  let maybejsenabl = assocParm "js_enabled" decoded_parameters in
  let clean_parameters = dropSpecialParameters decoded_parameters in
  let no_parameters = null decoded_parameters in
  do oldparm <- case maybecgiparm of
       Just cgiparm ->
         liftM read $ liftM RFC2279.decode $ decode $ Base64.decode' $ cgiparm
       Nothing -> 
         return []
     key <- generateKey
     let newparm 
          | no_parameters = []
	  | otherwise = (PAR_VALUES $ clean_parameters)
	  		: oldparm
	 oldstid
	  | null decoded_parameters || isNothing maybecgistid = initialStateID
	  | otherwise = Base64.decode' $ fromJust maybecgistid
	 cgistate = CGIState { inparm = reverse newparm
		             , outparm = newparm
			     , stateID = oldstid
			     , cgiInfo = info
			     , mcount = 0
			     , jsEnabled = liftM read maybejsenabl
			     , pageInfo = (initialPageInfo cgistate) {inFrame = 0}
			     , encoder = makeEncoder key
			     , cookieMap = map decodeCookie (cgiCookies info)
			     , cookiesToSend = []
			     }
	 args = cgiArgs info
	 scriptName = cgiScriptName info
	 sessionMode = cgiSessionMode info
     -- writeDebugFile "/tmp/CGIOLDPARM" (show oldparm)
     -- writeDebugFile "/tmp/CGINEWPARM" (show newparm)
     
     -- set b==False if replaying is required
     b <- case sessionMode of
       LogOnly ->
	 return False
       _ ->
	 if no_parameters then
	   do createEntry (scriptName, initialStateID) Nothing PAR_IGNORED Nothing
	      return False
	 else
           notify (scriptName, oldstid) clean_parameters (cgiHandle info)
	   -- if b is True at this point, we have found a thread to handle
	   -- this request. However, we cannot terminate at this time because
	   -- exiting will close the output handle for the other thread!
     unless b $ do
       if null args || null (head args)
	 then cgi cgistate >> return ()
	 else unCGI (cgigen $ args) cgistate >> return ()
       exitWith ExitSuccess

-- ======================================================================
-- output routines

-- |Terminates script by sending its argument to the browser.
tell :: (CGIMonad cgi, CGIOutput a) => a -> cgi ()
tell a =
  wrapCGI (rawTell a)

-- rawTell :: (CGIOutput a) => a -> CGIAction ()
rawTell a cgistate =
  -- appendFile "/tmp/CGIFRAME" ("tell/enter\n") >>
  let frameno = inFrame $ pageInfo cgistate in
  -- appendFile "/tmp/CGIFRAME" ("tell #" ++ show frameno ++ "\n") >>
  if frameno == 0 then
  do putCookies cgistate
     cgiPut (cgiHandle $ cgiInfo cgistate) a
     exitWith ExitSuccess
  else
  do let fname = frameFullPath (outparm cgistate) frameno
     h <- openFile fname WriteMode
     cgiPut h a
     hClose h
     return ((), cgistate)

-- |(experimental: continuous version) send argument to the browser.
tellContinuously :: (CGIMonad cgi, CGIOutput a) => a -> cgi ()
tellContinuously a =
  wrapCGI (rawTellContinuously a)

rawTellContinuously :: (CGIOutput a) => a -> CGIAction ()
rawTellContinuously a =
  (\cgistate -> 
  let h = cgiHandle $ cgiInfo cgistate in
  do putCookies cgistate
     cgiPut h a
     -- hFlush h
     return ((), cgistate))


-- |Terminate script by sending a HTML page constructed by monadic argument. 
htell :: (CGIMonad cgi) => H.WithHTML x IO () -> cgi a
htell hma =
  wrapCGI (\cgistate ->
  do putCookies cgistate
     itell (cgiHandle $ cgiInfo cgistate) hma)
     -- never reached

rawHtell hma = 
  \cgistate ->
  do putCookies cgistate
     itell (cgiHandle $ cgiInfo cgistate) hma

-- 
tellError :: String -> H.Element -> CGIAction a
tellError str elems = 
  rawHtell message 
  where message = 
	  H.standardPage str (backLink H.empty)

-- 
reportError :: String -> H.WithHTML x IO () -> CGIState -> IO (a, CGIState)
reportError ttl elems cgistate =
  unCGI (htell message) cgistate
  -- never reached
  where message = 
	  H.standardPage ttl (elems >> backLink H.empty)

-- |Link to previous page in browser's history. Uses JavaScript.
backLink :: Monad m => H.HTMLCons x y m ()
backLink attrs =
  hlink (URL "javascript:back()") (H.text_S "Try again..." >> attrs)

-- |Plain Hyperlink from an URL string.
hlink :: Monad m => URL -> H.HTMLCons x y m ()
hlink url subs = 
  H.a_T (H.attr_SD "href" (unURL url) >> subs)

-- 
fallbackTranslator mCgigen =
  docTranslator [nothing, question] $
  frameTranslator $
  nextTranslator mCgigen

-- 
frameTranslator :: (CGIMonad cgi) => ([String] -> cgi ()) -> [String] -> cgi ()
frameTranslator next (name@('F':'R':'A':'M':'E':':':_):_) =
  tell (ResponseFileReference (frameDir ++ name))
frameTranslator next strs =
  next strs

-- |A /translator/ is a function @[String] -> CGI ()@. It takes the query string
-- of the URL (of type @[String]@) and translates it into a CGI
-- action. @docTranslator docs next@ 
-- takes a list of 'FreeForm' documents and a next translator. It tries to
-- select a document by its 'ffName' and falls through to the
-- @next@ translator if no document matches.
docTranslator :: [FreeForm] -> ([String] -> CGI ()) -> [String] -> CGI ()
docTranslator docs next [name] =
  let f (doc : rest) =
        if name == ffName doc then tell doc else f rest
      f [] = next [name]
  in  f docs
docTranslator docs next strs =
  next strs

-- |Terminates a sequence of translators.
lastTranslator :: [String] -> CGI ()
lastTranslator =
  nextTranslator Nothing

nextTranslator Nothing _ =
  tell (Status 404 "Not Found" Nothing)
nextTranslator (Just cgigen) strs =
  cgigen strs

-- | Internal: name for the submission variable and form field
subVar :: String
subVar = "WASHsub"
