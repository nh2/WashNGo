{-# LANGUAGE PackageImports #-}

module Main where

-- ghc --make WASHMain -package text -o WASHMain

import Data.List (isSuffixOf)
import Control.Exception
import System.Directory
import System.Environment
import System.IO

import WASHGenerator
import WASHFlags

main =
  do args <- getArgs
     runPreprocessor flags0 args

runPreprocessor flags [washfile] =
  do fileExists <- doesFileExist washfile
     if ".wash" `isSuffixOf` washfile 
	then
	preprocess flags washfile (take (length washfile - 5) washfile ++ ".hs") ""
	else if fileExists
	then
	bracket (openFile washfile ReadMode)
	  hClose
	  (\ inhandle -> preprocessPIPE flags washfile inhandle stdout "")
	else
	preprocess flags
             (washfile ++ ".wash")
	     (washfile ++ ".hs")
	     ""
runPreprocessor flags [washfile, hsfile] =
  preprocess flags (washfile) (hsfile) ""
runPreprocessor flags [originalFile, washfile, hsfile] =
  preprocess flags (washfile) (hsfile) ""
runPreprocessor flags [] =
  preprocessPIPE flags "<stdin>" stdin stdout ""
runPreprocessor flags args =
  do progName <- getProgName
     hPutStrLn stderr ("Usage: " ++ progName ++ " washfile [hsfile]")
     hPutStrLn stderr ("   or: " ++ progName ++ " originalFile infile outfile")
     hPutStrLn stderr ("   or: " ++ progName)
     hPutStrLn stderr ("       to run as pipe processor")
     hPutStrLn stderr ("Actual arguments: " ++ show args)
