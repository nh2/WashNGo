-- © 2001, 2002 Peter Thiemann
module Main where

import Random
import Prelude hiding (head, span, map, div)
import List hiding (head, span, map)

import WASH.CGI.CGI
import qualified WASH.CGI.Persistent2 as P
import qualified WASH.CGI.Cookie as C

type Score = (Int, String)

highScoreStore :: CGI (P.T [Score])
highScoreStore = P.init "GuessNumber" []

setNumber :: Int -> CGI (C.T (Int, Int))
setNumber aNumber = C.create "theNumber" (0, aNumber)

main :: IO ()
main =
  run mainCGI

mainCGI = (once $
  do aNumber <- io (randomRIO (1,100))
     numHandle <- setNumber aNumber
     standardQuery "Guess a number" $
       do submit0 (play numHandle "I've thought of a number between 1 and 100.")
                      (fieldVALUE "Play the game")
	  submit0 admin (fieldVALUE "Check scores"))
  >> mainCGI

play aHandle aMessage =
  standardQuery "Guess a number" $
    do text aMessage
       text " Make a guess "
       activeInputField (processGuess aHandle) empty

processGuess aHandle aGuess =
  do mValue <- C.get aHandle
     case mValue of
       Just (nGuesses, aNumber) ->
         let nGuesses' = nGuesses + 1 in
	 if aNumber == aGuess 
         then C.delete aHandle >> youGotIt nGuesses' aNumber
	 else do Just aHandle' <- C.set aHandle (nGuesses', aNumber)
		 play aHandle' ("Your guess " ++
                                show aGuess ++ " was too " ++
				if aGuess < aNumber then "small."
		      		                    else "large.")
       Nothing ->
         standardQuery "Don't do that!" $ do
           text "You are trying to outwit me by playing with backbuttons and cloning windows!"
	   submit0 (return ()) (fieldVALUE "Restart")

youGotIt nGuesses aNumber =
  standardQuery "You got it!" $
  do text "CONGRATULATIONS!"
     br empty
     text "It took you "
     text $ show nGuesses
     text " tries to find out."
     br empty
     text "Enter your name for the hall of fame "
     activeInputField (addToHighScore nGuesses) empty

addToHighScore nGuesses nameF =
  let name = unText nameF in
  if name == "" then return () else
  do highScoreList <- highScoreStore
     P.add highScoreList (nGuesses, name)
     return ()

admin = 
  do highScoreList <- highScoreStore
     highScores <- P.get highScoreList
     standardQuery "GuessNumber - High Scores" $ do
       table $ do
         attr "border" "border"
	 tr (th (text "Name") ## th (text "# Guesses"))
	 mapM_ g (sort highScores)
       submit0 (return ()) (fieldVALUE "Continue")
  where
    g (guesses, name) =
      tr (td (text name) ## td (text (show guesses)))
