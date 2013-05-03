module WASH.CGI.CGIHistory where

import System.IO.Unsafe (unsafePerformIO)

import Data.Maybe (fromMaybe)
import System.IO
import Control.Monad
import Control.Concurrent
import Control.Concurrent.MVar
import qualified Data.Map as Map
-- 
import WASH.Utility.SHA1
import WASH.CGI.RawCGITypes
import WASH.CGI.CGIMonad
import WASH.CGI.LogEntry

-- | standard value for timeout of interaction threads: one hundred seconds
historyTimeout :: Int
historyTimeout = 100000000

-- | comprises the name of the application and a hash value.
type StateID = (String, String)

{-# NOINLINE history #-}
history :: MVar (Map.Map StateID TableEntry)
history = unsafePerformIO $ newMVar Map.empty

data TableEntry =
    TableEntry 
      { myID :: StateID		    		    -- ^ script name and hash key
      , parentID :: Maybe StateID		    -- ^ root has no parent
      , nextparm :: PARAMETER
      , timeout :: Int				    -- ^ timeout for this stage of interaction
      , threads :: MVar [MVar (CGIParameters, Handle)]-- ^ next round of parameters and output handle
      }

-- | Takes the id of the current node, the id of the father node (if any), the
-- current parameter, and (perhaps) a timeout value for the current interaction
-- and enters a corresponding record into the history table.
createEntry :: StateID -> Maybe StateID -> PARAMETER -> Maybe Int -> IO ()
createEntry myID parentID nextparm mTimeout = do
  -- putStrLn ("createEntry "++ show myID ++ " "++ show parentID ++ " " ++ show nextparm)
  threadsvar <- newMVar []
  let protoEntry = TableEntry { myID = myID
			      , parentID = parentID
			      , nextparm = nextparm
			      , timeout = fromMaybe historyTimeout mTimeout
			      , threads = threadsvar
			      }
  modifyMVar_ history (return . Map.insertWith (\ new old -> old) myID protoEntry)
  -- putStrLn ("createEntry finished")

-- | Suspends the current thread by waiting on an entry with the current node's
-- id. Returns the parameters passed to this node.
readParameters :: StateID -> IO (CGIParameters, Handle)
readParameters stateID = do
  -- putStrLn ("readParameters "++ show stateID)
  (myVar, myTimeout) <- modifyMVar history update
  myID <- myThreadId
  killerID <- forkIO (killmeOnTimeout myID myVar myTimeout)
  ch <- takeMVar myVar			    -- suspend until notify puts s.t.
  killThread killerID
  -- putStrLn ("readParameters "++ show stateID ++ " returns " ++ show ch)
  return ch
  where
    update t = do 
      let Just entry = Map.lookup stateID t
      myVar <- newEmptyMVar
      modifyMVar_ (threads entry) (\ ms -> return (myVar : ms))
      return (t, (myVar, timeout entry))
    remove v t = do
      let Just entry = Map.lookup stateID t
      modifyMVar (threads entry) (\ ms -> return (filter (/= v) ms, v `elem` ms))
    killmeOnTimeout tid var timeout = do
      threadDelay timeout
      wasPresent <- withMVar history (remove var)
      when wasPresent (killThread tid)
      -- putStrLn ("killmeOnTimeout: had to kill = "++show wasPresent)
      -- otherwise thread tid is on its way to kill me

-- | Attempts to pass parameters and a handle to a thread waiting for the given
-- stateID. Returns True if successful and False if no such thread was found.
notify :: StateID -> CGIParameters -> Handle -> IO Bool
notify stateID parms hout = do
  -- putStrLn ("notify "++ show stateID ++ " "++ show parms ++ " " ++ show hout)
  b <- withMVar history update
  -- putStrLn ("notify returns "++ show b)
  return b
  where
    update t = 
      case Map.lookup stateID t of
	Just entry ->
	  do maybeVar <- modifyMVar (threads entry) (return . uncons)
	     case maybeVar of
	       Just myVar -> do
		 putMVar myVar (parms, hout)
		 return True
	       Nothing ->
		 return False
	Nothing ->		   -- may happen after server restart
	  return False

uncons (x : xs) = (xs, Just x)
uncons []       = ([], Nothing)
