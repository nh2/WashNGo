-- © 2001 Peter Thiemann
module Main where

import Data.Maybe
import Prelude hiding (head, div, map, span)
import WASH.HTML.HTMLMonad
import WASH.CGI.CGI

main = 
  run mainCGI
mainCGI =
  (standardQuery "Computation, Part 1"
	  (
	  do text "Computation: First number = "
	     f1 <- inputField (fieldSIZE 10)
	     text ". Second number = "
	     f2 <- inputField (fieldSIZE 10)
	     hr empty
	     submit (F2 f1 f2) (computation "addition" "+" (+)) 
	     		 (fieldVALUE "Add them")
	     submit (F2 f1 f2) (computation "subtraction" "-" (-))
	     		 (fieldVALUE "Subtract them")
	     submit f1 showIt (fieldVALUE "Show field 1")))

showIt inf =
  let n1 = value inf in
  htell $ standardPage ("Show field 1")
	  (text (show n1))
  

computation longname shortname op (F2 f1 f2) =
  let { n1, n2 :: Int; n1 = value f1; n2 = value f2 } in
  htell $ standardPage ("Result of " ++ longname)
	  (text (show n1)
	  ## text (" " ++ shortname ++ " ")
	  ## text (show n2)
	  ## text " = "
	  ## text (show (n1 `op` n2)))
