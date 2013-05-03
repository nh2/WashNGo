-- © 2001, 2002, 2005 Peter Thiemann
module WASH.HTML.HTMLMonadBase
  (module WASH.HTML.HTMLMonadBase, B.ELEMENT_, B.ATTR_, B.attr_name, B.attr_value)
  where
import qualified WASH.HTML.HTMLBase as B
type Element = B.ELEMENT_
type Attributes = [Attribute]
type Attribute = B.ATTR_
data WithHTML x m a =
  WithHTML { unWithHTML :: Element -> m (a, Element) }
type HTMLCons x y m a = WithHTML x m a -> WithHTML y m a
instance Monad m => Monad (WithHTML x m) where
  return a = WithHTML (\elem -> return (a, elem))
  ma >>= f = WithHTML (\elem -> unWithHTML ma elem >>= \(a, elem') ->
                                unWithHTML (f a) elem')
-- contributed by Frederik Eaton <frederik@ofb.net>
--instance MonadFix m => MonadFix (WithHTML x m) where
--  mfix f = WithHTML (\elem ->
--		     mfix (\x -> (unWithHTML (f x)) elem >>= (return.fst))
--		     >>= (\x -> return (x,elem)))
lift :: Monad m => m a -> WithHTML x m a
lift ma = WithHTML (\elem -> ma >>= \a -> return (a, elem))
get_attrs :: Monad m => WithHTML x m Attributes
get_attrs = WithHTML (\elem -> return (B.get_attrs_ elem, elem))
-- | empty node sequence
empty :: Monad m => WithHTML x m ()
empty = return ()
-- | concatenation of sequences
infixl 1 ##
x ## y = x >>= \a -> y >> return a
-- | cleanup of attribute values
av (str@('\"':_)) = let str1 = read str :: String in str1
av str = str
--
addNode add cdata =
  \s -> WithHTML (\elem -> return ((), add elem (cdata s)))
comment, comment_S, comment_T :: Monad m => String -> WithHTML x m ()
comment   = addNode B.add_ B.comment_
comment_S = addNode B.add_ B.comment_S
comment_T = addNode B.add_ B.comment_T
-- | create a text node with all illegal characters properly escaped
text :: Monad m => String -> WithHTML x m ()
text          = addNode B.add_ (B.cdata_ [])
-- | create a text node from any Showable type
showText :: (Monad m, Show a) => a -> WithHTML x m ()
showText x = text (av (show x))
-- | create a text node where the string is dropped into the webpage without
-- change, e.g., preserving entities 
rawtext :: Monad m => String -> WithHTML x m ()
rawtext       = addNode B.add_ (B.cdata_ [B.CDATA_ENCODED])
formattedtext :: Monad m => String -> WithHTML x m ()
formattedtext = addNode B.add_ (B.cdata_ [B.CDATA_FORMATTED])
text_S, rawtext_S, formattedtext_S :: Monad m => String -> WithHTML x m ()
text_S          = addNode B.add_ (B.cdata_S [])
rawtext_S       = addNode B.add_ (B.cdata_S [B.CDATA_ENCODED])
formattedtext_S = addNode B.add_ (B.cdata_S [B.CDATA_FORMATTED])
text_T, rawtext_T, formattedtext_T :: Monad m => String -> WithHTML x m ()
text_T          = addNode B.add_ (B.cdata_T [])
rawtext_T       = addNode B.add_ (B.cdata_T [B.CDATA_ENCODED])
formattedtext_T = addNode B.add_ (B.cdata_T [B.CDATA_FORMATTED])
attr :: Monad m => String -> String -> WithHTML x m ()
attr a = addNode B.add_attr_ (B.attr_ a)
attr_SS :: Monad m => String -> String -> WithHTML x m ()
attr_SS a = addNode B.add_attr_ (B.attr_SS a)
attr_TS :: Monad m => String -> String -> WithHTML x m ()
attr_TS a = addNode B.add_attr_ (B.attr_TS a)
attr_TD :: Monad m => String -> String -> WithHTML x m ()
attr_TD a = addNode B.add_attr_ (B.attr_TD a)
attr_SD :: Monad m => String -> String -> WithHTML x m ()
attr_SD a = addNode B.add_attr_ (B.attr_SD a)
(@@) :: Monad m => String -> String -> WithHTML x m ()
a @@ v = attr a v
addMaker subelem ma =
  WithHTML (\elem -> unWithHTML ma subelem >>= \(a, subelem') ->
                     return (a, B.add_ elem subelem'))
mkElement, mkEmpty :: Monad m => String -> HTMLCons x y m a
mkElement tag = addMaker $ B.element_ tag [] []
mkEmpty tag   = addMaker $ B.empty_   tag []
mkElement_S, mkEmpty_S :: Monad m => String -> HTMLCons x y m a
mkElement_S tag = addMaker $ B.element_S tag [] []
mkEmpty_S tag   = addMaker $ B.empty_S   tag []
mkElement_T, mkEmpty_T :: Monad m => String -> HTMLCons x y m a
mkElement_T tag = addMaker $ B.element_T tag [] []
mkEmpty_T tag   = addMaker $ B.empty_T   tag []
build_document :: Monad m => WithHTML x m a -> m Element
build_document ma = unWithHTML ma
  (B.doctype_T 
   [ "html"
   , "PUBLIC"
   , "\"-//W3C//DTD XHTML 1.0 Transitional//EN\""
   , "\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\""] [])
  >>= \ (a, elem) -> return elem
