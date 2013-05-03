-- © 2001, 2002 Peter Thiemann
module Main where

import Random
import Prelude hiding (head, div, span, map)
import List hiding (head, span, map)

import WASH.HTML.HTMLMonad
import WASH.CGI.CGI
import qualified WASH.CGI.Persistent2 as P

import Score

highScoreStore :: CGI (P.T [Score])
highScoreStore = P.init "GuessNumber" []

main :: IO ()
main =
  run mainCGI

mainCGI =
  io (randomRIO (1,100)) >>= \ aNumber ->
  standardQuery "Guess a number" $
    do submit0 (play 0 (aNumber :: Int) "I've thought of a number between 1 and 100.")
                   (fieldVALUE "Play the game")
       submit0 admin (fieldVALUE "Check scores")

play nGuesses aNumber aMessage =
  standardQuery "Guess a number" $
    do text aMessage
       text " Make a guess "
       activeInputField (processGuess (nGuesses + 1) aNumber) empty

processGuess nGuesses aNumber aGuess =
  if aNumber == aGuess then
    youGotIt nGuesses aNumber
  else if aGuess < aNumber then
    play nGuesses aNumber ("Your guess " ++ show aGuess ++ " was too small.")
  else
    play nGuesses aNumber ("Your guess " ++ show aGuess ++ " was too large.")

youGotIt nGuesses aNumber =
  standardQuery "You got it!" $ 
  do text "CONGRATULATIONS!"
     br empty
     text "It took you "
     text (show nGuesses)
     text " tries to find out."
     br empty
     text "Enter your name for the hall of fame "
     nameF <- textInputField empty
     br empty
     defaultSubmit nameF (addToHighScore nGuesses) (fieldVALUE "ENTER")

addToHighScore nGuesses nameF =
  let name = value nameF in
  if name == "" then admin else
  do highScoreList <- highScoreStore
     P.add highScoreList (Score name nGuesses)
     admin

admin = 
  do highScoreList <- highScoreStore
     highScores <- P.get highScoreList
     standardQuery "GuessNumber - High Scores" $ table $
       (tr (th (text "Name") ## th (text "# Guesses")) ##
        foldr g empty (sort highScores) ##
	attr "border" "border")
  where
    g (Score name guesses) elems =
      tr (td (text name) ## td (text (show guesses))) ## elems
