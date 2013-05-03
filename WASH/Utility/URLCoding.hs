-- © 2001, 2002, 2006 Peter Thiemann
-- |Implements coding of non-alphanumeric characters in URLs and CGI-requests.
module WASH.Utility.URLCoding (encode, decode) where

import Char
import WASH.Utility.Hex

-- |Perform URI encoding of a list of bytes. See 
-- <http://www.w3.org/International/O-URL-code.html>
-- To encode a list of characters, the string first has to be UTF-8 encoded!
encode :: String -> String
encode = urlEncode

-- |Perform URI decoding to a list of bytes.
decode :: String -> String
decode = urlDecode

-- implementations

urlEncode :: String -> String
urlEncode xs =
  urlEncode' xs ""
urlEncode' "" = id
urlEncode' (x:xs) = 
  (if isAlphaNum x 
  then showChar x
  else showChar '%' .
       showsHex 2 (ord x)) . urlEncode' xs

urlDecode :: String -> String
urlDecode "" = ""
urlDecode ('+':xs) =
	' ' : urlDecode xs
urlDecode ('%':upper:lower:xs) =
	chr (16 * hexDigitVal upper + hexDigitVal lower) : urlDecode xs
urlDecode (x:xs) = 
	x : urlDecode xs

