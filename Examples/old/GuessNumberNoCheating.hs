-- © 2001, 2002 Peter Thiemann
module Main where

import Random
import Prelude hiding (head, span, map, div)
import List hiding (head, span, map)

import WASH.HTML.HTMLMonad
import WASH.CGI.CGI
import qualified WASH.CGI.Persistent2 as P

import Score

highScoreStore :: CGI (P.T [Score])
highScoreStore = P.init "GuessNumberNoCheating" []

main :: IO ()
main =
  run mainCGI

mainCGI =
  standardQuery "Guess a number" $
    do submit0
	 (play 0 ((1,100) :: (Int,Int)) "I've thought of a number between 1 and 100.")
         (fieldVALUE "Play the game")
       submit0 admin (fieldVALUE "Hall of Fame")

play nGuesses ivl aMessage =
  standardQuery "Guess a number" $
    do text aMessage
       text " Make a guess "
       activeInputField (processGuess (nGuesses + 1) ivl) empty

processGuess nGuesses ivl@(low,hi) aGuess =
  io (randomRIO ivl) >>= \ aNumber ->
  if aNumber == aGuess then
    youGotIt nGuesses
  else if aGuess < aNumber then
    let nextivl = if aGuess < low then ivl else (max low aGuess + 1, hi) in
    play nGuesses nextivl ("Your guess " ++ show aGuess ++ " was too small.")
  else
    let nextivl = if aGuess > hi then ivl else (low, min aGuess hi - 1) in
    play nGuesses nextivl ("Your guess " ++ show aGuess ++ " was too large.")

youGotIt nGuesses =
  standardQuery "You got it!" $
  do text "CONGRATULATIONS!"
     br empty
     text "It took you "
     text $ show nGuesses
     text " tries to find out."
     br empty
     text "Enter your name for the hall of fame "
     nameF <- textInputField empty
     br empty
     defaultSubmit nameF (addToHighScore nGuesses) empty

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
