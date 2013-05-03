module Main where

import List
import WASH.CGI.CGI
import WASH.CGI.CGITypes
import Prelude hiding (div)

main :: IO ()
main =
  run mainCGI

toppings =
    [(0, 0.45, "Onions", "/sliced_onions.gif")
    ,(1, 1.25, "Pepper", "/pepper_small.gif")
    ,(2, 0.25, "Extra Cheese", "/pizza_cheese.gif")
    ,(3, 1.00, "Mushrooms", "/sliced_mushrooms.gif")
    ,(4, 0.75, "Ham", "/baked-ham.gif")
    ]

nrToppings = 
  length toppings

mainCGI =
  selectionPage [] [0..nrToppings - 1]

selectionPage selected available =
  standardQuery "Giovannis CyberPizza" $ do
    displayPizza selected
    hr $ empty
    displaySelection selected available
    hr $ empty
    amount <- displayBill selected available
    hr $ empty
    displayPayment amount

displayPizza selected =
  do p $ text "Dear friend! I'm Giovanni! That's your yummy pizza:" 
     img $ do
       attr "src" "/pizza.gif"
       attr "style" "position:absolute; top:0px; right:0px"
     mapM_ (displayTopping 0) selected
     mapM_ (displayTopping 1) selected
     mapM_ (displayTopping 2) selected
  where
    displayTopping off sel =
      let (nr, price, name, imgLoc) = toppings !! sel
	  circ = 2 * pi
	  arc = circ / (fromIntegral (nrToppings * 3))
	  arc' = arc * fromIntegral (sel + off * nrToppings)
	  x = show $ 160 - 100 * sin arc'
	  y = show $ 170 + 100 * cos arc'
	  style = "position:absolute; top:" ++ y ++ "px; right:" ++ x ++ "px"
      in img $ do
	attr "src" imgLoc
	attr "style" style

displaySelection selected available =
  do p $ text "Giovanni! Slap some more on my pizza!"
     table $ tbody $
       mapM_ 
	 ( \ sel ->
	   let (nr, price, name, imgLoc) = toppings !! sel
	   in tr $ do 
	     td $ myButton F0 (addTopping sel selected available) "Please Add"
	     imgH <- externalImage (URL imgLoc) name
	     td $ makeImg imgH empty
	     td $ text $ " for only " ++ show price ++ " bucks!")
	 available

displayBill selected available =
  do p $ text "And here is your bill ..." 
     prices <- table $ tbody $ do
       tr $ do 
	 td $ text "Your Pizza"
	 td $ text "$ 5.00"
       mapM 
	 ( \ sel ->
	   let (nr, price, name, imgLoc) = toppings !! sel
	   in tr $ do
	     td $ text $ "with " ++ name
	     td $ text $ "$ " ++ show price
	     td $ myButton F0 (deleteTopping sel selected available) "Ooops!"
	     return price)
	 selected
     let amount = sum prices + 5.00
     p $ text $ 
       "Altogether, this is only " ++ (show amount) ++ " bucks! Incredible!"
     return amount

displayPayment amount =
  table $ tbody $ tr $ do
    td $ text "My Credit Card is a " 
    mpyF <- td $ selectSingle displayCard Nothing [0..2] empty
    td $ text "Card No"
    ccnrF <- td (inputField (fieldSIZE 16))
    td (text "Expires")
    ccexF <- td (inputField (fieldSIZE  5))
    td $ myButton (F3 mpyF ccnrF ccexF) (endAction amount) "Pay'n'Munch"

addTopping sel selected available F0 =
  selectionPage (sort $ sel : selected) (available \\ [sel])

deleteTopping sel selected available F0 =
  selectionPage (selected \\ [sel]) (sort $ sel : available)

endAction amount (F3 mpyF ccnrF ccexF) =
  let ccnr = unCreditCardNumber (value ccnrF)
      expMonth = cceMonth (value ccexF)
  in
  standardQuery "Confirm Credit Payment" $
  do p $ text $ "Received credit card payment of $" ++ show amount 
     p $ text "Thanks for ordering at Giovanni's!"

myButton handles continuation text =
  submit 
    handles 
    continuation 
    ((fieldVALUE text) ## attr "style" "background: white")

displayCard 0 = "MasterCard"
displayCard 1 = "Visa"
displayCard 2 = "American Express"
