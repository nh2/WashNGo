-- © 2006 Peter Thiemann
{- | Generic utilities for implementing transactionsal memories
-}
module WASH.CGI.TransactionUtil 
  (withCGI, withTCGI, Control (..))
  where

import qualified WASH.CGI.BaseCombinators as B
import qualified WASH.CGI.HTMLWrapper as H hiding (map,head)

import WASH.CGI.CGIMonad
import WASH.CGI.LogEntry

import Control.Exception
import System.IO
import System.IO.Error

import WASH.CGI.TCGI

-- | Checks presence of a transaction mark on the stack
onStack :: String -> [PARAMETER] -> Bool
onStack stid parms =
  any h parms
  where
    h (PAR_TRANS stid') = stid' == stid
    h _ = False

-- | Pops log entries up to and including the transaction mark with given state
-- ID. 
popTo :: String -> [PARAMETER] -> [PARAMETER]
popTo stid parms =
  g parms
  where
    g [] = error "popTo did not find its transaction mark"
    g (PAR_TRANS stid' : rest) | stid' == stid = rest
    g (_ : rest) = popTo stid rest

-- | Splits the log at the transaction mark with given state ID.
splitTo :: String -> [PARAMETER] -> ([PARAMETER], [PARAMETER])
splitTo stid parms =
  g parms
  where
    g [] = error "splitTo did not find its transaction mark"
    g (mark@(PAR_TRANS stid') : rest) | stid' == stid =
      ([mark], rest)
    g (entry : rest) =
      let (prefix, rest') = splitTo stid rest in
      (entry : prefix, rest')

-- | Applies a function to a transaction mark with given state ID.
applyTo :: String -> ([PARAMETER] -> [PARAMETER]) -> ([PARAMETER] -> [PARAMETER])
applyTo stid trafo parms =
  g parms []
  where
    g [] _ = error "applyTo did not find its transaction mark"
    g (mark@(PAR_TRANS stid') : rest) acc | stid' == stid =
      reverse (trafo (mark : acc)) ++rest
    g (entry : rest) acc =
      g rest (entry : acc)

data Control cgi result =
    Control { abandon   :: result -> cgi ()	-- ^ abandon with result (rollback)
	    , setFail   :: result -> cgi ()	-- ^ set result on failure
	    , setCommit :: result -> cgi ()	-- ^ set result on successful commit
	    }

with :: (CGIMonad cgi, Read result, Show result) =>
	  ([PARAMETER] -> IO Bool)	    -- committer function
	  -> result				-- default result
	  -> (result -> cgi ()) 		-- result continuation
	  -> (Control (TCGI result) result -> (TCGI result) ())
	  -> cgi ()
with commitFromLog result onResult fun =
  wrapCGI (\cgistate -> 
    let abandon stid res =
	  wrapCGI (\cgistate -> ioError (userError (shows stid $ show res)))
	setFail stid res = 
	  B.once $
	  wrapCGI (\cgistate ->
	       let out = outparm cgistate 
		   out' = applyTo stid onFail out
		   onFail (pmark : pfail : psucc : rest) =
			  (pmark : PAR_RESULT (show res) : psucc : rest)
	       in
	       return ((), cgistate { outparm = out' })
	       )
	setCommit stid res = 
	  B.once $
	  wrapCGI (\cgistate ->
	       let out = outparm cgistate 
		   out' = applyTo stid onSucc out
		   onSucc (pmark : pfail : psucc : rest) =
			  (pmark : pfail : PAR_RESULT (show res) : rest)
	       in
	       return ((), cgistate { outparm = out' })
	       )
	control stid =
	  Control { abandon = abandon stid
		  , setFail = setFail stid
		  , setCommit = setCommit stid
		  }
	run stid cgistate =
	  do lr <- try (unwrapCGI (fun (control stid)) cgistate)
	     case lr of
	       Right (v, cgistate') ->
		 -- body of transaction finished successfully; now commit
		 let out = outparm cgistate'
		     (prefix, outparm') = splitTo stid out
		     PAR_TRANS _ :
		       failp@(PAR_RESULT failString) :
		       succp@(PAR_RESULT succString) : _ = reverse prefix
		 in
		 do committed <- commitFromLog prefix
		    if committed then
		       unwrapCGI (onResult (read succString))
			 cgistate' { outparm = succp : outparm' }
		     else
		       unwrapCGI (onResult (read failString))
			 cgistate' { outparm = failp : outparm' }
		 
	       Left err ->
		 -- Caught an exception; might be due to an @anbandon@ operation
		 case reads (ioeGetErrorString err) of
		   (stid', rest) : _ | stid' == stid ->
		     let result = read rest
			 newvalue = PAR_RESULT rest
			 out' = popTo stid (outparm cgistate)
		     in
		       unwrapCGI (onResult result)
			 cgistate { inparm = []
				  , outparm = newvalue : out'
				  , stateID = nextstid stid newvalue 
				  }
		   _ ->
		     ioError err
    in
    case inparm cgistate of
      [] ->
        let stid = stateID cgistate
	    newmark = PAR_TRANS stid
	    newvalue = PAR_RESULT (show result)
	in
	run stid cgistate 
	  { outparm = newvalue : newvalue : newmark : outparm cgistate
	  , stateID = nextstid (nextstid (nextstid stid newmark) newvalue) newvalue }
      -- ongoing transaction
      PAR_TRANS stid : PAR_RESULT failString : PAR_RESULT successString : rest ->
	run stid cgistate { inparm = rest }
	       
      -- finished transaction, go on with result continuation
      PAR_RESULT str : rest ->
	unwrapCGI (onResult (read str)) cgistate { inparm = rest }
      _ -> 
	B.reportError "Out of sync" H.empty cgistate
  )  


-- |Unnested transaction
withCGI :: (Read result, Show result) =>
	  ([PARAMETER] -> IO Bool)	    -- committer function
	  -> result				-- default result
	  -> (result -> CGI ()) 		-- result continuation
	  -> (Control (TCGI result) result -> (TCGI result) ())
	  -> CGI ()
withCGI commitFromLog result onResult fun =
  wrapCGI (\cgistate -> 
    let abandon stid res =
	  wrapCGI (\cgistate -> ioError (userError (shows stid $ show res)))
	setFail stid res = 
	  B.once $
	  wrapCGI (\cgistate ->
	       let out = outparm cgistate 
		   out' = applyTo stid onFail out
		   onFail (pmark : pfail : psucc : rest) =
			  (pmark : PAR_RESULT (show res) : psucc : rest)
	       in
	       return ((), cgistate { outparm = out' })
	       )
	setCommit stid res = 
	  B.once $
	  wrapCGI (\cgistate ->
	       let out = outparm cgistate 
		   out' = applyTo stid onSucc out
		   onSucc (pmark : pfail : psucc : rest) =
			  (pmark : pfail : PAR_RESULT (show res) : rest)
	       in
	       return ((), cgistate { outparm = out' })
	       )
	control stid =
	  Control { abandon = abandon stid
		  , setFail = setFail stid
		  , setCommit = setCommit stid
		  }
	run stid cgistate =
	  do lr <- try (unwrapCGI (fun (control stid)) cgistate)
	     case lr of
	       Right (v, cgistate') ->
		 -- body of transaction finished successfully; now commit
		 let out = outparm cgistate'
		     (prefix, outparm') = splitTo stid out
		     PAR_TRANS _ :
		       failp@(PAR_RESULT failString) :
		       succp@(PAR_RESULT succString) : _ = reverse prefix
		 in
		 do committed <- commitFromLog prefix
		    if committed then
		       unwrapCGI (onResult (read succString))
			 cgistate' { outparm = succp : outparm' }
		     else
		       unwrapCGI (onResult (read failString))
			 cgistate' { outparm = failp : outparm' }
		 
	       Left err ->
		 -- Caught an exception; might be due to an @anbandon@ operation
		 case reads (ioeGetErrorString err) of
		   (stid', rest) : _ | stid' == stid ->
		     let result = read rest
			 newvalue = PAR_RESULT rest
			 out' = popTo stid (outparm cgistate)
		     in
		       unwrapCGI (onResult result)
			 cgistate { inparm = []
				  , outparm = newvalue : out'
				  , stateID = nextstid stid newvalue 
				  }
		   _ ->
		     ioError err
    in
    case inparm cgistate of
      [] ->
        let stid = stateID cgistate
	    newmark = PAR_TRANS stid
	    newvalue = PAR_RESULT (show result)
	in
	run stid cgistate 
	  { outparm = newvalue : newvalue : newmark : outparm cgistate
	  , stateID = nextstid (nextstid (nextstid stid newmark) newvalue) newvalue }
      -- ongoing transaction
      PAR_TRANS stid : PAR_RESULT failString : PAR_RESULT successString : rest ->
	run stid cgistate { inparm = rest }
	       
      -- finished transaction, go on with result continuation
      PAR_RESULT str : rest ->
	unwrapCGI (onResult (read str)) cgistate { inparm = rest }
      _ -> 
	B.reportError "Out of sync" H.empty cgistate
  )  


-- | nested transaction
withTCGI :: (Read result, Show result) =>
	  ([PARAMETER] -> IO Bool)	    -- committer function
	  -> result				-- default result
	  -> (result -> TCGI result1 ()) 		-- result continuation
	  -> (Control (TCGI result) result -> (TCGI result) ())
	  -> TCGI result1 ()
withTCGI checkIfCommittable result onResult fun =
  wrapCGI (\cgistate -> 
    let abandon stid res =
	  wrapCGI (\cgistate -> ioError (userError (shows stid $ show res)))
	setFail stid res = 
	  B.once $
	  wrapCGI (\cgistate ->
	       let out = outparm cgistate 
		   out' = applyTo stid onFail out
		   onFail (pmark : pfail : psucc : rest) =
			  (pmark : PAR_RESULT (show res) : psucc : rest)
	       in
	       return ((), cgistate { outparm = out' })
	       )
	setCommit stid res = 
	  B.once $
	  wrapCGI (\cgistate ->
	       let out = outparm cgistate 
		   out' = applyTo stid onSucc out
		   onSucc (pmark : pfail : psucc : rest) =
			  (pmark : pfail : PAR_RESULT (show res) : rest)
	       in
	       return ((), cgistate { outparm = out' })
	       )
	control stid =
	  Control { abandon = abandon stid
		  , setFail = setFail stid
		  , setCommit = setCommit stid
		  }
	run stid cgistate =
	  do lr <- try (unwrapCGI (fun (control stid)) cgistate)
	     case lr of
	       Right (v, cgistate') ->
		 -- body of transaction finished successfully; now commit
		 let out = outparm cgistate'
		     (prefix, outparm') = splitTo stid out
		     PAR_TRANS _ :
		       failp@(PAR_RESULT failString) :
		       succp@(PAR_RESULT succString) : _ = reverse prefix
		 in
		 do committed <- checkIfCommittable prefix
		    if committed then
		       -- if commit can succeed, then its reads and writes
		       -- must not be lost! 
		       let marker = PAR_RESULT ""
			   logentries = [ x | x@(PAR_DB _) <- prefix]
		       in
		       unwrapCGI (onResult (read succString))
			 cgistate' { outparm = succp : logentries ++ 
				               marker : outparm' }
		     else
		       unwrapCGI (onResult (read failString))
			 cgistate' { outparm = failp : outparm' }
		 
	       Left err ->
		 -- Caught an exception; might be due to an @anbandon@ operation
		 case reads (ioeGetErrorString err) of
		   (stid', rest) : _ | stid' == stid ->
		     let result = read rest
			 newvalue = PAR_RESULT rest
			 out' = popTo stid (outparm cgistate)
		     in
		       unwrapCGI (onResult result)
			 cgistate { inparm = []
				  , outparm = newvalue : out'
				  , stateID = nextstid stid newvalue 
				  }
		   _ ->
		     ioError err
    in
    case inparm cgistate of
      [] ->
        let stid = stateID cgistate
	    newmark = PAR_TRANS stid
	    newvalue = PAR_RESULT (show result)
	in
	run stid cgistate 
	  { outparm = newvalue : newvalue : newmark : outparm cgistate
	  , stateID = nextstid (nextstid (nextstid stid newmark) newvalue) newvalue }
      -- ongoing transaction
      PAR_TRANS stid : PAR_RESULT failString : PAR_RESULT successString : rest ->
	run stid cgistate { inparm = rest }
	       
      -- finished nested transaction successfully
      PAR_RESULT "" : rest ->
	let loop (PAR_RESULT str : rest) =
	      unwrapCGI (onResult (read str)) cgistate { inparm = rest }
	    loop (PAR_DB _ : rest) =
	      loop rest
	    loop _ =
	      B.reportError "Format error in nested transaction log" H.empty cgistate
	in  loop rest
      -- finished transaction, go on with result continuation
      PAR_RESULT str : rest ->
	unwrapCGI (onResult (read str)) cgistate { inparm = rest }
      _ -> 
	B.reportError "Out of sync" H.empty cgistate
  )  

