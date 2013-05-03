-- © 2002 Peter Thiemann
module WASH.CGI.Style (Style(..), using) where

import WASH.HTML.HTMLMonad hiding (map, div, head, span)
import Data.List

infixl 5 :^:
infix 9 :=:

-- |First class style elements. Intended for CSS2.
data Style 
  = NoStyle
  | String :=: String	    -- ^primitive style @name :=: value@
  | Style  :^: Style	    -- ^combine two styles
  | Named String	    -- ^reference to style sheet

instance Show Style where
  showsPrec n NoStyle = id
  showsPrec n (s1 :=: s2) = showString s1 . showString ": " . showString s2
  showsPrec n (s1 :^: s2) = shows s1 . showString "; " . shows s2
  showsPrec n (Named s) = id

-- |collects a style into a list of class names and primitive styles
collect :: Style -> ([String], Style)
collect st = g ([],NoStyle) st
  where
    g acc NoStyle = acc
    g (cls, sts) st@(n :=: v) = (cls, st :^: sts)
    g acc (st1 :^: st2) = g (g acc st2) st1
    g (cls, sts) (Named n) = (n : cls, st)

attach :: (Monad m) => Style -> WithHTML x m ()
attach sty = 
  let (cls, st) = collect sty in
  do case cls of
       [] -> empty
       _  -> attr "class" (concat $ intersperse " " cls)
     case st of NoStyle -> empty
		_       -> attr "style" (show st)
     
-- |Attaches a style to a field constructor.
using :: (Monad m)
	=> Style
	-> (WithHTML x m b -> c)	-- ^a field constructor, typically 'HTMLField'
	-> WithHTML x m b -> c		-- ^styled version of this constructor
using style elem x = elem (x ## attach style)
