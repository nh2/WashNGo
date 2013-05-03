-- © 2006 Peter Thiemann
{- | Transactional, type-indexed implementation of server-side state.

Glossary

A transactional entity (TE) is a named multi-versioned global variable.
-}

module WASH.CGI.Transaction (
  T (), init, create, remove, get, set,
  with, Control (..),
  TCGI ()
  ) where

import qualified WASH.CGI.BaseCombinators as B
import qualified WASH.CGI.CGIConfig as Conf
import WASH.CGI.CGIMonad
import WASH.CGI.CGI hiding (head, div, span, map)

import WASH.CGI.TCGI (TCGI)
import qualified WASH.CGI.TransactionUtil as TU
import WASH.CGI.TransactionUtil (Control (..))
import WASH.CGI.LogEntry
import WASH.CGI.MakeTypedName
import WASH.CGI.Types

import qualified WASH.CGI.HTMLWrapper as H hiding (map,head)

import qualified WASH.Utility.Auxiliary as Aux
import qualified WASH.Utility.Locking as L
import qualified WASH.Utility.Unique as Unique

import Directory
import IO
import qualified List
import Maybe
import Monad
import Prelude hiding (init)

transactionLock = Conf.transactionDir

-- |Handle of a transactional variable
newtype T a = 
  T String
  deriving (Read, Show)

