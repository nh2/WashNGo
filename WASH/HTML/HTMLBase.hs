-- � 2001-2003 Peter Thiemann
module WASH.HTML.HTMLBase 
{- 
  (ATTR_(), attr_, attr_name, attr_value
  ,ELEMENT_(), element_, empty_, cdata_, comment_, doctype_
  ,CDATA_OPTIONS(..)
  ,add_, add_attr_
  ,get_attrs_
  ,BT(..)
  ,element_S, empty_S, cdata_S, comment_S, doctype_S
  ,element_T, empty_T, cdata_T, comment_T, doctype_T
  ,attr_SS, attr_SD, attr_TS, attr_TD
  ,showTemplatified)
-}
where

import Data.Char

data BT = STATIC | DYNAMIC | TOPLEVEL

-- untyped layer
-- attributes

data ATTR_ =
  ATTR_ { attr_BT :: BT
	, attr_value_BT :: BT
	, attr_name :: String
        , attr_value :: String
	}

attr_   = ATTR_ DYNAMIC  DYNAMIC
attr_SS = ATTR_ STATIC   STATIC
attr_SD = ATTR_ STATIC   DYNAMIC
attr_TS = ATTR_ TOPLEVEL STATIC
attr_TD = ATTR_ TOPLEVEL DYNAMIC

-- elements

data ELEMENT_ =
    ELEMENT_ { elem_BT :: BT
	     , tag :: String
    	     , attrs :: [ATTR_]
	     , elems :: [ELEMENT_]
	     }
  | EMPTY_   { elem_BT :: BT
	     , tag :: String
  	     , attrs :: [ATTR_]
	     }
  | CDATA_   { elem_BT :: BT
	     , elem_cdata :: String
	     }
  | COMMENT_ { elem_BT :: BT
	     , elem_comment :: String
	     }
  | DOCTYPE_ { elem_BT :: BT
	     , doctype :: [String]
  	     , elems :: [ELEMENT_]
	     }

data CDATA_OPTIONS = CDATA_ENCODED | CDATA_FORMATTED
  deriving (Eq)

element_  = ELEMENT_ DYNAMIC
element_S = ELEMENT_ STATIC
element_T = ELEMENT_ TOPLEVEL
empty_    = EMPTY_ DYNAMIC
empty_S   = EMPTY_ STATIC
empty_T   = EMPTY_ TOPLEVEL
makeEncoder opt = format . encode
  where format | CDATA_FORMATTED `elem` opt = id
	       | otherwise = htmlFormat
	encode | CDATA_ENCODED `elem` opt = id
	       | otherwise = htmlEncode
cdata_  opt = CDATA_ DYNAMIC . makeEncoder opt
cdata_S opt = CDATA_ STATIC . makeEncoder opt
cdata_T opt = CDATA_ TOPLEVEL . makeEncoder opt
comment_  = COMMENT_ DYNAMIC
comment_S = COMMENT_ STATIC
comment_T = COMMENT_ TOPLEVEL
doctype_  = DOCTYPE_ DYNAMIC
doctype_S = DOCTYPE_ STATIC
doctype_T = DOCTYPE_ TOPLEVEL

add_ e_ e'_ = e_ { elems = e'_ : elems e_}
-- | Takes element and attribute. Attaches attribute to the element. Replaces
-- prior attribute with same name.
add_attr_ e_ att = 
  let nameOfAtt = attr_name att
      all_attrs = attrs e_
      f [] = Nothing
      f (att' : attrs) = if attr_name att' == nameOfAtt 
      			 then return (att : attrs)
			 else f attrs >>= \ attrs' -> return (att' : attrs')
      new_attrs = case f all_attrs of
		    Nothing -> att : all_attrs
		    Just attrs -> attrs
  in  e_ { attrs = new_attrs }

get_attrs_ = attrs

-- show functions

instance Show ATTR_ where
  showsPrec i = shows_attribute
  showList    = shows_attributes

shows_attributes :: [ATTR_] -> ShowS
shows_attributes atts = foldr (.) id (map shows_attribute atts)

shows_attribute :: ATTR_ -> ShowS
shows_attribute a =
  showChar ' ' . showString (attr_name a) .
  case attr_value a of
    "()" ->
      id
    str@('\"':_) ->
      showString "=\"" . htmlAttr (read str) . showString "\""
    str ->
      showString "=\"" . htmlAttr str . showString "\""

instance Show ELEMENT_ where
  showsPrec i = shows_element
  showList = shows_elements

shows_elements :: [ELEMENT_] -> ShowS
shows_elements elts = foldr (.) id (reverse (map shows_element elts))

shows_element :: ELEMENT_ -> ShowS
shows_element (EMPTY_ bt tag atts) =
  showChar '<' . showString tag . shows atts . showString "\n/>"
shows_element (ELEMENT_ bt tag atts elts) =
  showChar '<' . showString tag . shows atts . showChar '>'
  . shows_elements elts
  . showString "</" . showString tag . showString "\n>"
shows_element (DOCTYPE_ bt strs elems) =
  showString "<!DOCTYPE" . 
  foldr (\str f -> showChar ' ' . showString str . f) id strs . showString "\n>" .
  showString "<!-- generated by WASH/HTML 0.11\n-->" .
  shows_elements elems .
  showChar '\n'
shows_element (CDATA_ bt str) =
  showString str
shows_element (COMMENT_ bt str) =
  showString "<!-- " . commentEncode str . showString "\n-->"

-- |removes illegal characters and sequences of -- from comment
commentEncode :: String -> ShowS
commentEncode "" ys = ys
commentEncode ('-':xs@('-':_)) ys = '-':' ': commentEncode xs ys
commentEncode (x:xs) ys = 
  if x == chr 0x9 ||
     x == chr 0xa ||
     x == chr 0xd ||
     x >= chr 0x20 && x <= chr 0xd7ff ||
     x >= chr 0xe000 && x <= chr 0xfffd ||
     x >= chr 0x10000 && x <= chr 0x10ffff
  then x: commentEncode xs ys
  else '?': commentEncode xs ys

htmlForbiddenChars = "<&\""

htmlEncode :: String -> String
htmlEncode s = htmlAttr s ""

htmlFormat s = s

htmlAttr :: String -> ShowS
htmlAttr "" = id
htmlAttr (x:xs) =
  (if x `elem` htmlForbiddenChars
  then showString "&#" . shows (ord x) . showChar ';'
  else showChar x) . htmlAttr xs

{--htmlFormat "" = ""
htmlFormat (x:xs) =
	if isSpace x then
	  "\n " ++ htmlFormat (dropWhile isSpace xs)
	else
	  x : htmlFormat xs	  
--}
