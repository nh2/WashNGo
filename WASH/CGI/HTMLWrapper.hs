module WASH.CGI.HTMLWrapper
  (module H, module WASH.CGI.HTMLWrapper) where

import qualified Prelude
import WASH.HTML.HTMLMonad as H hiding (html)

-- |create a standard XHTML page from a title string and body elements
standardPage :: (Prelude.Monad m) => 
		Prelude.String -> WithHTML x m a -> WithHTML y m ()
standardPage ttl elems =
  htmlHeader ttl (body_S (h1_S (text ttl) ## elems))

-- |create a standard XHTML page without heading from a title string and body elements
htmlHeader :: (Prelude.Monad m) =>
	      Prelude.String -> WithHTML x m a -> WithHTML y m ()
htmlHeader ttl elems =
  html (head_S (title_S (text ttl))
     ## elems)

-- |create a standard XHTML page from a title string, a stylesheet URL and body
-- elements 
cssPage :: (Prelude.Monad m) =>
	   Prelude.String -> Prelude.String -> WithHTML x m a -> WithHTML y m ()
cssPage ttl cssurl elems =
  cssHeader ttl cssurl (body_S (h1_S (text ttl) ## elems))

-- |create an XHTML page with CSS reference but without heading from a title
-- string, the URL of the stylesheet and body elements
cssHeader :: (Prelude.Monad m) =>
	     Prelude.String -> Prelude.String -> WithHTML x m a -> WithHTML y m ()
cssHeader ttl cssurl elems =
  html (head_S (do title_S (text ttl)
		   link_S (do attr_SS "rel" "stylesheet"
			      attr_SS "type" "text/css" 
			      attr_SD "href" cssurl))
     ## elems)

-- |create a bare XHTML root tag with proper namespace attribute
html :: (Prelude.Monad m) =>
	WithHTML x m a -> WithHTML y m ()
html elems =
  html_T (do elems
	     attr_SS "xmlns" "http://www.w3.org/1999/xhtml")

