-- © 2001-2005 Peter Thiemann
module Main where

-- import Prelude hiding (map, span, head, div)
import WASH.CGI.CGI

main = 
  run mainCGI

mainCGI =
  counter 0

counter n =
  standardQuery "Counter" 
    <p>Current counter value <%= n %><br />
     <input type="submit" WASH:callback="counter (n+1)" />
     <input type="submit" WASH:callback="counter (n-1)" />
    </p>
