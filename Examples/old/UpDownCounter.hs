-- © 2001, 2002 Peter Thiemann
module Main where

import Prelude hiding (head, div, span, map)
import WASH.HTML.HTMLMonad
import WASH.CGI.CGI

main = 
  run mainCGI

mainCGI = 
  counter 0

counter :: Int -> CGI ()
counter n =
  standardQuery "UpDownCounter" $
  do text "Current counter value"
     cnt <- activeInputField counter (fieldVALUE (show n))
     submit0 (counter (n + 1)) (fieldVALUE "++")
     submit0 (counter (n - 1)) (fieldVALUE "--")
  