-- |Attempt to create a new tv @n@ and set its initial value. Returns handle to
-- the variable. If the variable already exists, then just returns the handle.
init :: (Types a, Read a, Show a) => String -> a -> TCGI b (T a)
init name val =
  let v = show val 
      typedName = makeTypedNameFromVal name val
      h = T typedName 
  in
  wrapCGI (\ cgistate ->
    case inparm cgistate of
      [] ->			    -- first time here
        do Aux.assertDirectoryExists (List.init Conf.transactionDir) (return ())
	   -- must try to read the variable at this point 
	   -- because it may only exist in the log
	   let out = outparm cgistate
	   ev <- try (readValue out typedName)
	   let newparm =
	         case ev of
		   Left _ ->
		     -- value did not exist (but don't write it now)
		     PAR_CRE_TV typedName v
		   Right (v', cached) ->
		     -- value did exist (although we have not read its value)
		     PAR_GET_TV typedName v'
	   return (h, cgistate { outparm = newparm : out })
      PAR_CRE_TV _ _ : rest ->      -- created the variable
	return (h, cgistate { inparm = rest })
      PAR_GET_TV _ _ : rest ->      -- touched existing variable
	return (h, cgistate { inparm = rest })
      le : rest ->
	error ("Transaction.init: got log entry "
	       ++ show le ++
	       ". This should not happen")
  )


-- |Read transactional variable through a typed handle.
get :: (Read a, Show a) => T a -> TCGI b a
get (T typedName) =
  wrapCGI (\ cgistate ->
    case inparm cgistate of
      [] ->
        -- check the log for preceding reads and  writes;
        --  then fall back to physical read
        let out = outparm cgistate in
        do (v, cached) <- readValue out typedName
	   let newparm | cached    = PAR_RESULT v
		       | otherwise = PAR_GET_TV typedName v
	   return (read v, cgistate { outparm = newparm : out })
      PAR_GET_TV _ v : rest ->
	return (read v, cgistate { inparm = rest })
      PAR_RESULT v : rest ->
	return (read v, cgistate { inparm = rest })
      _ ->
	error "Transaction.get: this should not happen"
  )

-- |Write to a transactional variable through typed handle. Only affects the
-- log, no /physical/ write happens. Checks physically for existence of the
-- variable (but tries the log first). Raises exception if it does not exist.
set :: (Read a, Show a) => T a -> a -> TCGI b ()
set (T typedName) val =
  let v = show val
  in
  wrapCGI (\ cgistate ->
    case inparm cgistate of
      [] ->
        do let newparm = PAR_SET_TV typedName v 
	       out = outparm cgistate
	   readValue out typedName -- must not fail
	   return ((), cgistate { outparm = newparm : outparm cgistate })
      PAR_SET_TV _ _ : rest ->
	return ((), cgistate { inparm = rest })
      _ ->
	error "Transaction.set: this should not happen"
  )

-- |Create a fresh transactional variable with an initial value and return its
-- handle. Performs a physical write to ensure that the variable's name is
-- unique. Locks the transaction directory during the write operation.
create :: (Read a, Show a, Types a) => a -> TCGI b (T a)
create val =
  let v = show val
      obtainUniqueHandle =
	do name <- Unique.inventStdKey
	   let typedName = makeTypedNameFromVal name val
	       h = T typedName
	   L.obtainLock transactionLock
	   conflict <- reallyExists typedName
	   unless conflict $ reallyWrite typedName v
	   L.releaseLock transactionLock
	   if conflict then obtainUniqueHandle else return h
  in
  do wrapCGI $ \ cgistate ->
       case inparm cgistate of
	 [] ->
           do Aux.assertDirectoryExists (List.init Conf.transactionDir) (return ())
	      h@(T typedName) <- obtainUniqueHandle
	      return (h, cgistate { outparm = PAR_CRE_TV typedName v : outparm cgistate })
	 PAR_CRE_TV typedName _ : rest ->
	   return (T typedName, cgistate { inparm = rest })
	 _ ->
	   error "Transaction.create: this should not happen"


-- |Remove a transactional variable. Subsequent read accesses to this variable
-- will make the transaction fail. May throw an exception if the variable is not
-- present.
remove :: (Types a) => T a -> TCGI b ()
remove (T typedName) =
     wrapCGI (\ cgistate ->
       case inparm cgistate of
	 [] ->
	   -- check that the variable exists
           -- will raise an exception otherwise
	   let out = outparm cgistate in
           do readValue out typedName
	      return ((), cgistate { outparm = PAR_REM_TV typedName : out })
	 PAR_REM_TV _ : rest ->
	   return ((), cgistate { inparm = rest })
	 _ ->
	   error "Transaction.remove: this should not happen"
       )


-- | @with@ creates a transactional scope in which transactional variables can
-- be manipulated. Transactions may be nested to an arbitrary depth, although a
-- check with the current state of the world only occurs at the point where the
-- top-level transaction tries to commit. 
-- 
-- @with@ takes three parameters, a default value of type @result@, a
-- continuation, and a body function that maps a @Control@ record to a
-- transactional computation. There are three ways in which a
-- transaction may be completed. First, the transaction may be abandoned
-- explicitly by a call to the @abandon@ function supplied as part of the
-- @Control@ record. In this case, the continuation is invoked on a pre-set
-- failure return value. Second, the transaction body runs to completion but
-- fails to commit. In this case, the continuation is also invoked on the
-- pre-set failure return value. Third, the transaction body runs to completion
-- and commits successfully. In this case, the continuation is invoked, but on
-- the pre-set success value. 
-- The @result@-type argument initializes the default return value for both, the
-- success and the failure case. The body function implements the body of the
-- transaction. 
-- 
class CGIMonad cgi => WithMonad cgi where
  with :: (Read result, Show result) =>
	  result 
	  -> (result -> cgi ())
	  -> (TU.Control (TCGI result) result -> (TCGI result) ())
	  -> cgi ()

instance WithMonad CGI where
  with result onResult fun =
     TU.withCGI commitFromLog result onResult fun

instance WithMonad (TCGI x) where
-- !!! needs to be checked !!!
  with result onResult fun =
     TU.withTCGI (const $ return True) result onResult fun

-- |Read value of a variable first from log prefix. Return value @True@
-- indicates a value from the log, @False@ indicates a value read from file. May
-- raise an exception if the variable has been removed.
readValue :: [PARAMETER] -> String -> IO (String, Bool)
readValue [] n =
  do v' <- reallyRead n
     return (v', False)
readValue (PAR_SET_TV n' v':rest) n =
  if n==n' 
  then return (v', True)		    -- has been overwritten 
  else readValue rest n
readValue (PAR_GET_TV n' v':rest) n =
  if n==n' 
  then return (v', True)		    -- read before
  else readValue rest n
readValue (PAR_CRE_TV n' v':rest) n =
  if n==n'
  then return (v', True)
  else readValue rest n
readValue (PAR_REM_TV n':rest) n =
  if n==n'
  then fail ("Transactional variable " ++ n ++ " has vanished")
  else readValue rest n
readValue (PAR_TRANS stid:rest) n =
  do v' <- reallyRead n
     return (v', False)
readValue (_:rest) n =
  readValue rest n

-- |Descriptor of a transactional variable.
data TV_DESC 
  = TV_DESC { tv_name :: String
	      -- ^ variable name 
	    , tv_old :: Maybe (Maybe String)
	      -- ^ value on first read
              --   @Nothing@ if not read
              --   @Just Nothing@ if created
	      --   @Just (Just val)@ first value
	    , tv_new :: Maybe (Maybe String)
	      -- ^ value after last write
	      --   @Nothing@ if not written to
	      --   @Just Nothing@ if removed
	      --   @Just (Just val)@ if @val@ was written
	    }
  deriving Show

-- |Obtain list of descriptors of transaction variables from a list of log
-- entries. Each variable has at most one descriptor. Input list is in reverse
-- chronological order, /e.g./, the earliest entries come last.
getDescriptors :: [PARAMETER] -> [TV_DESC]
getDescriptors logEntries =
  foldr f [] logEntries
  where
    f (PAR_GET_TV n v) r = doRead n v r
    f (PAR_SET_TV n v) r = doWrite n v r
    f (PAR_CRE_TV n v) r = doCreate n v r
    f (PAR_REM_TV n)   r = doRemove n r
    f _ r = r

    doCreate n v ds =
      TV_DESC {tv_name = n, tv_old = Just Nothing, tv_new = Just (Just v)}
	: ds
    doRemove n ds =
      doProcess g n ds
	where
	  g (TV_DESC { tv_old = Just Nothing } : rest) = 
	    rest
	  g (tvd : rest) =
	    tvd { tv_new = Just Nothing } : rest
	  g [] =
	    [TV_DESC {tv_name = n, tv_old = Nothing, tv_new = Just Nothing}]
    doProcess g n ds =
      f ds
      where
	f [] =
	  g []
	f ds@(d':ds') =
	  if tv_name d' == n then g ds else d' : f ds'
    doRead n v ds =
      doProcess h n ds
      where 
        h [] = 
	  [TV_DESC {tv_name = n, tv_old = Just (Just v), tv_new = Nothing }]
	h (tvd : rest) =
	  tvd : rest					    -- not first read
    doWrite n v ds = 
      doProcess h n ds
      where
        h [] = 
	  [TV_DESC {tv_name = n, tv_old = Nothing, tv_new = Just (Just v) }]
	h (tvd : rest) =
	  tvd { tv_new = Just (Just v) } : rest		    -- do write
    
-- | Get the descriptors and try to commit
commitFromLog :: [PARAMETER] -> IO Bool
commitFromLog =
  tryToCommit . getDescriptors

-- |Attempt to commit a list of descriptors by checking for the old values to
-- match and then overwriting with the new values. A read-only transaction
-- always succeeds, even if the values have changed after they have been
-- read. Returns @True@ if commit succeeded.
tryToCommit :: [TV_DESC] -> IO Bool
tryToCommit ds =
  if checkOnlyReads ds then return True else
  do L.obtainLock transactionLock
     oldValuesPreserved <- checkOldValuesPreserved ds
     when oldValuesPreserved (writeNewValues ds)
     L.releaseLock transactionLock
     return oldValuesPreserved

-- |Check if the values of all transactional variable in a list of descriptors
-- match the current values. Called with all variables locked.
checkOldValuesPreserved :: [TV_DESC] -> IO Bool
checkOldValuesPreserved [] = 
  return True
checkOldValuesPreserved (d:ds) =
  do b <- checkOldValuePreserved d
     if b then checkOldValuesPreserved ds
	  else return False

checkOldValuePreserved :: TV_DESC -> IO Bool
checkOldValuePreserved d =
  do 
  let n = tv_name d
  varExists <- reallyExists n
  case tv_old d of
    Nothing ->		-- not read, check for presence
      return varExists
    Just Nothing ->	-- created, check that it does *not* exist now
      return (not varExists)
    Just (Just ov) ->	-- read old value @ov@
      if varExists
	 then  -- value is still present; check if equal
	   do cv <- reallyRead n
	      return (cv == ov)
	 else -- value has disappeared: fail
	   return False

-- |Overwrite transactional variables from a list of descriptors with new values.
writeNewValues :: [TV_DESC] -> IO ()
writeNewValues ds = 
  mapM_ g ds
  where
    g d = 
      let n = tv_name d in
      case tv_new d of
	Nothing -> 		-- not written
	  return ()
	Just Nothing -> 	-- removed
	  reallyRemove n
	Just (Just nv) ->	-- new value
	  reallyWrite n nv

-- |Check that no variable has been written to.
checkOnlyReads :: [TV_DESC] -> Bool
checkOnlyReads ds = 
  and (map wasNotWritten ds)
  where
    wasNotWritten d =
      isNothing (tv_new d)
	 
-- |Physically access current shared value of transactional variable. Internal
-- use only.
reallyRead :: String -> IO String
reallyRead n =
  let fileName = Conf.transactionDir ++ n in
  Aux.readFileStrictly fileName

-- |Physically overwrite current shared value of transactional variable.
reallyWrite :: String -> String -> IO ()
reallyWrite n v =
  let fileName = Conf.transactionDir ++ n in
  writeFile fileName v

-- |Physically checks the existence of a transactional variable.
reallyExists :: String -> IO Bool
reallyExists n =
  let fileName = Conf.transactionDir ++ n in
  doesFileExist fileName

-- |Physically remove transactional variable.
reallyRemove :: String -> IO ()
reallyRemove n =
  let fileName = Conf.transactionDir ++ n in
  removeFile fileName
