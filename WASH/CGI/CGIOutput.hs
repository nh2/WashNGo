-- © 2001, 2002 Peter Thiemann
-- |Defines the class 'CGIOutput' of data types that can be output from a CGI
-- program. 
module WASH.CGI.CGIOutput where

import IO
import Maybe
import Monad
import System

import WASH.Utility.Auxiliary
import WASH.Utility.BulkIO (rawHandleCopy)
import qualified WASH.CGI.Debug as Debug
import qualified WASH.Utility.RFC2279 as RFC2279

import qualified WASH.Utility.Shell as Shell

import WASH.CGI.CGIConfig
import WASH.CGI.CGITypes
import WASH.CGI.HTMLWrapper hiding (head, div, span, map)
import WASH.HTML.HTMLTemplates

-- import qualified PostElementAction

-- |(internal) takes an output handle and a document without forms and input
-- widgets, displays the document with suitable mime type and encoding, and
-- terminates the program
itell :: Handle -> WithHTML x IO () -> IO a
itell h hma = do elem <- build_document hma
		 cgiPut h elem
		 exitWith ExitSuccess

-- 
class CGIOutput a where
  cgiPut' :: Handle -> a -> IO ()
  cgiPutList :: Handle -> [a] -> IO ()
  
  cgiPutList h xs = cgiPutList h xs

cgiPut :: CGIOutput a => Handle -> a -> IO ()
cgiPut h x =
  do cgiPut' h x

instance CGIOutput a => CGIOutput [a] where
  cgiPut' h xs = cgiPutList h xs

-- instance CGIOutput Element where
instance CGIOutput ELEMENT_ where
  cgiPut' h x = hPutElement h x

instance CGIOutput Char where
  cgiPut' h ch = cgiPutList h [ch]
  cgiPutList h x = hPutListChar h x

instance CGIOutput FileReference where
  cgiPut' h x = hPutFileReference h x

instance CGIOutput ResponseFileReference where
  cgiPut' h x = hPutResponseFileReference h x

instance CGIOutput Status where
  cgiPut' h x = hPutStatus h x
	  
instance CGIOutput Location where
  cgiPut' h x = hPutLocation h x

instance CGIOutput FreeForm where
  cgiPut' h x = hPutFreeForm h x

-- ------------------------------------------------------------

hPutElement h elem =
    do hPutStrLn h "Content-Type: text/html; charset=utf-8"
       -- hPutStrLn h "Content-Type: application/xhtml+xml; charset=utf-8"
       -- This MIME type does not work with Mozilla 1.6. It says
       -- "This XML file does not appear to have any style information associated
       -- with it. The document tree is shown below."
       hPutStrLn h ""
       hPutStr h $ RFC2279.encode $ show elem
       -- PostElementAction.postElementAction h
       let new h = hPutStrLn h (showTemplatified elem "")
	   old h = hPutStrLn h $ RFC2279.encode $ show elem
       Debug.logOutput "OLD" old
       -- Debug.logOutput "NEW" new

hPutListChar h str =
    do hPutStrLn h "Content-Type: text/plain; charset=utf-8"
       hPutStrLn h ""
       hPutStr h $ RFC2279.encode str

hPutFileReference h fr =
    do hPutStr h "Content-Type: "
       hPutStrLn h (fileReferenceContentType fr)
       hPutStrLn h ""
       hFlush h
       hin <- openFile (fileReferenceName fr) ReadMode
       rawHandleCopy hin h
       hClose hin

hPutResponseFileReference h (ResponseFileReference fname) =
    do hFlush h
       hin <- openFile fname ReadMode
       rawHandleCopy hin h
       hClose hin

hPutStatus h (Status status reason_phrase elems) =
    do hPutStr h "Status: "
       hPutStr h status_str
       hPutStr h " "
       hPutStrLn h reason_phrase
       case elems of
         Nothing -> hPutStrLn h ""
	 Just _  -> itell h message
    where status_str = show status
	  ttl = "Error: " ++ status_str ++ ' ' : reason_phrase
	  message = standardPage ttl (fromJust elems)

hPutLocation h (Location url) =
    do hPutStr h "Location: "
       hPutStrLn h (unURL url)
       hPutStrLn h ""

hPutFreeForm h (FreeForm fileName contentType rawContents) =
    do hPutStr h "Content-Type: "
       hPutStr h contentType
       when (not (null fileName)) $
         do hPutStr h " ;name=\""
	    hPutStr h fileName
	    hPutStr h "\""
       hPutStrLn h ""
       hPutStrLn h ""
       hPutStr h rawContents
