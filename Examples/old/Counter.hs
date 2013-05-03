-- © 2001, 2002 Peter Thiemann
module Main where

import Prelude hiding (map, span, head, div)
import WASH.CGI.CGI

main = 
  run mainCGI

mainCGI =
  counter 0

counter n =
  standardQuery "Counter" $ p $
  do text "Current counter value "
     text (show n)
     br empty
     submit0 (counter (n + 1)) (fieldVALUE "Increment")
     submit0 (counter (n - 1)) (fieldVALUE "Decrement")
