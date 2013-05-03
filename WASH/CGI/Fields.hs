-- © 2002 Peter Thiemann
module WASH.CGI.Fields where

import Data.Char
import Data.List (isPrefixOf, isSuffixOf, tails)
import WASH.Utility.ISO8601
import WASH.Utility.SimpleParser as SimpleParser
import WASH.CGI.CGITypes

-- |method 'reason' of this class maps a value of type /a/ to an explanation of
-- the input syntax for a value of type /a/
class Reason a where
  reason :: a -> String
  washtype :: a -> String
  reason _ = ""
  washtype x = reason x

instance Reason Int where
  reason _ = "Int"

instance Reason Integer where
  reason _ = "Integer"

instance Reason Double where
  reason _ = "Double"

instance Reason Float where
  reason _ = "Float"

instance Reason Bool where
  reason _ = "Bool"

instance Reason () where
  reason _ = "()"

instance Reason Char where
  reason _ = "Char"

instance Reason a => Reason [a] where
  reason ~(x:xs) = "[" ++ reason x ++ "]"

instance (Reason a, Reason b) => Reason (a, b) where
  reason ~(x,y) = "(" ++ reason x ++ "," ++ reason y ++ ")"

instance (Reason a, Reason b, Reason c) => Reason (a, b, c) where
  reason ~(x,y,z) = "(" ++ reason x ++ "," ++ reason y ++ "," ++ reason z ++ ")"

-- |Reads an email address according to RFC 2822
newtype EmailAddress = EmailAddress { unEmailAddress :: String }

