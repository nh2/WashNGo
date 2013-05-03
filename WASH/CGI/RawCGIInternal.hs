-- © 2001, 2002 Peter Thiemann
-- |Low-level interface to CGI scripting.
module WASH.CGI.RawCGIInternal 
  (module WASH.CGI.RawCGITypes, module WASH.CGI.RawCGIInternal) 
  where
-- (CGIParameter, CGIParameters, start, assocParm, assoc)

import Array
import Char
import IO
import List
import Maybe
import Random
import System
import WASH.Utility.Auxiliary
import WASH.Utility.Unique
import qualified WASH.Utility.URLCoding as URLCoding
import qualified WASH.Utility.RFC2279 as RFC2279

import WASH.CGI.CGIConfig
import WASH.CGI.CGITypes
import WASH.CGI.HTTP
import WASH.CGI.RawCGITypes
import WASH.Utility.BulkIO (rawGetBytes)

import WASH.Utility.Hex

import qualified WASH.CGI.Debug as Debug

getGenericOption isOption defaultOption options =
  fromJust (find isOption (reverse (defaultOption:options)))

-- | Decoding of 'CGIOption'.
isPortOption NoPort = True
isPortOption AutoPort = True
isPortOption (Port _) = True
isPortOption _ = False

getPortOption =
  getGenericOption isPortOption AutoPort

-- | Decoding of 'CGIOption'.
isHttpsOption NoHttps = True
isHttpsOption AutoHttps = True
isHttpsOption _ = False

getHttpsOption =
  getGenericOption isHttpsOption AutoHttps

-- | Decoding of 'CGIOption'.
isURLOption FullURL = True
isURLOption PartialURL = True
isURLOption _ = False

getURLOption =
  getGenericOption isURLOption PartialURL

-- | Decoding of 'CGIOption'.
isSessionOption (SessionMode _) = True
isSessionOption _ = False

getSessionMode =
  unSessionMode . getGenericOption isSessionOption (SessionMode LogOnly)

fieldName = fst
fieldContents = snd

-- |Initial and default content type of a link submission
contentTypeUrlencoded = "application/x-www-form-urlencoded"

-- |Construct a CGI environment from the input and output handle of the current
-- connection and the CGI variables in the environment.
initEnv :: Handle -> Handle -> IO CGIEnv
initEnv hIn hOut =
  do server_name <- protectedGetEnv "SERVER_NAME" "localhost"
     server_port <- protectedGetEnv "SERVER_PORT" "80"
     server_software <- protectedGetEnv "SERVER_SOFTWARE" ""
     server_protocol <- protectedGetEnv "SERVER_PROTOCOL" ""
     gateway_interface <- protectedGetEnv "GATEWAY_INTERFACE" ""
     script_name <- protectedGetEnv "SCRIPT_NAME" ""
     request_method <- protectedGetEnv "REQUEST_METHOD" "GET"
     content_length <- protectedGetEnv "CONTENT_LENGTH" "0"
     content_type <- protectedGetEnv "CONTENT_TYPE" contentTypeUrlencoded
     http_cookie <- protectedGetEnv "HTTP_COOKIE" ""
     http_accept <- protectedGetEnv "HTTP_ACCEPT" ""
     path_info <- protectedGetEnv "PATH_INFO" ""
     path_translated <- protectedGetEnv "PATH_TRANSLATED" ""
     remote_host <- protectedGetEnv "REMOTE_HOST" ""
     remote_addr <- protectedGetEnv "REMOTE_ADDR" ""
     remote_user <- protectedGetEnv "REMOTE_USER" ""
     auth_type <- protectedGetEnv "AUTH_TYPE" ""
     https <- protectedGetEnv "HTTPS" "off"
     raw_args <- getArgs
     let byteCount :: Int
	 byteCount = read ('0':content_length)
	 httpMethod :: Method
	 httpMethod = read request_method
     raw_contents <- case httpMethod of
		       GET -> return ""
		       _   -> rawGetBytes hIn byteCount
     return
       CGIEnv	{ serverName = server_name
		, serverPort = server_port
		, serverSoftware= server_software
		, serverProtocol = server_protocol
		, scriptName = script_name
		, gatewayInterface = gateway_interface
		, requestMethod = httpMethod
		, contentLength = content_length
		, contentType = content_type
		, httpCookie = http_cookie
		, httpAccept = http_accept
		, pathInfo = path_info
		, pathTranslated = path_translated
		, remoteHost = remote_host
		, remoteAddr = remote_addr
		, remoteUser = remote_user
		, authType = auth_type
		, rawContents = raw_contents
		, rawArgs = raw_args
		, handle = hOut
		, httpsEnabled = (https == "on" || server_port == "443")
		}

-- |Main entry point for low-level CGI scripts. Takes a list of 'CGIOption' and
-- a 'CGIProgram' and runs it as a CGI script.
start :: CGIOptions -> (CGIInfo -> CGIParameters -> IO ()) -> IO ()
start options f = 
  do env <- initEnv stdin stdout
     Debug.logInput env
     -- use from a CGI program forces standard replay implementation
     startEnv env (SessionMode LogOnly : options) f 

