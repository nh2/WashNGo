-- © 2003 Peter Thiemann
{-|
Implements Locking via directory creation, which seems to be the only portable
way to do it through Haskell's standard IO library.
-}
module WASH.Utility.Locking (obtainLock, releaseLock) where

import Data.Convertible (convert)
import WASH.Utility.Auxiliary
import System.Directory
import System.IO
import System.Process (system)
import System.Time

obtainLock  :: FilePath -> IO ()
releaseLock :: FilePath -> IO ()

lockPath name = name ++ ".lockdir"

obtainLock name =
  assertDirectoryExists (lockPath name)
                        (system "sleep 1" >> obtainLockLoop name)

releaseLock name =
  removeDirectory (lockPath name)

obtainLockLoop name =
  let lp = lockPath name in
  do b <- doesDirectoryExist lp
     if b then do -- check if lock is stale
		  mtime <- getModificationTime lp
		  ftime <- getModificationTime name
		  ctime <- getClockTime
		  let td = diffClockTimes ctime (convert mtime)
		      tf = diffClockTimes ctime (convert ftime)
		  if tdSec td > 60 && tdSec tf > 60
		    then do removeDirectory lp
			    obtainLock name
		    else do system "sleep 1"
			    obtainLockLoop name
		    
          else obtainLock name
