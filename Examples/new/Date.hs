-- © 2001, 2002 Peter Thiemann
module Main where

import Prelude hiding (head, span, div, map)
import WASH.CGI.CGI

main =
  run mainCGI

{- 
getDate =
  table $ do
    day <- tr (td (text "Day") ## td (inputField empty))
    month <- tr (td (text "Month") ## td (inputField empty))
    return (day, month)
-}

dateForm =
  <#> <table>
       <tr><td>Day</td><td><% day <- inputField empty %></td></tr>
       <tr><td>Month</td><td> <% month <- inputField empty %> </td></tr>
     </table>
    <input type="submit" WASH:callback="displayDate" WASH:parms="day,month" />
  </#>

showDate :: (Int, Int) -> WithHTML x CGI ()
showDate (day :: Int, month :: Int) =
  <#><%= month %>/<%= day %></#>

displayDate :: (Int, Int)        -> CGI ()
displayDate theDate =
  standardQuery "displayDate" (showDate theDate)

mainCGI =
  (standardQuery "Hello World" dateForm)
