-- © 2001 Peter Thiemann
module Main where

import List

import WASH.CGI.CGI hiding (map, div, span, head)
import WASH.CGI.CGIGraphics

translator (name:_) =
  tell 
  FileReference { fileReferenceName = storeDirectory ++ name
  		, fileReferenceContentType = guessContentType name
		}

guessContentType name 
  | ".ps" `isSuffixOf` name = "application/postscript"
  | ".ps.gz" `isSuffixOf` name = "application/postscript"   -- correct?
  | ".pdf" `isSuffixOf` name = "application/pdf"
  | ".html" `isSuffixOf` name = "text/html"
  | ".gif" `isSuffixOf` name = "image/gif"
  | otherwise = "application/octet-stream"

main = runWithHook [] translator mainCGI

mainCGI =
  ask (standardPage "UseGraphics" $
       makeForm $
       activeImage testImage)

canvas_red = newImage (100,100) (255,0,0)
oval_blue = fillOval canvas_red (20,20) (70,50) (0,0,255)
background = activateImage oval_blue hitNothing
testImage = activateColor background (0,0,255) hitOval
textImage = makeText "HIT ME!" (255,255,255)
testImage2 = (testImage `overlay` textImage) (30,30) (255,255,255)

hitOval = htell (standardPage "Hit the Oval!" empty)
hitNothing = htell (standardPage "Missed." empty)

