-- © 2001, 2002 Peter Thiemann
module Main where

import Prelude hiding (head, div, span, map)
import WASH.HTML.HTMLMonad
import System.Random
import WASH.CGI.CGI

main = 
  run mdrill

question prompt def =
  tr (do td (text prompt)
	 td (inputField (fieldVALUE def)))

mdrill =
  (standardQuery "Multiplication Drill" $ table $
       do factor <- question "Choose a factor: " 2
	  rept   <- question "Number of exercises: " 20
	  tr (td (submit (F2 factor rept) multiply (fieldVALUE "START"))))

multiply (F2 factor rept) = 
  let { n, r :: Int; 
	n = value factor; 
	r = value rept } in
  multiplyBy n r 1 [] []

multiplyBy n r i successes failures =
  if i == r + 1
  then report successes failures
  else io (randomRIO (0,12)) >>= \factor ->
  let ttl = "Multiplication Drill; Exercise " ++ show i ++ " of " ++ show r in
  (standardQuery ttl 
      (do text (show factor ++ " x " ++ show n ++ " = ")
	  activeInputField (checkAnswer n r i factor successes failures)
	                   (fieldSIZE 3)))

checkAnswer n r i factor successes failures a =
  let correct = a == n * factor 
      ttl = "Multiplication Drill; Solution " ++ show i ++ " of " ++ show r
  in
  standardQuery ttl $
    do text (show factor ++ " x " ++ show n ++ " = " ++ show (n * factor))
       text (". Your answer: " ++ show a ++ ". ")
       if correct then text "CORRECT!" else text "WRONG."
       br empty
       submit0 (multiplyBy n r (i + 1) 
	       (if correct then factor : successes else successes)
	       (if correct then failures else factor : failures))
	       (fieldVALUE "CONTINUE")

report successes failures =
  standardQuery "Final Report" (evaluation successes failures)

evaluation successes failures =
  let s = length successes
      f = length failures
      n = s + f
      comment
       | f == 0 = text "Excellent!"
       | s >= 2 * f = text ("Good, but you need to look at " ++ show failures)
       | s >= f = text ("Fair, but you must look at " ++ show failures)
       | s <  f = text ("Unsatisfactory. You need to practice " ++ show failures)
  in  comment
  
