-- © 2001, 2002 Peter Thiemann
module Main where

import Prelude hiding (head, span, div, map)
import WASH.CGI.CGI

main =
  run mainCGI

mainCGI =
  (standardQuery "Hello World" empty)
