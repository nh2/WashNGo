module WASH.CGI.Debug where

import System.Directory
import Control.Monad
import System.IO
import System.Time

import System.IO.Unsafe

import WASH.Utility.Auxiliary
import WASH.CGI.RawCGITypes
import WASH.CGI.HTTP
import qualified WASH.Utility.Shell as Shell
import qualified WASH.Utility.ISO8601 as ISO8601
import qualified WASH.Utility.IntToString as IntToString

-- |Turn this off for production use.
debugging :: Bool
debugging = False

logDirNakalele = "/export/data/thiemann"

dir :: String
dir = 
  unsafePerformIO $
    do (ts, tps) <- timestamp
       onNakalele <- doesDirectoryExist logDirNakalele
       ra <- protectedGetEnv "REMOTE_ADDR" "0.0.0.0"
       home <- protectedGetEnv "HOME" ""
       let root | not (null home) = home ++ "/tmp"
		| onNakalele      = logDirNakalele
		| otherwise       = "/tmp"
	   n = root ++ "/WASHLOGA/" ++ ra ++ 
               '/' : IntToString.intToString 10 (toEnum ts) ++
	       ':' : IntToString.intToString 10 tps
       assertDirectoryExists n (return ())
       return n

timestamp :: IO (Int, Integer)
timestamp =
  do clkt <- getClockTime
     let dc = diffClockTimes clkt ISO8601.epochClkT
     return (tdSec dc, tdPicosec dc)

withLogFile :: String -> (Handle -> IO ()) -> IO ()
withLogFile path go =
  do h <- openFile path AppendMode
     go h
     hClose h

-- ------------------------------------------------------------

hPutEnvVar h val var =
  do hPutStr h var
     hPutChar h '='
     hPutStrLn h (Shell.quote val)
     hPutStr h "export "
     hPutStrLn h var

makeArgList h [] =
  return ()
makeArgList h (x:xs) =
  do hPutStr h (Shell.quote x)
     hPutChar h ' '
     makeArgList h xs
makeCommand h args =
  do hPutStr h "$1 "
     makeArgList h args
     hPutStrLn h "<< \\EOF"
makeInput h str =
  do hPutStrLn h str
     hPutStrLn h "\\EOF"

-- |Creates a shell script suitable for replaying the interactive submission.
logInput :: CGIEnv -> IO ()
logInput cgiEnv =
  when debugging $
  withLogFile (dir ++ "/IN.sh") $ \ h ->
  do hPutStrLn h "#!/bin/sh"
     hPutEnvVar h (serverName cgiEnv) "SERVER_NAME"
     hPutEnvVar h (serverPort cgiEnv) "SERVER_PORT"
     hPutEnvVar h (serverSoftware cgiEnv) "SERVER_SOFTWARE"
     hPutEnvVar h (serverProtocol cgiEnv) "SERVER_PROTOCOL"
     hPutEnvVar h (gatewayInterface cgiEnv) "GATEWAY_INTERFACE"
     hPutEnvVar h (scriptName cgiEnv) "SCRIPT_NAME"
     hPutEnvVar h (show $ requestMethod cgiEnv) "REQUEST_METHOD"
     hPutEnvVar h (contentLength cgiEnv) "CONTENT_LENGTH"
     hPutEnvVar h (contentType cgiEnv) "CONTENT_TYPE"
     hPutEnvVar h (httpCookie cgiEnv) "HTTP_COOKIE"
     hPutEnvVar h (httpAccept cgiEnv) "HTTP_ACCEPT"
     hPutEnvVar h (pathInfo cgiEnv) "PATH_INFO"
     hPutEnvVar h (pathTranslated cgiEnv) "PATH_TRANSLATED"
     hPutEnvVar h (remoteHost cgiEnv) "REMOTE_HOST"
     hPutEnvVar h (remoteAddr cgiEnv) "REMOTE_ADDR"
     hPutEnvVar h (remoteUser cgiEnv) "REMOTE_USER"
     hPutEnvVar h (authType cgiEnv) "AUTH_TYPE"
     if httpsEnabled cgiEnv 
	then hPutEnvVar h "on"  "HTTPS"
	else hPutEnvVar h "off" "HTTPS"
     makeCommand h (rawArgs cgiEnv)
     makeInput h (rawContents cgiEnv)
     
logOutput :: String -> (Handle -> IO ()) -> IO ()
logOutput name f =
  let basename = dir ++ '/' : name in
  when debugging $ do
    before <- getClockTime
    withLogFile basename f
    after <- getClockTime
    let dc = diffClockTimes after before
	dSec = toInteger $ tdSec dc
	dPic = tdPicosec dc
    withLogFile (basename ++ ".time")
      (\h -> do hPutStrLn h (IntToString.intToString 10 dSec)
                hPutStrLn h (IntToString.intToString 10 dPic))