startEnv :: CGIEnv -> CGIOptions -> (CGIInfo -> CGIParameters -> IO ()) -> IO ()
startEnv env options f =
  do let portString = 
	   case getPortOption options of
	     AutoPort -> ':' : serverPort env
	     NoPort   -> ""
	     Port num -> ':' : show num
	 schemeString =
	   case getHttpsOption options of
	     AutoHttps -> if httpsEnabled env then "https" else "http"
	     NoHttps -> "http"
	 myurl = 
	   case getURLOption options of
	     FullURL ->
	       schemeString ++ "://" ++ serverName env ++ portString ++
	 	 scriptName env ++ pathInfo env
	     PartialURL ->
	       scriptName env ++ pathInfo env
	 sessionMode =
	   getSessionMode options
	 methodIsGet 
	   = requestMethod env == GET
	 contentIsURLEncoded
	   = contentTypeUrlencoded == map toLower (contentType env)
	 contents = rawContents env
	 rawDecodedParameters 
	   | methodIsGet = []
	   | contentIsURLEncoded = map decodeLine $ parameterLines contents
	   | otherwise = decodeMultiPart (contentType env) contents
	 parsed_cookies = parseCookies $ httpCookie env
	 info = CGIInfo { cgiUrl = URL myurl
	 		, cgiPathInfo = pathInfo env
			, cgiScriptName = scriptName env
	 		, cgiContentType = contentType env
			, cgiContents = contents
			, cgiCookies = parsed_cookies
			, cgiArgs = rawArgs env
			, cgiHandle = handle env
			, cgiSessionMode = sessionMode
			}
     decodedParameters <- resolveFiles rawDecodedParameters
     -- appendDebugFile "/tmp/CGIDECODED" (show decodedParameters)
     f info decodedParameters

resolveFiles :: [(String, CGIRawValue)] -> IO CGIParameters
resolveFiles =
  let resolveOne (key, rv) =
        case rv of
          CGIRawString s -> 
	    return (key, s)
	  CGIRawFile fileName contentType fileContents ->
	    do localName <- inventFilePath
	       writeFile localName fileContents
	       let fileRef = FileReference
		           { fileReferenceName = localName
			   , fileReferenceContentType = contentType
			   , fileReferenceExternalName = fileName
			   }
	       return (key, show fileRef)
  in mapM resolveOne

parseCookies :: String -> [(String, String)]
parseCookies str = 
  let s0 = dropWhile isSpace str in
  if null s0 then [] else
  let (item, rest) = span (/= ';') s0 in
  case span (/= '=') item of
    (key, '=':value) ->
      (key, value) : parseCookies (dropWhile (== ';') rest)
    _ -> 
      error ("Trying to parse cookie: " ++ str)

dropSpecialParameters :: [(String,a)] -> [(String,a)]
dropSpecialParameters = filter (f . fieldName)
	where f ('=':_) = False
	      f _ = True

decodeMultiPart :: String -> String -> [(String, CGIRawValue)]
decodeMultiPart contentType contents
  = let Just boundary = extractBoundary contentType 
	startBoundary = '-':'-':boundary
	g source = case 
	  (
	  advanceIC startBoundary source >>= \afterBoundary ->
	  case afterBoundary of 
	   '-':_ -> Nothing
	   '\13':'\10':body ->
		advanceIC "content-disposition: form-data; name=\"" body
		>>= \fieldNameRest ->
		let (fieldName, rest) = span (/= '\"') fieldNameRest in
		advanceIC "\"" rest
		>>= \mayBeFileNameRest ->
		(case mayBeFileNameRest of
		  ';':_ -> advanceIC "; filename=\"" mayBeFileNameRest
		           >>= \fileNameRest ->
		           let (fileName, rest) = span (/= '\"') fileNameRest in
		           advanceIC "\"" rest
		           >>= \mayBeContentTypeRest ->
		           return (Just fileName, mayBeContentTypeRest)
		  _ -> return (Nothing, mayBeFileNameRest))
		>>= \ (mFileName, fileNameRest) ->
		let (contentType, rest) =
		      case advanceIC "\ncontent-type: " fileNameRest of
		        Just contentTypeRest -> span (/= '\13') contentTypeRest
		        Nothing -> ("text/plain", fileNameRest) in
		advanceIC "\n\n" rest
		>>= \contentRest ->
		extractContents startBoundary contentRest
		>>= \ (fieldContents, rest) ->
		-- fieldName must be rfc1522decoded (?)
		let moreParms = g rest 
		    rawvalue = case mFileName of
				 Nothing ->
				   CGIRawString $ RFC2279.decode fieldContents
				 Just fileName ->
				   CGIRawFile fileName contentType fieldContents
		in  return ((RFC2279.decode fieldName, rawvalue) : moreParms)
	   )
	  of
	    Just parameters -> parameters
	    Nothing -> []
    in g contents

