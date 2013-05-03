-- © 2001-2006 Peter Thiemann
-- | Low-level types for raw CGI programming.

module WASH.CGI.RawCGITypes where

import IO

import WASH.CGI.CGITypes
import WASH.CGI.HTTP

type CGIProgram = (CGIInfo -> CGIParameters -> IO ())

type CGIParameter = (String, CGIValue)
type CGIParameters = [CGIParameter]

type CGIValue = String

-- | internal representation of a CGI parameter value
data CGIRawValue =
     CGIRawString String
   | CGIRawFile String String String		    -- ^ name, contentType, content

data CGIInfo = 
     CGIInfo    { cgiUrl :: URL
     		, cgiPathInfo :: String
		, cgiScriptName :: String
	       	, cgiContentType :: String
		, cgiContents :: String
		, cgiCookies :: [(String, String)]
		, cgiArgs :: [String]
		, cgiHandle :: Handle
		, cgiSessionMode :: SessionMode
		}

-- | corresponding to CGI environment variables
data CGIEnv =
     CGIEnv	{ serverName :: String
		, serverPort :: String
		, serverSoftware :: String
		, serverProtocol :: String
		, gatewayInterface :: String
		, scriptName :: String
		, requestMethod :: Method
		, contentLength :: String
		, contentType :: String
		, httpAccept :: String
		, httpCookie :: String
		, pathInfo :: String
		, pathTranslated :: String
		, remoteHost :: String
		, remoteAddr :: String
		, remoteUser :: String
		, authType :: String
		
		, rawContents :: String
		, rawArgs :: [String]
		
		, handle :: Handle
		, httpsEnabled :: Bool
		}

