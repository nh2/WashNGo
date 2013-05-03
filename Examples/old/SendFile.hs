-- © 2002 Peter Thiemann
module Main where

import Data.Char
import System.Directory
import Data.List hiding (head, span, map)
import Data.Maybe
import System.Random
import Prelude hiding (head, div, span, map)
import WASH.HTML.HTMLMonad
import WASH.CGI.CGI

fileList = [("lp/part1.ps", "langproc")]
storeDirectory = "/home/thiemann/public/"

main = 
  run $ standardQuery "SendFile" $
 table $ do
  pcNameF   <- tr (td (text "File name") >>
                   td (textInputField (fieldSIZE 20)))
  passwordF <- tr (td (text "Password") >>
                   td (passwordInputField (fieldSIZE 20)))
  tr (td (submit (F2 pcNameF passwordF) sendFile (fieldVALUE "SEND")) >> td empty)

sendFile (F2 fileNameF passwordF) =
  let fileName = value fileNameF
      password = value passwordF
  in if validPassword fileName password 
     then tell 
         FileReference { fileReferenceName = storeDirectory ++ fileName
	               , fileReferenceContentType = guessContentType fileName
		       , fileReferenceExternalName = ""
		       }
      else htell $ standardPage "Login incorrect" $ backLink empty

guessContentType name 
  | ".ps"	`isSuffixOf` name = "application/postscript"
  | ".ps.gz"	`isSuffixOf` name = "application/postscript"   -- correct?
  | ".pdf"	`isSuffixOf` name = "application/pdf"
  | ".html"	`isSuffixOf` name = "text/html"
  | otherwise = "application/octet-stream"

validPassword name password = 
  case lookup name fileList of
    Just pw | password == pw -> True
    _                        -> False
