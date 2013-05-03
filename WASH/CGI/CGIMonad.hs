{-# LANGUAGE UndecidableInstances, NoMonomorphismRestriction #-}
-- © 2001- 2005 Peter Thiemann
-- |Definition of the monad underlying the CGI library.
module WASH.CGI.CGIMonad
where

import Data.Maybe (listToMaybe)
import Control.Monad.Fix

import WASH.CGI.CGITypes
import WASH.HTML.HTMLMonad hiding (span, map, div, head)
import WASH.CGI.LogEntry
import WASH.CGI.RawCGIInternal hiding (contentType)
import qualified WASH.Utility.SHA1 as SHA1

newtype CGI a = CGI { unCGI :: CGIAction a }
type CGIAction a = CGIState -> IO (a, CGIState)
data CGIState
  = CGIState { inparm   :: [PARAMETER]
	     , outparm  :: [PARAMETER]
	     , stateID  :: String
	     , mcount	:: Int
	     , cgiInfo  :: CGIInfo
	     , pageInfo :: PageInfo
	     , jsEnabled :: Maybe Bool
	     , encoder  :: String -> String
	     , cookieMap     :: [(String, (Maybe String, Maybe String))]
	     , cookiesToSend :: [String]
	     }

data PageInfo =
     PageInfo { count      :: Int
     	      , nextaction :: Element -> CGIAction ()
	      , actionTable :: [(String, Element -> CGIAction ())]
	      , bindings   :: Maybe CGIParameters
	      , enctype    :: String
	      , inFrame    :: Int
	      , allFields  :: [(String, Bool)]
	      , faultyfields :: [(String, String)]
	      }

data CGIFieldName =
     CGIFieldName { fnMcount :: Int, fnCount :: Int }

instance Show CGIFieldName where
  showsPrec i cfn = showChar 'f' .
                    shows (fnMcount cfn) .
		    showChar 'x' .
		    shows (fnCount cfn)

args = cgiArgs . cgiInfo
url = unURL . cgiUrl . cgiInfo
contentType = cgiContentType . cgiInfo

sessionMode = cgiSessionMode . cgiInfo

fromCGIstate select =
  wrapCGI $ \cgistate ->
  return (select cgistate, cgistate)

-- No clue what this type is, if we write it we can kill NoMonomorphismRestriction
getCGIArgs = fromCGIstate args
getUrl = fromCGIstate url
getParm = fromCGIstate outparm
getStateID = fromCGIstate stateID
getInfo = fromCGIstate pageInfo
getEncoder = fromCGIstate encoder
getJSEnabled = fromCGIstate jsEnabled
getScriptName = fromCGIstate (cgiScriptName . cgiInfo)
getPathInfo = fromCGIstate (cgiPathInfo . cgiInfo)
getHandle = fromCGIstate (cgiHandle . cgiInfo)
getFields = fromCGIstate (reverse . allFields . pageInfo)
getMcount = fromCGIstate mcount
getSessionMode = fromCGIstate sessionMode

-- | wrapper to transform IO computation to CGIAction
wrapIO :: IO a -> CGIAction a
wrapIO ioa = \ cgistate -> ioa >>= \ a -> return (a, cgistate)

-- | lift IO monad to CGI monad
lift :: IO a -> CGI a
lift = CGI . wrapIO

inc = 
  wrapCGI $ \cgistate ->
  let info = pageInfo cgistate in
  return (info 
         ,cgistate { pageInfo = info { count = count info + 1}})

setAction :: (CGIMonad cgi) => (Element -> cgi ()) -> cgi ()
setAction actionFun =
  wrapCGI $ \cgistate ->
  return (()
         ,cgistate { pageInfo = (pageInfo cgistate) { nextaction = unwrapCGI . actionFun }})

registerAction :: (CGIMonad cgi) => String -> (Element -> cgi ()) -> cgi ()
registerAction submitter actionFun =
  wrapCGI $ \cgistate ->
  let pi = pageInfo cgistate
      pi' = pi { actionTable = (submitter, unwrapCGI . actionFun) : actionTable pi }
  in return ((), cgistate { pageInfo = pi'})

incFrame :: (CGIMonad cgi) => cgi Int
incFrame =
  wrapCGI $ \cgistate ->
  let info = pageInfo cgistate
      lastFrame = inFrame info
      nextFrame = lastFrame + 1
  in
  return (nextFrame
         ,cgistate { pageInfo = info { inFrame = nextFrame }})

resetFrame :: (CGIMonad cgi) => cgi ()
resetFrame =
  wrapCGI $ \cgistate ->
  let info = pageInfo cgistate
  in
  return (()
         ,cgistate { pageInfo = info { inFrame = 0 }})

setEnctype :: (CGIMonad cgi) => String -> cgi ()
setEnctype contentType =
  wrapCGI $ \cgistate ->
  return (()
         ,cgistate { pageInfo = (pageInfo cgistate) { enctype = contentType } })

setFaulty :: (CGIMonad cgi) => [(String, String)] -> cgi ()
setFaulty ss =
  wrapCGI $ \cgistate ->
  return (()
         ,cgistate { pageInfo = (pageInfo cgistate) { faultyfields = ss } })

instance Monad CGI where
  return a = 
	CGI ( \cgistate -> return (a, cgistate))
  CGI cgi >>= f = 
	CGI ( \cgistate -> 
	    cgi cgistate >>= \ (x, cgistate') ->
	    unCGI (f x) cgistate')

-- contributed by Frederik Eaton <frederik@ofb.net>
instance MonadFix CGI where
  mfix f = CGI (\s ->
		mfix (\x -> (unCGI (f x)) s >>= (return.fst))
		>>= (\x -> return (x,s)))


class Monad cgi => CGIMonad cgi where
  wrapCGI :: CGIAction a -> cgi a
  unwrapCGI :: cgi a -> CGIAction a
  chooser :: a -> a -> cgi a

instance CGIMonad CGI where
  wrapCGI = CGI
  unwrapCGI = unCGI
  chooser x y = return x


nextName :: (CGIMonad cgi) => cgi CGIFieldName
nextName =
  do mc <- getMcount
     pageInfo <- inc
     return CGIFieldName { fnMcount = mc, fnCount = count pageInfo }

addField :: (CGIMonad cgi) => String -> Bool -> cgi ()
addField s f =
  wrapCGI ( \cgistate ->
  	let info = pageInfo cgistate in
	return ((), cgistate { pageInfo = info { allFields = (s,f): allFields info }}))

-- 
initialPageInfo cgistate =
  let bnds = listToMaybe [ parms | PAR_VALUES parms <- inparm cgistate ]
  in  PageInfo
  	{ count = 0
	, nextaction = \ _ st -> return ((), st)
	, actionTable = []
	, bindings = bnds
	, enctype = contentTypeUrlencoded
	, inFrame = inFrame (pageInfo cgistate)
	, allFields = []
	, faultyfields = []
	}

dropFirstPARVALUES parms =
  let f rps [] = error "dropFirstPARVALUES: no PAR_VALUES found"
      f rps (p : ps) = 
	case p of
	  PAR_VALUES _ ->
	    (p, reverse rps ++ ps)
	  _ ->
	    f (p : rps) ps
  in  f [] parms

nextCGIState cgistate = cgistate'
  where 
    (newparm, inparm') = dropFirstPARVALUES (inparm cgistate)
    cgistate' = cgistate { inparm = inparm'
			 , stateID = nextstid (stateID cgistate) newparm
			 , mcount = mcount cgistate + 1
			 , pageInfo = (initialPageInfo cgistate')
			     	{ inFrame = inFrame (pageInfo cgistate) }
			 }
-- 
initialStateID = "00000000000000000000"

nextstid oldstid parm =
  SHA1.sha1 (oldstid ++ show parm)