instance Read EmailAddress where
  readsPrec i str = 
    let isAddressChar c = isAlpha c || isDigit c || c `elem` ".-_"
        (name, atDomain) = span isAddressChar (dropWhile isSpace str)
    in  case atDomain of
          '@' : domainPart ->
	    let (domain, rest) = span isAddressChar domainPart in
	    let fulladdress = name ++ '@' : domain in
	    if null name || null domain 
	    || "." `isPrefixOf` name || "." `isSuffixOf` name || "." `isPrefixOf` domain
	    || any (isPrefixOf "..") (tails name) 
	    || any (isPrefixOf "..") (tails domain)
	    then []
	    else [(EmailAddress fulladdress, dropWhile isSpace rest)]
	  _ -> []
  readList str = 
    case reads str of
      (em1, str'): _ ->
        case str' of
	  ',': str'' ->
	    case readList str'' of
	      (ems, str'''): _ ->
	        [(em1:ems, str''')]
	      _ ->
	        [([em1], str')]
	  _ -> 
	    [([em1], str')]
      _ -> []
	

instance Show EmailAddress where
  showsPrec i (EmailAddress str) = showString str

instance Reason EmailAddress where
  reason _ = "email address {must contain @ and no special characters except . - _}"
  washtype _ = "EmailAddress"
 
-- |Reads a credit card number and performs Luhn check on it.
newtype CreditCardNumber = CreditCardNumber { unCreditCardNumber :: String }

instance Read CreditCardNumber where
  readsPrec i str = 
    let str' = dropWhile isSpace str
	str'' =  take 16 str'
	str''' = dropWhile isSpace (drop 16 str'')
    in	if length str'' == 16 && all isDigit str && luhnCheck str
        then [(CreditCardNumber str, str''')]
	else []

luhnCheck str = 
  checkEven (reverse str) 0
  where digitval d = ord d - ord '0'
	checkEven [] n = n `mod` 10 == 0
	checkEven (d:ds) n = checkOdd ds (n + digitval d)
	checkOdd [] n = n `mod` 10 == 0
	checkOdd (d:ds) n = checkEven ds (n + doubleval (digitval d))
	doubleval d = let d2 = 2*d in if d2 > 9 then d2 - 9 else d2

instance Show CreditCardNumber where
  showsPrec i (CreditCardNumber str) = showString str

instance Reason CreditCardNumber where
  reason _ = "credit card number"
  washtype _ = "CreditCardNumber"

-- |Reads credit card expiration dates in format ##\/##.
data CreditCardExp = CreditCardExp { cceMonth :: Int, cceYear :: Int }

instance Read CreditCardExp where
  readsPrec i str = 
    g $ dropWhile isSpace str
    where
    g str@(mh: ml: '/': yh: yl:cces) =
      let mo, yr :: Int
	  mo = read [mh, ml]
	  yr = read [yh, yl]
      in if isDigit mh && isDigit ml && isDigit yh && isDigit yl && mo >= 1 && mo <= 12
      then [(CreditCardExp mo yr, cces)]
      else []
    g _ = []

instance Show CreditCardExp where
  showsPrec i cce = shows (cceMonth cce) . showChar '/' . shows (cceYear cce)

instance Reason CreditCardExp where
  reason _ = "credit card expiration date: MM/YY"
  washtype _ = "CreditCardExp"

-- |Non-empty strings.
newtype NonEmpty = NonEmpty { unNonEmpty :: String }

instance Read NonEmpty where
  readsPrec i [] = []
  readsPrec i str = [(NonEmpty str, "")]

instance Show NonEmpty where
  showsPrec i (NonEmpty str) = showString str

instance Reason NonEmpty where
  reason _ = "non empty string"
  washtype _ = "NonEmpty"

-- |Phone numbers.
newtype Phone = Phone { unPhone :: String }

phoneChars = "0123456789 +-/()"

instance Read Phone where
  readsPrec i =
    parserToRead $
    (many1 (oneOf phoneChars) >>= (return . Phone))

instance Show Phone where
  showsPrec i (Phone str) = showString str

instance Reason Phone where
  reason _ = "non empty string of " ++ show phoneChars
  washtype _ = "Phone"

-- |Non-empty strings of digits.
newtype AllDigits = AllDigits { unAllDigits :: String }

instance Read AllDigits where
  readsPrec i str =
    let (digits, str') = span isDigit $ dropWhile isSpace str in 
    if null digits then [] else [(AllDigits digits, str')]

instance Show AllDigits where
  showsPrec i (AllDigits str) = showString str

instance Reason AllDigits where
  reason _ = "non empty string of digits"
  washtype _ = "AllDigits"

-- |Arbitrary string data. No quotes required.
newtype Text = Text { unText :: String }

instance Read Text where
  readsPrec i str = [(Text str, "")]
  
instance Show Text where
  showsPrec i (Text str) = showString str

instance Reason Text where
  reason _ = "arbitrary string"
  washtype _ = "Text"

-- |Date and time in ISO8601 format
instance Reason ISODate where
  reason _ = "date in ISO8601 format"
  washtype _ = "ISODate"

instance Reason ISOTime where
  reason _ = "time in ISO8601 format"
  washtype _ = "ISOTime"

instance Reason ISODateAndTime where
  reason _ = "date and time in ISO8601 format"
  washtype _ = "ISODateAndTime"

-- |String in URL format
instance Read URL where
  readsPrec i = parserToRead parseURL

parseURL = 
  do scheme <- parseScheme
     colon <- char ':'
     rest <- many1 ascii
     return $ URL (scheme ++ colon : rest)

parseScheme =
  do c <- alpha
     cs <- many SimpleParser.print
     return (c:cs)

instance Show URL where
  showsPrec i (URL str) = showString str

instance Reason URL where
  reason _ = "URL"

-- |A Password is a string of length >= 8 with characters taken from at least
-- three of the four sets: lower case characters, upper case characters, digits,
-- and special characters.
newtype Password = Password { unPassword :: String }

instance Reason Password where
  reason _ = "Password string of length >= 8 with characters taken from at \
             \least three of the four sets: lower case characters, upper case \
	     \characters, digits, and special characters"

instance Read Password where
  readsPrec i str =
    let lower = any isLower str
	upper = any isUpper str
	digit = any isDigit str
	specl = any isSpecl str
	isSpecl c = isPrint c && not (isAlphaNum c)
	nclasses = sum (map fromEnum [lower, upper, digit, specl])
    in 
    if   length str >= 8 && nclasses >= 3
    then [(Password str, "")]
    else []

instance Show Password where
  showsPrec i (Password pw) = showString pw

-- |Data type for transforming a field into an optional one. The 'Read' syntax of
-- @Absent@ is the empty string, whereas the 'Read' syntax of @Present a@ is just the
-- 'Read' syntax of @a@. Analogously for 'Show'.
data Optional a = Absent | Present a

-- |Analogous to Maybe.fromJust
fromPresent :: Optional a -> a
fromPresent ~(Present x) = x
-- |Analogous to Maybe.fromMaybe
fromOptional :: a -> Optional a -> a
fromOptional x Absent      = x
fromOptional _ (Present x) = x

instance Show a => Show (Optional a) where
  showsPrec i Absent = id
  showsPrec i (Present x) = showsPrec i x

-- |Optional items are either empty or just the item
instance (Read a) => Read (Optional a) where
  readsPrec i "" = [(Absent, "")]
  readsPrec i xs = [(Present v, rest) | (v, rest) <- readsPrec i xs]

instance (Reason a) => Reason (Optional a) where
  reason x = "optional " ++ reason (fromPresent x)

