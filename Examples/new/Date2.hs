-- © 2001, 2002 Peter Thiemann
{-# ghc_options -fglasgow-exts -}
module Main where

import Prelude hiding (head, span, div, map)
import WASH.CGI.CGI

main =
  run mainCGI

getDate :: WithHTML x CGI (InputField Date INVALID)
getDate =
  table $ do
    (day :: InputField Date INVALID) <- tr (td (text "Day") >> td (inputField empty))
    month <- tr (td (text "Month") >> td (inputField empty))
    let dm = concatFieldsWith (\dayStr [monthStr] -> '(':dayStr++',':monthStr++")")
			        day [month] 
    return dm

{-
dateForm =
  <#> <table>
       <tr><td>Day</td><td><% day <- inputField empty %></td></tr>
       <tr><td>Month</td><td> <% month <- inputField empty %> </td></tr>
     </table>
    <input type="submit" WASH:callback="displayDate" WASH:parms="day,month" />
  </#>
-}

datesForm =
  <#> <table>
       <tr><td>Arrival</td><td><% arrival <- getDate %></td></tr>
       <tr><td>Departure</td><td> <% departure <- getDate %> </td></tr>
     </table>
    <input type="submit" WASH:callback="displayDates" WASH:parms="arrival,departure" />
  </#>

showDate :: (Int, Int) -> WithHTML x CGI ()
showDate (day, month) =
  <#><%= month %>/<%= day %></#>

type Date = (Int, Int)

showDates :: (Date, Date) -> WithHTML x CGI ()
showDates (arr, dept) =
  <#>Arrival <% showDate arr %> Departure <% showDate dept %></#>

displayDates :: ((Int, Int),(Int, Int)) -> CGI ()
displayDates theDates =
  standardQuery "displayDate" (showDates theDates)

mainCGI =
  (standardQuery "Hello World" datesForm)
