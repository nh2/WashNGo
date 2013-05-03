-- © 2001, 2002 Peter Thiemann
module Main where

import Prelude hiding (map, span, head, div)
import WASH.CGI.CGI

import qualified Persistent2 as P

counterStore :: CGI (P.T Int)
counterStore = P.init "Counter" 0

main = 
  run mainCGI

mainCGI =
  forever counter

counter = do
  counterHandle <- counterStore
  counterValue <- P.get counterHandle
  standardQuery "Counter" $ p $
   do text "Current counter value "
      text (show counterValue)
      br empty
      submit0 (count counterHandle (counterValue+1)) (fieldVALUE "Increment")
      submit0 (count counterHandle (counterValue-1)) (fieldVALUE "Decrement")

count h n = do
  r <- P.set h n
  case r of
    Just _ -> 
      return ()
    Nothing ->
      standardQuery "CounterMistake" $ p $
	do text "Your attempt to set the counter to "
	   text (show n)
	   text " was not successful. "
	   text "Someone else was quicker :-)"
	   submit0 (return ()) (fieldVALUE "Continue")

