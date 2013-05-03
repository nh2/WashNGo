module WASH.CGI.AbstractSelector 
  -- the public interface
  -- ( as_rows, as_cols, table_io, getText, selectionGroup, selectionButton, selectionDisplay)
where

import WASH.CGI.BaseCombinators (unsafe_io, once)
import WASH.CGI.CGIInternals (HTMLField, INVALID, ValidationError (..))
import WASH.CGI.CGIMonad hiding (lift)
import WASH.CGI.HTMLWrapper
import WASH.CGI.RawCGIInternal hiding (CGIEnv (..))
import WASH.Utility.JavaScript

import Data.Char (isSpace)
import Data.List ((\\))
import Data.Maybe (isJust, fromMaybe)


-- |abstract table (twodimensional)
data AT =
    AT { as_raw :: [[String]]
       , as_rows :: Int
       , as_cols :: Int
       }

instance Show AT where
  showsPrec i as = showsPrec i (as_rows as, as_cols as)

instance Read AT where
  readsPrec i inp =
    [ (AT { as_raw = [], as_rows = r, as_cols = c }, str')
    | ((r,c), str') <- readsPrec i inp
    ]

-- |abstract row
data AR = AR [String]
  deriving (Eq, Show)

instance Read AR where
  readsPrec i inp =
    case dropWhile isSpace inp of
      'A':'R':xs ->
	[(AR xss, rest) | (xss, rest) <- reads xs]
      _ -> []
  readList inp =
    case dropWhile isSpace inp of
      '+':xs ->
	[ (ar:ars, xs2)| (ar, xs1) <- reads xs, (ars, xs2) <- readList xs1 ]
      '-':xs ->
	[ (ars\\[ar], xs2)| (ar, xs1) <- reads xs, (ars, xs2) <- readList xs1 ]
      "" -> 
	[([],[])]
      _ -> []

getAR :: AT -> Int -> AR
getAR at r =
  AR (getRow (as_raw at) r)

unAR :: AR -> [String]
unAR (AR x) = x

-- |Transform an IO action that produces a table in list form into a CGI action
-- that returns an abstract table. 
table_io :: IO [[String]] -> CGI AT
table_io io =
  once $
  do raw <- unsafe_io io
     let r = length raw
	 c = length (Prelude.head raw)
     return (AT { as_raw = raw
		, as_rows = r
		, as_cols = c
		})

-- |Access abstract table by row and column. Produces a test node in the
-- document monad.
getText :: Monad m => AT -> Int -> Int -> WithHTML x m ()
getText as r c =
  text (getEntry (as_raw as) r c)

getRow xss r 
  | 0 <= r && r < length xss = xss !! r
  | otherwise = []

getCol xs c
  | 0 <= c && c < length xs = xs !! c
  | otherwise = ""

getEntry xss r c =
  getCol (getRow xss r) c
  
-- |a selection group is a virtual field that never appears on the screen, but
-- gives rise to a hidden input field!
data SelectionGroup a x =
     SelectionGroup { selectionName   :: String
		    , selectionToken  :: CGIFieldName
		    , selectionString :: Maybe String
		    , selectionValue  :: Maybe a
		    , selectionBound  :: Bool
		    }

validateSelectionGroup rg =
  case selectionValue rg of 
    Nothing | selectionBound rg -> 
      Left [ValidationError (selectionName rg) (selectionToken rg) (selectionString rg)]
    _ ->
      Right SelectionGroup  { selectionName = selectionName rg
			, selectionToken = selectionToken rg
			, selectionString = selectionString rg
			, selectionValue = selectionValue rg
			, selectionBound = selectionBound rg
			}

valueSelectionGroup rg =
  case selectionValue rg of
    Nothing -> error ("SelectionGroup { " ++
		      "selectionName = " ++ show (selectionName rg) ++ ", " ++
		      "selectionString = " ++ show (selectionString rg) ++ ", " ++
		      "selectionBound = " ++ show (selectionBound rg) ++
		      " }")
    Just vl -> vl

-- |Create a selection group for a table. Selects one row.
selectionGroup :: (CGIMonad cgi) => WithHTML y cgi (SelectionGroup AR INVALID)
selectionGroup =
  do token <- lift nextName
     let fieldName = show token
     info <- lift getInfo
     lift $ addField fieldName False
     let bds = bindings info
	 maybeString = bds >>= assocParm fieldName
	 -- experimental
	 isBound = fromMaybe False (do "UNSET" <- maybeString
				       return True)
	 maybeVal = maybeString >>= (g . reads)
	 g ((a,""):_) = Just a
	 g _ = Nothing
     input (do attr "type" "hidden"
	       attr "name" fieldName
	       attr "value" "UNSET")
     return $
       SelectionGroup { selectionName = fieldName
		      , selectionToken = token
		      , selectionString = maybeString
		      , selectionValue = maybeVal
		      , selectionBound = isBound
		      }

-- |Create a selection button for an abstract table
selectionButton :: (CGIMonad cgi) =>
  SelectionGroup AR INVALID -> AT -> Int -> HTMLField cgi x y ()
selectionButton sg at row buttonAttrs =
  input (do attr "type" "radio"
	    attr "name" (fieldName++"_")
	    attr "onclick" ("var ff=this.form."++fieldName++
			    ";ff.value=" ++ jsShow (show (getAR at row))++
			    ";if(ff.getAttribute('onchange'))"++
			    "{WASHSubmit(ff.name);"++
			    "};")
	    buttonAttrs)
  where
    fieldName = selectionName sg


-- |Create a labelled selection display for an abstract table. The display
-- function takes the button element and a list of text nodes corresponding to
-- the selected row and is expected to perform the layout.
selectionDisplay :: (CGIMonad cgi) =>
  SelectionGroup AR INVALID -> AT -> Int ->
  (WithHTML x cgi () -> [WithHTML x cgi ()] -> WithHTML x cgi a) ->
  WithHTML x cgi a
selectionDisplay sg at row displayFun =
  displayFun (selectionButton sg at row empty)
	     (Prelude.map text $ getRow (as_raw at) row)

-- |Create a choice group for a table (0-*).
choiceGroup :: (CGIMonad cgi) => WithHTML x cgi (SelectionGroup [AR] INVALID)
choiceGroup =
  do token <- lift nextName
     let fieldName = show token
     info <- lift getInfo
     lift $ addField fieldName False
     let bds = bindings info
	 maybeString = bds >>= assocParm fieldName
	 maybeVal = maybeString >>= (g . reads)
	 g ((a,""):_) = Just a
	 g _ = Nothing
     input (do attr "type" "hidden"
	       attr "name" fieldName
	       attr "value" "")
     return $
       SelectionGroup { selectionName = fieldName
		      , selectionToken = token
		      , selectionString = maybeString
		      , selectionValue = maybeVal
		      , selectionBound = isJust bds
		      }

-- |Create one choice button for an abstract table
choiceButton :: (CGIMonad cgi) =>
  SelectionGroup [AR] INVALID -> AT -> Int -> HTMLField cgi x y ()
choiceButton sg at row buttonAttrs =
  do script_T (rawtext $
	       "SubmitAction[SubmitAction.length]=" ++
	       "function(){"++
	       "var f=document.forms[0];" ++
	       "if(f."++buttonFieldName++".checked){" ++ 
		 "f."++fieldName++".value=" ++ jsShow ('+':show (getAR at row)) ++
		   "+f."++fieldName++".value;" ++
	       "};return true};")
     input_T
      (do attr "type" "checkbox"
	  attr "name" buttonFieldName
	  buttonAttrs)
  where
    fieldName = selectionName sg
    buttonFieldName = fieldName++'_':show row

-- |Create a labelled choice display for an abstract table. The display
-- function takes the button element and a list of text nodes corresponding to
-- the selected row and is expected to perform the layout.
choiceDisplay :: (CGIMonad cgi) =>
  SelectionGroup [AR] INVALID -> AT -> Int ->
  (WithHTML x cgi () -> [WithHTML x cgi ()] -> WithHTML x cgi a) ->
  WithHTML x cgi a
choiceDisplay sg at row displayFun =
  displayFun (choiceButton sg at row empty)
	     (Prelude.map text $ getRow (as_raw at) row)
