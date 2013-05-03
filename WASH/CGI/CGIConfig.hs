{-# LANGUAGE ScopedTypeVariables #-}
-- © 2002 Peter Thiemann
module WASH.CGI.CGIConfig where

import Control.Exception
import System.Environment
import System.IO
import System.IO.Unsafe

tmpDir, varDir, imageDir, emailTmpDir, frameDir, persistentDir, persistent2Dir, registryDir, keyFile, pbmPath, catProgram, sendmailProgram :: String

-- |global root for WASH data
globalRoot :: String
globalRoot =
  unsafePerformIO (catch (getEnv "HOME") (\ (ioe :: SomeException) -> return ""))

-- temporary storage
tmpDir = globalRoot ++ "/tmp/"
-- persistent, mutable storage
varDir = globalRoot ++ "/tmp/"

imageDir 	= tmpDir ++ "Images/"
emailTmpDir 	= tmpDir
frameDir	= tmpDir ++ "Frames/"
persistentDir 	= varDir ++ "Persistent/"
persistent2Dir 	= varDir ++ "Persistent2/"
transactionDir  = varDir ++ "Transactions/"
registryDir	= tmpDir ++ "REGISTRY/"
keyFile		= varDir ++ "KEYFILE"

-- path to PBMplus programs
pbmPath		= "/usr/X11R6/bin/"
-- path of cat program
catProgram	= "/bin/cat"
-- path of sendmail program
sendmailProgram	= "/usr/sbin/sendmail"
