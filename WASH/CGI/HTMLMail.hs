module WASH.CGI.HTMLMail where

import Prelude hiding (head,div,span)
import WASH.HTML.HTMLMonad hiding (map)
import WASH.Mail.MIME 

-- |transform HTML Element into document suitable for sending as email.
htmlDOC :: Element -> DOC
htmlDOC el = 
  binaryDOC "text" "html" (show el)
