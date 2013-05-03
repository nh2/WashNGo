-- © 2006 Peter Thiemann
{- | Simple seat reservation using transactional variables.
-}
module Main where

import WASH.CGI.CGI hiding (map)
import qualified WASH.CGI.Transaction as T

import Control.Monad

type SeatCategory = Char
seatCategories :: [SeatCategory]
seatCategories = ['A'..'J']
seatNumbers :: [Int]
seatNumbers = [0..9]

appTitle = "WASH my Seat"

main =
  run mainCGI
    
-- | step 1: choose a seat category
mainCGI =
  standardQuery appTitle
  <#>
    <h3>The WASH-based reservation system</h3>
    <p>Choose a category:</p>
    <table border="1">
      <tr><td align="center">STAGE</td></tr>
      <% mapM_ makeCategoryButton seatCategories %> 
    </table>
  </#>

-- | create a button for seat category in overview
makeCategoryButton seatCategory =
  let carving = attr "value" ("Category " ++ [seatCategory]) in
  <tr><td><input type="submit" WASH:callback="attemptReservation seatCategory" 
		 <%carving%> /></td></tr>

type MyTransactionState = ()

-- | step 2: choose from available seats
attemptReservation seatCategory =
  T.with () (\ tr_state my_state rollback commit ->
    let action = getSeatInfo seatCategory commit in
    case tr_state of
      T.Initial -> action
      T.Rollback -> action
      T.FailedToCommit -> commitFailed rollback action
      T.FailedToComplete -> commitFailed rollback action
    )
  >> goodBye 0

commitFailed rollback action =
  standardQuery (appTitle ++ ": Seat Reservation Impossible")
    <#>
      <h3>We were unable to complete your seat reservation request</h3>
      <h3>Do you want to try again?</h3>
      <input type="submit" value="TRY AGAIN" WASH:callback="action" />
      <input type="submit" value="EXIT" WASH:callback="rollback Nothing"/>
    </#>

getSeatInfo seatCategory commit =
    do seatHandles <- initSeats seatCategory
       seatStates  <- mapM checkSeat seatHandles
       standardQuery (appTitle ++ ": Seat Offerings in Category " ++ [seatCategory])
	 <#>
	 <h3>Available seats</h3>
	 <table>
	   <tr><% buttons <- zipWithM makeSeatButton seatStates seatNumbers %></tr>
	 </table>
	 <% submit (FL buttons) 
		   (chosenSeats seatCategory commit seatHandles)
		   (attr "value" "CHOOSE") %>
	 </#>

makeSeatButton seatState seatNumber =
  let myColor | seatState = "background-color: red"
	      | otherwise = "background-color: green"
      disabled | seatState = attr "disabled" "disabled"
	       | otherwise = empty
  in
  td $ do
    attr "style" myColor
    text "Seat "
    text (show seatNumber)
    text " "
    checkboxInputField disabled
  
initSeats seatCategory =
  mapM initSeat seatNumbers
  where
    initSeat i = T.init ("SEAT-" ++ seatCategory : show i) False

checkSeat seatHandle =
  T.get seatHandle

reserveSeat occupy seatHandle =
  when occupy $ T.set seatHandle occupy
  
-- | step 3: submit payment information
chosenSeats seatCategory commit seatHandles (FL buttons) =
  let reservations = map value buttons in
  zipWithM_ reserveSeat reservations seatHandles >>
  standardQuery (appTitle ++ ": Enter Payment Data")
  <#>
    <% displayReservations seatCategory reservations seatNumbers %>
    <h3>Enter Payment Data</h3>
    <table>
      <tr><td>Name</td> <td><input type="text" name="name" /></td></tr>
      <tr><td>Address</td> <td><input type="text" name="address" /></td></tr>
      <tr><td>Acct. Info</td> <td><input type="text" name="acctinfo" /></td></tr>
    </table>
    <p><input type="submit" value="ENTER" 
	      WASH:callback="confirmReservation seatCategory reservations commit" 
	      WASH:parms="name,address,acctinfo" />
    </p>
  </#>

displayReservedSeat reservation seatNumber =
  if reservation
  then text (' ':show seatNumber)
  else empty

displayReservations seatCategory reservations seatNumbers =
  <#>
    <h3>Your Chosen Seats</h3>
    Category <%= [seatCategory] %>,
    Seats<% zipWithM_ displayReservedSeat reservations seatNumbers %>
  </#>

-- | step 4: confirm reservation
confirmReservation seatCategory reservations commit (nameU, addressU, acctinfoU) =
  let name = unNonEmpty nameU
      address = unNonEmpty addressU
      acctinfo = unNonEmpty acctinfoU
  in
  standardQuery (appTitle ++ ": Confirm Your Data")
  <#>
    <% displayReservations seatCategory reservations seatNumbers %>
    <h3>Your Payment Data</h3>
    <table>
      <tr><td>Name</td> <td><%= name %></td></tr>
      <tr><td>Address</td> <td><%= address %></td></tr>
      <tr><td>Acct. Info</td> <td><%= acctinfo %></td></tr>
    </table>
    <h3>Press ENTER to Confirm Your Reservation</h3>
    <p><input type="submit" value="ENTER" 
	      WASH:callback="confirmedReservation seatCategory reservations commit name address acctinfo" />
    </p>
  </#>

-- | step 5: process confirmed reservation
confirmedReservation seatCategory reservations commit name address acctinfo =
  let nrOfSeats = sum (map fromEnum reservations) in
  commit () (goodBye nrOfSeats)

goodBye r =
  standardQuery (appTitle ++ ": Good Bye")
  <#>
  <h3>Thank you for reservation</h3>
  You reserved <%= r %> seats with us.
  </#>

