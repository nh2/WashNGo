module WASH.CGI.CookieIO (decodeCookie, encodeCookie, putCookies) where

import System.IO

import WASH.CGI.CGIMonad
import qualified WASH.CGI.Debug as Debug
import WASH.CGI.RawCGITypes
import qualified WASH.Utility.URLCoding as URLCoding

decodeCookie :: (String, String) -> (String, (Maybe String, Maybe String))
encodeCookie :: (String, (Maybe String, Maybe String)) -> (String, String)
encodeCookie (k, (v, mexp)) =
  (URLCoding.encode k, 
   case v of 
     Just v' -> URLCoding.encode v' ++
       (case mexp of
	  Nothing -> ""
	  Just exp -> "; expires=" ++ exp)
     Nothing -> "deleted; expires=Thu, 01-Jan-1970 00:00:00 GMT")
decodeCookie (k, v) =  (URLCoding.decode k, (Just (URLCoding.decode v), Nothing))

putCookies :: CGIState -> IO ()
putCookies cgistate =
  let cookies = cookiesToSend cgistate
      cm = cookieMap cgistate
      h = cgiHandle (cgiInfo cgistate)
      sendCookie name = case lookup name cm of
        Nothing -> 
	  return ()
	Just value -> 
	  let (encName, encValue) = encodeCookie (name, value) in
	  do hPutStr h "Set-Cookie: "
	     hPutStr h encName
	     hPutStr h "="
	     hPutStr h encValue
	     hPutStr h ";\n"
  in do printCookies cm cookies h
	Debug.logOutput "OLD" (printCookies cm cookies)

printCookies :: [(String,(Maybe String, Maybe String))] -> [String] -> Handle -> IO ()
printCookies cm cookies h =
  let sendCookie name = case lookup name cm of
        Nothing -> 
	  return ()
	Just value -> 
	  let (encName, encValue) = encodeCookie (name, value) in
	  do hPutStr h "Set-Cookie: "
	     hPutStr h encName
	     hPutStr h "="
	     hPutStr h encValue
	     hPutStr h ";\n"
  in mapM_ sendCookie cookies
