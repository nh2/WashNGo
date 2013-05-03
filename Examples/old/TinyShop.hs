-- © 2002 Peter Thiemann
module Main where

import WASH.CGI.CGI hiding (map, div, span, head)
import DiskImages
import Monad

helloCGI = 
  standardQuery "Welcome to TinyShop" $
  table $
  do tr (td (attr "colspan" "2"
          ## text "If you are already a customer, \
                  \enter your email address and password"))
     emailF <- promptedInput "Email Address" (fieldSIZE 40) 
     passwF <- promptedPassword "Password" (fieldSIZE 40)
     tr (td (submit (F2 emailF passwF)
                    loginCGI
		    (fieldVALUE "LOGIN")))
     tr (td (submit0
                    newCustomerCGI
		    (fieldVALUE "REGISTER NEW")))
     
promptedInput txt attrs =
  tr (td (text txt) >> td (inputField attrs))

promptedPassword txt attrs =
  tr (td (text txt) >> td (passwordInputField attrs))

-- ---------------------------------------------------------
newCustomerCGI =
  standardQuery "TinyShop: New Customer" $
  table $
  do nameF <- promptedInput "Name " (fieldSIZE 40)
     strtF <- promptedInput "Street " (fieldSIZE 40)
     townF <- promptedInput "Town " (fieldSIZE 40)
     stateF<- promptedInput "State " (fieldSIZE 20)
     zipcF <- promptedInput "Zip " (fieldSIZE 10)
     countF<- promptedInput "Country " (fieldSIZE 20)
     birthF<- promptedInput "Date of Birth " (fieldSIZE 10)
     emailF<- promptedInput "Email address " (fieldSIZE 40)
     passF <- promptedPassword "Password " (fieldSIZE 40)
     tr $ td $ 
        submit (F5 nameF (F5 strtF townF stateF zipcF countF) birthF emailF passF)
     	registerCGI empty

-- -------------------------------------------------------
registerCGI (F5 nameF (F5 strtF townF stateF zipcF countF) birthF emailF passF) =
  let name = unNonEmpty (value nameF)
      street =  unNonEmpty (value strtF)
      town = unNonEmpty (value townF)
      state = unText (value stateF)
      zipc  = unNonEmpty (value zipcF)
      country = unNonEmpty (value countF)
      birthdate = unNonEmpty (value birthF)
      email = unEmailAddress (value emailF)
      pass = unNonEmpty (value passF)
  in
  -- verify and store information
  salesCGI email

-- -------------------------------------------------------
loginCGI (F2 emailF passF) =
  let email = unEmailAddress $ value emailF
      passw = unNonEmpty $ value passF
  in
  -- verify login information
  salesCGI email
  
-- -------------------------------------------------------
salesCGI email =
  standardQuery "Current Sales Items" $ do
  p (do text "Hi, "
	text email
	text " here are today's specials for you!")
  salesItems <- table $ do
    attr "frame" "border"
    attr "border" "2"
    thead $ tr (th (text "amount")
             ## th (text "image")
	     ## th (text "unit price"))
    mapM listItem inventory >>= (return . FL)
  p (text "Enter your selection and press FINISH to proceed to the cashier")
  submit salesItems billingCGI (fieldVALUE "FINISH")
    
listItem diskDesc =
  let ffImage = diskImage diskDesc in
  tr $ do 
    im <- internalImage ffImage (ffName ffImage)
    amountF <- td (inputField (fieldSIZE 5 ## fieldVALUE 0)) 
    td (makeImg im empty)
    td (text $ showCurrency (diskPrice diskDesc))
    return amountF
    
-- -------------------------------------------------------
billingCGI salesItemsF =
  let FL salesItemsH = salesItemsF
      salesItems = map value $ salesItemsH
  in
  standardQuery "Your bill" $ do
    p (text "modified items are listed in red")
    hdl <- table $ do
      attr "frame" "border"
      attr "border" "2"
      thead $ tr (th (text "amount") 
               ## th (text "image")
	       ## th (text "unit price")
	       ## th (text "total price"))
      prices <- mapM billItem (zip salesItems inventory)
      let totalPrice = sum prices
      tr (td empty
       ## td (text "total price") 
       ## td empty
       ## td (text $ showCurrency totalPrice))
      tr empty
      rg <- radioGroup
      tr (td (radioButton rg PayCredit empty)
       ## td (text "Pay by Credit Card"))
      ccnrF <- tr ((td empty >> td (inputField (fieldSIZE 16))) ## td (text "Card No"))
      ccexF <- tr ((td empty >> td (inputField (fieldSIZE  5))) ## td (text "Expires"))
      tr (td (radioButton rg PayTransfer empty)
       ## td (text "Pay by Bank Transfer"))
      acctF <- tr ((td empty >> td (inputField (fieldSIZE 10))) ## td (text "Acct No"))
      routF <- tr ((td empty >> td (inputField (fieldSIZE  8))) ## td (text "Routing"))
      let next paymodeF =
	    case value paymodeF of
	      PayCredit   -> dtnode (F2 ccnrF ccexF) (dtleaf . payCredit totalPrice)
	      PayTransfer -> dtnode (F2 acctF routF) (dtleaf . payTransfer totalPrice)
      return $ dtnode rg next
    submitx hdl empty
    
billItem (amount, diskDesc) =
  let actualAmount = max 0 (min amount (diskInStock diskDesc))
      actualPrice  = fromIntegral actualAmount * diskPrice diskDesc
      amountStyle | actualAmount == amount = ("color" :=: "blue")
                  | otherwise = ("color" :=: "red")
  in tr $ do
     using amountStyle td (text $ show actualAmount)
     im <- internalImage (diskImage diskDesc) (ffName (diskImage diskDesc))
     td (makeImg im empty)
     td (text $ showCurrency (diskPrice diskDesc))
     when (actualAmount > 0) $
       td (text $ showCurrency actualPrice)
     return actualPrice

-- -------------------------------------------------------
payCredit amount (F2 ccnrF ccexF) =
  let ccnr = unCreditCardNumber (value ccnrF)
      expMonth = cceMonth (value ccexF)
  in
  standardQuery "Confirm Credit Payment" $
  do p $ do text "Received credit card payment of "
	    text $ showCurrency amount
     p $ text "Thanks for shopping at TinyShop.Com!"

payTransfer amount (F2 acctF routF) = 
  let acct = unAllDigits (value acctF)
      rout = unAllDigits (value routF)
  in
  standardQuery "Confirm Transfer Payment" $ 
  do p $ do text "Received transfer payment of "
	    text $ showCurrency amount
     p $ text "Thanks for shopping at TinyShop.Com!"

-- -------------------------------------------------------
main = runWithHook [] (docTranslator (map diskImage inventory) lastTranslator) helloCGI

data ModeOfPayment = PayCredit | PayTransfer
  deriving (Read, Show)


showCurrency n =
  show (n `div` 100) ++ '.' : reverse (take 2 (reverse (show (n+100))))
