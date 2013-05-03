-- © 2001, 2002 Peter Thiemann
module Main where
 
import Prelude hiding (head, map, span, div, init)
import qualified Prelude (head, map, span, div)
import WASH.CGI.CGI hiding (span, head, map, div)
import qualified WASH.CGI.Persistent2 as P
import Data.Maybe
import Control.Monad
import Data.List hiding (head, map, span, init)
import WASH.CGI.Types

type StoreTTEntry = Maybe (String, [String], [TTEntry])

main = runWithHook [] cgigen mainCGI

cgigen [owner] =
  do hdl <- P.init ('T':'T':owner) Nothing
     alltt <- P.get hdl
     case alltt of
       Nothing ->
           tell (Status 404 "Not Found" Nothing)
       Just (passwd, headers, tt) -> 
         showTT owner passwd headers tt
cgigen strs = 
  tell (Status 404 "Not Found" Nothing)

mainCGI =
  standardQuery "Time Table" $
  do headers <- table $
       mapM makeRow
	[("Title of time table ", "Time Table")
        ,("Day 1", "Monday")       
	,("Day 2", "Tuesday")
	,("Day 3", "Wednesday")
	,("Day 4", "Thursday")
	,("Day 5", "Friday")]
     ttnameF <- makeRow ("Your time table's name: ", "")
     submit (F2 ttnameF (FL headers)) initAction empty
  where makeRow (prompt, dflt) =
	  tr (td (text prompt) >> 
		td (inputField (fieldSIZE 20 ## fieldVALUE dflt)))

initAction (F2 ttnameF (FL headersF)) =
  let ttname = unNonEmpty (value ttnameF)
      headers = Prelude.map (unNonEmpty . value) headersF
  in
    do hdl <- P.init ('T':'T':ttname)
                              (Just ("", headers, initialTimetable))
       Just (passwd, headers, tt) <- P.get hdl
       askTT ttname passwd headers tt

makeTable ttentry tt headers = table $
       do attr "border" "3"
	  thead $ tr $ mapM_ (\day -> th (text day ## attr "width" "150")) headers
	  mapM (\hour -> tr (td (text (show hour) ## attr "align" "right") >>
     			 mapM (\day -> ttentry tt day hour)
			      [1 .. 5]))
       	  	[8 .. 19]

askTT :: String -> String -> [String] -> [TTEntry] -> CGI ()
askTT ttname passwd headers tt = 
  standardQuery (Prelude.head headers) $ 
  do xys <- makeTable askEntry tt headers
     p $
       do text "Your password "
	  passwdF <- passwordInputField (fieldSIZE 20)
	  submit (F2 passwdF (FL (concat xys))) 
	         (saveAction ttname passwd headers)
		 (fieldVALUE "Save")
	  b $ text " or "
	  text "enter a new name "
	  newnameF <- inputField (fieldSIZE 20)
	  submit (F3 passwdF newnameF (FL (concat xys)))
	         (saveAsAction ttname passwd headers)
		 (fieldVALUE "Save as")

showTT :: String -> String -> [String] -> [TTEntry] -> CGI ()
showTT ttname passwd headers tt =
  standardQuery (Prelude.head headers) $ 
  makeTable showEntry tt headers

saveAsAction ttname ttpasswd headers (F3 passwdF newnameF (FL entriesF)) =
  let passwd = unNonEmpty (value passwdF)
      newname = unNonEmpty (value newnameF)
      entries = Prelude.map extract entriesF
      extract (FA (day, hour) inf) = (day, hour, value inf)
  in  saveNamedAction newname passwd headers entries

saveAction ttname ttpasswd headers (F2 passwdF (FL entriesF)) =
  let passwd = unNonEmpty (value passwdF)
      entries = Prelude.map extract entriesF
      extract (FA (day, hour) inf) = (day, hour, value inf)
  in  saveNamedAction ttname passwd headers entries

saveNamedAction ttname passwd headers entries =
  do hdl <- P.init ('T':'T':ttname) Nothing
     maybeTtdesc <- P.get hdl
     case maybeTtdesc of
       Nothing ->
         performSave ttname hdl passwd headers entries
       Just (oldpasswd, oldheaders, oldtt) ->
         if null oldpasswd || oldpasswd == passwd then
	   performSave ttname hdl passwd headers entries
	 else
	   htell (standardPage "Time Table Service"
	         (text "Wrong Password for " ## text ttname))

performSave ttname hdl passwd headers entries =
  do P.set hdl (Just (passwd, headers, tt))
     showTT ttname passwd headers tt
  where tt = makett entries
-- 
makett entries =
  [TTEntry day hour count str
  | (day, hour, str) <- entries, 
    let count = length (filter (=='|') str) + 1,
    not (null str)]


-- 
askEntry tt day hour =
  do inf <- td (textInputField (fieldVALUE str))
     return (FA (day, hour) inf)
  where maybeStr = extractEntry (sort tt) day hour
	str = fromMaybe "" maybeStr
	rows = length (filter (=='|') str) + 1

showEntry tt day hour =
  if isJust maybeStr
  then td (attr "rowspan" (show rows) ## layout str rows)
  else empty
  where maybeStr = extractEntry (sort tt) day hour
	str = fromMaybe "" maybeStr
	rows = length (filter (=='|') str) + 1

layout "" _ = 
  empty
-- layout str 1 =
--   text str
layout str n =
  table (row str)
  where row "" = empty
	row str = let (fst, rst) = Prelude.span (/='|') str in
		  tr (td (text fst)) ## row1 rst
	row1 "" = empty
	row1 ('|':rst) = row rst

initialTimetable = []

extractEntry [] d h = Just ""
extractEntry (TTEntry d' h' l s : _) d h | d == d' && h == h' = Just s
extractEntry (TTEntry d' h' l s : _) d h | d == d' && h >= h' && h < h' + l = Nothing
extractEntry (_ : rest) d h = extractEntry rest d h

data TTEntry = TTEntry Int Int Int String
  deriving (Show, Read, Eq, Ord)

instance Types TTEntry where
  ty ~(TTEntry xa xb xc xd) =
    TS (TRData "TTEntry" []) 
       [TD "TTEntry" [] [CR "TTEntry" Nothing [tra, trb, trc, trd]]]
    where TS tra defsa = ty xa
	  TS trb defsb = ty xb
	  TS trc defsc = ty xc
	  TS trd defsd = ty xd

