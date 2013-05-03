-- © 2001-2005 Peter Thiemann
module Main where

import Prelude hiding (head, div, span, map)
import WASH.HTML.HTMLMonad
import Random
import WASH.CGI.CGI

main = 
  run mdrill

question prompt def =
  <tr>
    <td><%= prompt %></td>
    <td><% inputField (fieldVALUE def) %></td>
  </tr>

mdrill =
  standardQuery "Multiplication Drill" 
    <table>
      <% factor <- question "Choose a factor: " 2 %>
      <% rept   <- question "Number of exercises: " 20 %>
      <tr>
	<td><input type="submit" value="START"
		   WASH:callback="multiply" WASH:parms="factor,rept"/>
	</td>
      </tr>
    </table>

multiply :: (Int, Int) -> CGI ()
multiply (n, r) = 
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
      call = (multiplyBy n r (i + 1) 
			 (if correct then factor : successes else successes)
			 (if correct then failures else factor : failures))
  in
  standardQuery ttl 
    <p>
      <%= factor %> x <%= n %> = <%= n * factor %>.
      Your answer: <%= a %>.
      <% if correct then text "CORRECT!" else text "WRONG." %>
      <br />
      <input type="submit" value="CONTINUE" WASH:callback="call" />
    </p>

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
  
