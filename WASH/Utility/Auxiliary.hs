{-# LANGUAGE ScopedTypeVariables #-}

module WASH.Utility.Auxiliary where

import Control.Exception
import System.Directory
import System.Environment
import System.IO
import System.IO.Error
import System.Process (system)
import WASH.Utility.FileNames
import qualified WASH.Utility.Shell as Shell

protectedGetEnv :: String -> String -> IO String
protectedGetEnv var deflt =
  catch (getEnv var) (\ (e :: SomeException) -> return deflt)

readFileNonExistent :: FilePath -> String -> IO String
readFileNonExistent fileName def =
  do existent <- doesFileExist fileName
     if existent then readFile fileName else return def

readFileStrictly :: FilePath -> IO String
readFileStrictly filePath =
  do h <- openFile filePath ReadMode
     contents <- hGetContents h
     hClose (g contents h)
     return contents
  where
    g [] h = h
    g (_:rest) h = g rest h

assertDirectoryExists :: FilePath -> IO () -> IO ()
assertDirectoryExists dirname existsAction =
  catch (createDirectory dirname)
        (\ (ioe :: IOException) -> 
	   if isAlreadyExistsError ioe then existsAction
	   else if isDoesNotExistError ioe then
	     do assertDirectoryExists (dropLastComponent dirname) (return ())
		assertDirectoryExists dirname existsAction
	   else do hPutStrLn stderr ("assertDirectoryExists " ++ show dirname)
		   ioError ioe)

writeDebugFile :: String -> String -> IO ()
writeDebugFile filename str =
  do writeFile filename str
     system ("chmod 666 " ++ Shell.quote filename)
     return ()

appendDebugFile :: String -> String -> IO ()
appendDebugFile filename str =
  do appendFile filename ('\n':str)
     system ("chmod 666 " ++ Shell.quote filename)
     return ()
