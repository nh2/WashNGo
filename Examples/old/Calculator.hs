-- � 2001-2005 Peter Thiemann
module Main where

import Char
import Prelude hiding (head, span, map)
import WASH.CGI.CGI hiding (div)

main = 
  run mainCGI

mainCGI = 
  calc "0" id

calc dstr f =
  standardQuery "Calculator" $ table $
  do dsp <- tr (td (textInputField (fieldVALUE dstr) ## attr "colspan" "4"))
     let button c = td (submit dsp (calcAction c f) (fieldVALUE [c]))
     tr (button '1' ## button '2' ## button '3' ## button '+')
     tr (button '4' ## button '5' ## button '6' ## button '-')
     tr (button '7' ## button '8' ## button '9' ## button '*')
     tr (button 'C' ## button '0' ## button '=' ## button '/')

calcAction c f dsp
  | isDigit c = calc (dstr ++ [c]) f
  | c == 'C'  = mainCGI
  | c == '='  = calc (show (f (read dstr :: Integer))) id
  | otherwise = calc "0" (optable c (read dstr :: Integer))
  where dstr = value dsp
	optable '+' = (+)
	optable '-' = (-)
	optable '*' = (*)
	optable '/' = div
  
  
