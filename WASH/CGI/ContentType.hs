-- © 2001, 2002 Peter Thiemann
module WASH.CGI.ContentType where

import Data.Char
import Data.List (isSuffixOf)

-- |tries to derive a MIME content type from a file name
guessContentType :: String -> String
guessContentType name = g (map toLower name) 
 where
 g name
  | ".eps"	`isSuffixOf` name = "application/postscript"
  | ".ps"	`isSuffixOf` name = "application/postscript"
  | ".ps.gz"	`isSuffixOf` name = "application/postscript"   -- correct?
  | ".pdf"	`isSuffixOf` name = "application/pdf"
  | ".html"	`isSuffixOf` name = "text/html"
  | ".gif"	`isSuffixOf` name = "image/gif"
  | ".png"	`isSuffixOf` name = "image/png"
  | ".jpg"	`isSuffixOf` name = "image/jpeg"
  | otherwise = "application/octet-stream"