extractContents :: String -> String -> Maybe (String, String)
extractContents boundary source
  = g "" source
  where g rev "" = Nothing
	g rev ('\r':'\n':xs) = case advanceIC boundary xs of
				Just _  -> Just (reverse rev, xs)
				Nothing -> g ('\n':'\r':rev) xs
	g rev (x:xs) = g (x:rev) xs


extractBoundary :: String -> Maybe String
extractBoundary contentType = advanceIC "multipart/form-data; boundary=" contentType 

advanceIC :: String -> String -> Maybe String
advanceIC [] ys = Just ys
advanceIC xs [] = Nothing
advanceIC (' ':xs) (y:ys)
	| isSpace y = advanceIC xs (dropWhile isSpace ys)
advanceIC ('\n':xs) ('\13':'\10':ys)
	= advanceIC xs ys
advanceIC (x:xs) (y:ys) 
	| toUpper x == toUpper y = advanceIC xs ys
	| otherwise = Nothing

parameterLines :: String -> [String]
parameterLines "" = []
parameterLines xs = let (firstPar, restPar) = span (/= '&') xs in
		    case restPar of
		      '&' : moreParameters -> firstPar : parameterLines moreParameters
		      _ -> [firstPar]

decodeLine :: String -> (String, CGIRawValue)
decodeLine str = 
  let (name, '=':value) = span (/= '=') str in
  ( RFC2279.decode $ URLCoding.decode name
  , CGIRawString $ RFC2279.decode $ URLCoding.decode value)

assocParm :: String -> CGIParameters -> Maybe CGIValue
assocParm key =
  listToMaybe . assocParmL key

assocParmL :: String -> CGIParameters -> [CGIValue]
assocParmL key =
  map fieldContents . assocParmR key

assocParmR :: String -> CGIParameters -> CGIParameters
assocParmR key =
  filter (\parm -> fieldName parm == key) 

assoc :: (Eq a) => a -> [(a,b)] -> Maybe b
assoc key alist =
  ass alist 
  where ass ((a,b):rest) = if a == key then Just b else ass rest
	ass [] = Nothing -- error ("assoc ("++show key++") "++show alist)

-- update :: [(a,b)] -> a -> b -> [(a,b)]
-- update alist a b = (a,b) : alist

fieldNames :: CGIParameters -> [String]
fieldNames = map fieldName

-- encryption

generateKey :: IO (Maybe (Integer, String, String))
generateKey =
  try (openFile keyFile ReadMode) >>= g
  where
    g (Left ioerror) =
      return Nothing
    g (Right h) =
      do size <- hFileSize h
	 let size2 = size `div` 2
	 pos <- randomRIO (0, size2)
	 if pos < 0
	    then return Nothing 
	    else do hSeek h AbsoluteSeek pos
		    xs <- hGetContents h
		    g <- getStdGen
		    return (Just (pos
		    		 ,randomRs (minBound, maxBound) g
				 ,extendRandomly xs))

extendRandomly :: [Char] -> [Char]
extendRandomly xs = h 0 xs
  where h n (x:xs) = x : h (n + ord x) xs
	h n []     = randoms (mkStdGen n)

nrNonces :: Int
nrNonces = 16

makeEncoder :: Maybe (Integer, String, String) -> String -> String
makeEncoder Nothing xs = xs
makeEncoder (Just (i, nonces, keys)) xs = 
  show i ++ ';' : encrypt1 (take nrNonces nonces ++ xs) keys

decode :: String -> IO String
decode inp = g (reads inp)
  where
    g :: [(Integer, String)] -> IO String
    g ((pos, ';':encrypted) : _) = 
      do h <- openFile keyFile ReadMode
	 hSeek h AbsoluteSeek pos
	 xs <- hGetContents h
	 return (drop nrNonces $ decrypt1 encrypted (extendRandomly xs))
    g _ = return inp

encrypt1 inp keys = map chr (enc 0 (map ord inp) (map ord keys))
  where enc acc [] okeys = []
	enc acc (oinp : oinps) (okey : okeys) =
	  let out = (oinp + okey + acc) `mod` 256 in
	  out : enc ((acc + oinp) `mod` 256) oinps okeys

decrypt1 einp keys = map chr (dec 0 (map ord einp) (map ord keys))
  where dec acc [] okeys = []
	dec acc (oeinp : oeinps) (okey : okeys) =
	  let oinp = (512 + oeinp - okey - acc) `mod` 256 in
	  oinp : dec ((acc + oinp) `mod` 256) oeinps okeys

encrypt, decrypt :: String -> String -> String
encrypt = zipWith cadd
cadd c1 c2 = chr (ord c1 + ord c2 `mod` 256)
decrypt = zipWith csub
csub c1 c2 = chr ((ord c1 + 256 - ord c2) `mod` 256)
{-- 
import Bits						    -- ghc specific
encrypt = zipWith cxor
decrypt = zipWith cxor
cxor c1 c2 = chr (ord c1 `xor` ord c2)
--}
