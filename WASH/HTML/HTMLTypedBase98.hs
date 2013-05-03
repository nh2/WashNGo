-- © 2002 Peter Thiemann
module WASH.HTML.HTMLTypedBase98 
  (module WASH.HTML.HTMLBase, module WASH.HTML.HTMLTypedBase98)
  where

import Data.Char
import WASH.HTML.HTMLBase

-- typed layer
-- attributes

data ATTRIBUTE a => ATTR a =				    -- a phantom type
  ATTR { unATTR :: ATTR_ }

class Show a => ATTRIBUTE a where
  show_name :: a -> String
-- 
  show_name = map toLower . show

-- attribute values

-- class (ATTRIBUTE a, Show v) => AttrValue a v

mkUAttr :: ATTRIBUTE a => a -> String -> ATTR a
mkUAttr a vstr = ATTR (attr_ (show_name a) vstr)

-- mkAttr :: (AttrValue a v) => a -> v -> ATTR a
-- mkAttr a v = 
--   mkUAttr a (av raw)
--   where raw = show v

av (str@('\"':_)) = let str1 = read str :: String in str1
av str = str

-- attr a v into = add_attr into (mkAttr a v)

uattr a vstr into = add_attr into (mkUAttr a vstr)

--  elements

data TAG t => ELT t =
    ELT { unELT :: ELEMENT_ }

class Show t => TAG t where
  make :: t -> ELT t
  show_tag :: t -> String
--
  make = make_standard
  show_tag = map toLower . show

make_standard t = ELT (element_ (show_tag t) [] [])
make_empty    t = ELT (empty_   (show_tag t) [])

--
-- class (TAG s, TAG t) => AddTo s t

-- add :: (AddTo s t) => ELT s -> ELT t -> ELT s
add (ELT e_) (ELT e'_) =
  ELT (add_ e_ e'_)

-- add' :: (AddTo s t) => ELT t -> ELT s -> ELT s
add' = flip add

-- class (TAG t) => AddAttr t a

-- add_attr :: (AddAttr t a) => ELT t -> ATTR a -> ELT t
add_attr (ELT e_) (ATTR att) =
  ELT (add_attr_ e_ att)

-- attr' :: (AddAttr t a) => ATTR a -> ELT t -> ELT t
attr' = flip add_attr

-- --================= FUNCTIONS =================----

-- --show functions------------------

show_html (ELT e_) = show e_

-- creating text elements

class AdmitChildCDATA a where
  text, rawtext, formattedtext :: String -> ELT a -> ELT a
  text str = add' (ELT (cdata_ [] str) :: ELT CDATA)
  rawtext str = add' (ELT (cdata_ [CDATA_ENCODED] str) :: ELT CDATA)
  formattedtext str = add' (ELT (cdata_ [CDATA_FORMATTED] str) :: ELT CDATA)

data CDATA = CDATA deriving Show
instance TAG CDATA

-- creating comment elements

comment :: String -> ELT a -> ELT a
comment str (ELT e_) = ELT (add_ e_ (comment_ str))

-- creating the main document

data DOCUMENT = DOCUMENT deriving Show
instance TAG DOCUMENT where
  make DOCUMENT = 
    ELT (doctype_
  	  ["HTML"
          ,"PUBLIC"
	  ,"\"-//W3C//DTD HTML 4.01//EN\""
	  ,"\"http://www.w3.org/TR/html4/strict.dtd\""]
	  [])

-- instance AddTo DOCUMENT HTML -- must be in HTMLPrelude

show_document :: ELT DOCUMENT -> String
show_document = show_html
