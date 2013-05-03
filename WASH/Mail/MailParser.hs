module WASH.Mail.MailParser where

-- see RFC 2822
-- TODO: check against their definition of token
import Data.Char
import Data.List
import Data.Maybe
-- 
import Text.ParserCombinators.Parsec
-- 
import qualified WASH.Utility.Base64 as Base64
import qualified WASH.Utility.QuotedPrintable as QuotedPrintable
import WASH.Utility.RFC2047  as RFC2047 (p_token)
import WASH.Mail.RFC2822
import WASH.Mail.Message
import WASH.Mail.HeaderField

parseMessageFromFile fname =
  parseFromFile message fname

parseMessageFromString str =
  parse message "MailParser" str

parseDateTimeFromString str =
  parse parseDateTime "DateTimeParser" (' ':str)

data RawMessage =
     RawMessage
     	{ rawHeaders	:: [Header]
	, rawLines	:: [String]
	}
  deriving Show

lexeme p = do x <- p; many ws1; return x
literalString = do char '\"'
		   str <- many (noneOf "\"\\" <|> quoted_pair)
		   char '\"'
		   return str

no_ws_ctl_chars = map chr ([1..8] ++ [11,12] ++ [14..31] ++ [127])
no_ws_ctl :: Parser Char
no_ws_ctl = oneOf no_ws_ctl_chars

text_chars = map chr ([1..9] ++ [11,12] ++ [14..127])
p_text = oneOf text_chars

quoted_pair = do char '\\'
		 p_text

-- RFC 2045, 5.1 says: 
-- "The type, subtype, and parameter names are not case sensitive."

p_parameter =
  do lexeme $ char ';'
     p_name <- lexeme $ p_token
     lexeme $ char '='
     p_value <- literalString <|> p_token
     return (map toLower p_name, p_value)

p_contentType = 
  do many ws1
     c_type <- p_token
     lexeme $ char '/'
     c_subtype <- lexeme $ p_token
     c_parameters <- many p_parameter
     return $ ContentType (map toLower c_type) (map toLower c_subtype) c_parameters

-- RFC 2045, 6.1
-- "these values are not case sensitive"

p_contentTransferEncoding =
  do many ws1
     c_cte <- RFC2047.p_token
     return $ ContentTransferEncoding (map toLower c_cte)

p_contentDisposition =
  do many ws1
     c_cd <- RFC2047.p_token
     c_parameters <- many p_parameter
     return $ ContentDisposition (map toLower c_cd) c_parameters

p_contentID = 
  do many ws1
     c_cid <- RFC2047.p_token
     return $ ContentID c_cid

p_contentDescription =
  do many ws1
     c_desc <- many lineChar
     return $ ContentDescription c_desc

header = do name <- many1 headerNameChar
	    char ':'
	    line <- do many ws1; lineString
	    crLf
	    extraLines <- many extraHeaderLine
	    return (Header (map toLower name, concat (line:extraLines)))

extraHeaderLine = do sp <- ws1
		     line <- lineString
		     crLf
		     return (sp:line)

lineString = many (noneOf "\n\r")

headerBodySep = do crLf; return ()

body = many (do line <- many lineChar; crLf; return line)

message =
  do hs <- many header
     headerBodySep
     b <- body
     return (RawMessage hs b)

lookupHeader name msg =
  lookupInHeaders name (getHeaders msg)
lookupRawHeader name raw =
  lookupInHeaders name (rawHeaders raw)
lookupInHeaders name headers = g headers
  where g [] = Nothing
	g (Header (name', text):_) | name == name' = Just text
	g (_:rest) = g rest

parseHeader raw name deflt parser =
  fromMaybe deflt $
  do str <- lookupRawHeader name raw
     case parse parser name str of
       Right v -> return v
       Left _  -> Nothing

digestMessage :: RawMessage -> Message
digestMessage =
  digestMessage' (ContentType "text" "plain" [( "charset", "us-ascii")])

digestMessage' :: ContentType -> RawMessage -> Message
digestMessage' defcty raw =
  let cty = parseHeader raw
      	"content-type" defcty p_contentType
      cte = parseHeader raw
      	"content-transfer-encoding" (ContentTransferEncoding "7bit") p_contentTransferEncoding
      cdn = parseHeader raw
      	"content-disposition" (ContentDisposition "inline" []) p_contentDisposition
      cid = parseHeader raw
      	"content-id" (ContentID "(none)") p_contentID
      cdc = parseHeader raw
      	"content-description" (ContentDescription "(none)") p_contentDescription
      defaultMessage =
        Singlepart
      	{ getHeaders = rawHeaders raw
	, getLines = rawLines raw
	, getDecoded = decode cte (unlines (rawLines raw))
	, getContentType= cty
	, getContentTransferEncoding= cte
	, getContentDisposition= cdn
	}
  in
  case cty of
    ContentType "multipart" c_subtype c_parameters ->
      case lookup "boundary" c_parameters of
        Just boundary ->
	  let defcte 
	        | c_subtype == "digest" = 
		  ContentType "message" "rfc822" []
		| otherwise = 
		  ContentType "text" "plain" [("charset", "us-ascii")] in
	  Multipart
	  	{ getHeaders = rawHeaders raw
		, getLines = rawLines raw
		, getParts = map (digestMessage' defcte)
				 (splitBody boundary (rawLines raw))
		, getContentType= cty
		, getContentTransferEncoding= cte
		, getContentDisposition= cdn
		}
	_ ->
	  defaultMessage
    _ ->
      defaultMessage

splitBody boundary lines =
  g False lines (showChar '\n') []
  where 
    finish shower showers =
      reverse (map (\shower -> parseSuccessfully message "body part" (shower ""))
                   (shower:showers))
    g afterPreamble [] shower showers =
      finish shower showers
    g afterPreamble (xs : rest) shower showers =
      if innerboundary `isPrefixOf` xs 
      then if finalboundary `isPrefixOf` xs 
           then if afterPreamble 
	        then finish shower showers
		else finish (showChar '\n') []
	   else if afterPreamble
	        then g afterPreamble rest id (shower : showers)
		else g True rest (showChar '\n') []
      else
      g afterPreamble rest (shower . showString xs . showString "\n") showers
    innerboundary = '-':'-':boundary
    finalboundary = innerboundary ++ "--"

decode (ContentTransferEncoding "quoted-printable") rawlines =
  QuotedPrintable.decode rawlines
decode (ContentTransferEncoding "base64") rawlines =
  Base64.decode rawlines
-- "7bit", "8bit", "binary", and everything else
decode (ContentTransferEncoding _) rawlines =
  rawlines


parseSuccessfully p n inp =
  case parse p n inp of
    Left pError ->
      error (show pError)
    Right x ->
      x

