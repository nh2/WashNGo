module Login where

import WASH.CGI.CGI
import WASH.HTML.HTMLMonad

main =
  run (check $ F2 (error "") (error ""))
login =
  ask (standardPage "LOGIN" $ makeForm $ table $
  do name <- tr (td (text "Enter your name ") >>
                 td (textInputField (attr "size" "10")))
     pass <- tr (td (text "Enter your password ") >>
                 td (textInputField (attr "size" "10")))
     tr (td (submit (F2 name pass) check (attr "value" "LOGIN"))))

check (F2 name pass) = 
  ask $ standardPage "BYTEINPUT" $ makeForm $
  do bi <- byteInput (return ())
     submit0 login (attr "value" "CHECK")


byteInput :: HTMLField (InputField Int INVALID)
byteInput = byteInput' 1 InputField{ifString=Just "", ifValue=Just 0}
byteInput' i acc attr =
  if i > 256 then return acc else
  do bi <- checkboxInputField attr
     acc' <- byteInput' (2*i) acc attr
     return acc'{ifValue= ifValue acc' >>= \v -> ifValue bi >>= \b -> return (b2i b)}
  where b2i False = 0
	b2i True = 1


