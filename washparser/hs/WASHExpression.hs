module WASHExpression where

import Control.Monad
import Data.List (isPrefixOf)

import WASHFlags
import qualified WASHUtil
import WASHData
import WASHOut

code :: FLAGS -> [CodeFrag] -> ShowS
code flags [] = id
code flags (x:xs) = code' flags x . code flags xs

code' :: FLAGS -> CodeFrag -> ShowS
code' flags (HFrag h) = 
  showString h
code' flags (EFrag e) =
  runOut $ element flags e
code' flags (CFrag cnts) =
  showChar '(' .
  runOut (contents flags [] cnts) .
  showChar ')'
code' flags (AFrag attrs) =
  showChar '(' .
  WASHUtil.itemList (attribute flags) "CGI.empty" " >> " attrs .
  showChar ')'
code' flags (VFrag var) = 
  id
code' flags _ = error "Unknown type: code"

outMode :: Mode -> Out ()
outMode = outShowS . showMode

showMode :: Mode -> ShowS
showMode V = id
showMode S = showString "_T"
showMode F = showString "_S"

element :: FLAGS -> Element -> Out [String]
element flags el@(Element mode nm ats cnt et) =
  case break (==':') nm of
    (ns, ':' : elnm) ->
      ns_element flags ns elnm el 
    ("input", "") ->
      input_element flags mode nm ats cnt et
    ("textarea", "") ->
      textarea_element flags mode nm ats cnt et
    _ ->
      do outChar '('
	 outString "CGI."
	 outString nm
	 when (generateBT flags) $ outMode mode
	 outChar '('
	 outShowS $ attributes flags ats
	 rvs <- contents flags [] cnt
	 outString "))"
	 return rvs

textarea_element flags mode nm ats cnt et =
  let at_name = getAttribute ats "name"
      preset = getTextualContentAsStringExpression cnt
      processedAttributes = ["name"]
      cleanedAttributes = removeAttributes (`elem` processedAttributes) ats
  in
      do outString "(CGI."
	 outString "makeTextarea"
	 -- attention: the preset text is raw so it may contain character references!
	 outString preset
	 outChar '('
	 outShowS $ attributes flags cleanedAttributes
	 outString "empty))"
	 return [at_name]

input_element flags mode nm ats cnt et =
  let at_type = getAttribute ats "type"
      at_name = getAttribute ats "name"
      parms    = getAttribute ats "WASH:parms"
      callback = getAttribute ats "WASH:callback"
      call     = getAttribute ats "WASH:call"
      preset = getTextualContent cnt
      processedAttributes = ["type", "name", "WASH:parms", "WASH:callback", "WASH:call"]
      cleanedAttributes = removeAttributes (`elem` processedAttributes) ats
      do_element elnm =
	do outChar '('
	   outString "CGI."
	   outString elnm
	   outChar '('
	   outShowS $ attributes flags cleanedAttributes
	   outString "empty))"
	   return [at_name]
  in
  case at_type of
    "text" ->
      do_element "inputField"
    "password" ->
      do_element "passwordInputField"
    "checkbox" ->
      do_element "checkboxInputField"
    -- "radio" -> -- use the RB abstraction
    "submit" ->
      let Just (funpart, args) = 
	       parse_WASH_call call `mplus`
	       parse_WASH_callback callback parms
	  largs = length args
      in
      do outString "(CGI."
	 outString at_type
	 foldr (\arg out -> do outString " (CGI.F2 ("
			       outString arg
			       outString ") "
			       out
			       outString ")")
	       (outString " CGI.F0") 
	       args
	 outString "(\\"
	 convertArgs largs
	 outString " -> "
	 outChar '('
	 outString funpart -- funpart :: (arg1, ..., argn) -> CGI ()
	 outChar ')'
	 unless (null args) $ convertRess '(' largs
	 outChar ')'
	 outChar '('
	 outShowS $ attributes flags cleanedAttributes
	 outString "empty))"
	 return []
    "reset" ->
      do_element "resetField"
    "file" ->
      do_element "fileInputField"
    -- "hidden" -> -- useless in WASH
    -- "image" ->  -- ???
    -- "button" -> -- ???

convertArgs 0 =
  outString " CGI.F0"
convertArgs n =
  do outString "(CGI.F2 xxxx____"
     outString (show n)
     convertArgs (n-1)
     outString ")"

convertRess c 0 =
  outChar ')'
convertRess c n =
  do outString (c:"CGI.value xxxx____")
     outString (show n)
     convertRess ',' (n-1)

parse_WASH_callback cb parms =
  Just (cb, parse_WASH_call_args [] parms)

parse_WASH_call str =
  case break (=='(') str of
    (funpart, '(':rest1 ) ->
      Just (funpart, parse_WASH_call_args [] rest1)
    ("", "") ->
      Nothing
    (funpart, "") ->
      Just (funpart, [])
    _ -> Nothing

parse_WASH_call_args acc str =
  case break (`elem` ",)") str of
    (arg, ',': rest) ->
      parse_WASH_call_args (arg:acc) rest
    (arg, ')': rest) ->
      reverse (arg:acc)
    ("", "") ->
      reverse (acc)
    (arg, "") ->
      reverse (arg:acc)

ns_element flags "WASH" elnm (Element mode _ ats cnt et) =
  let var = getAttribute ats "WASH:name"
      chk = getAttribute ats "WASH:check"
      parms    = getAttribute ats "WASH:parms"
      callback = getAttribute ats "WASH:callback"
      preset = getTextualContent cnt
  in
  if elnm `elem` [ "submit", "submitLink"] then
      let args     = words parms in
      do outString "(CGI."
	 outString elnm
	 if null args
	   then outChar '0'
	   else do outString ("(CGI.F" ++ show (length args))
		   mapM (\arg -> outString (' ' : arg)) args
		   outChar ')'
	 outChar '('
	 outString callback
	 outChar ')'
	 outChar '('
	 outShowS $ attributes flags (removeAttributes (isPrefixOf "WASH:") ats)
	 outString "empty))"
	 return []
  else if elnm `elem` [ "inputField", "textInputField"
		      , "passwordInputField", "checkboxInputField"
		      , "fileInputField"] then
      do outChar '('
	 outString "CGI."
	 outString elnm
	 outChar '('
	 outShowS $ attributes flags (removeAttributes (isPrefixOf "WASH:") ats)
	 outString "empty))"
	 return [var]
  else if elnm `elem` [ "checkedTextInputField", "checkedFileInputField"] then
      do outChar '('
	 outString "CGI."
	 outString elnm
	 outChar '('
	 outString chk
	 outChar ')'
	 outChar '('
	 outShowS $ attributes flags (removeAttributes (isPrefixOf "WASH:") ats)
	 outString "empty))"
	 return [var]
  else if elnm `elem` ["makeTextarea"] then
      do outString "(CGI."
	 outString elnm
	 -- attention: the preset text is raw so it may contain character references!
	 outString (show preset)
	 outChar '('
	 outShowS $ attributes flags (removeAttributes (isPrefixOf "WASH:") ats)
	 outString "empty))"
	 return [var]
  else if elnm `elem` ["makeButton"] then
      do outString "(CGI."
	 outString elnm
	 outChar '('
	 outShowS $ attributes flags (removeAttributes (isPrefixOf "WASH:") ats)
	 rvs <- contents flags [] cnt
	 outString "))"
	 return (var:rvs)
  else if elnm `elem` ["makeForm"] then
      do outString "(CGI."
	 outString elnm
	 outChar '('
	 outShowS $ attributes flags (removeAttributes (isPrefixOf "WASH:") ats)
	 rvs <- contents flags [] cnt
	 outString "))"
	 return rvs
  else
      error ("WASH element "++elnm++" not defined, yet")
ns_element flags ns elnm (Element mode nm ats cnt et) =
  do outChar '('
     outString "CGI.mkElement"
     when (generateBT flags) $ outMode mode
     outString (show nm)
     outChar '('
     outShowS $ attributes flags ats
     rvs <- contents flags [] cnt
     outString "))"
     return rvs

outRVS :: [String] -> Out ()
outRVS [] = outString "()"
outRVS (x:xs) =
  do outChar '('
     outString x
     mapM_ g xs
     outChar ')'
  where g x = do { outChar ','; outString x; }

outRVSpat :: [String] -> Out ()
outRVSpat [] = outString "(_)"
outRVSpat xs = outRVS xs

contents :: FLAGS -> [String] -> [Content] -> Out [String]
contents flags inRVS cts =
  case cts of
    [] ->
      do outString "return"
	 outRVS inRVS
	 return inRVS
    ct:cts ->
      do rvs <- content flags ct
	 case rvs of
	   [] ->
             case (cts, inRVS) of
	       ([],[]) ->
	         return []
	       _ ->
		 do outString " >> "
		    contents flags inRVS cts
	   _ ->
	     case (cts, inRVS) of
	       ([],[]) ->
	         return rvs
	       _ ->
		 do outString " >>= \\ "
		    outRVSpat rvs
		    outString " -> "
		    contents flags (rvs ++ inRVS) cts

content :: FLAGS -> Content -> Out [String]
content flags (CElement elem)  = 
  element flags elem
content flags (CText txt) =
  do text flags txt
     return []
content flags (CCode (VFrag var:c)) =
  do outShowS $ (showChar '(' . code flags c . showChar ')')
     return [var]
content flags (CCode c) =
  do outShowS $ (showChar '(' . code flags c . showChar ')')
     return []
content flags (CComment cc) =
  do outShowS $ (showString "return (const () " . shows cc . showChar ')')
     return []
content flags (CReference txt) =
  do text flags txt
     return []
content flags c = 
  error $ "Unknown type: content -- " ++ (show c)

text :: FLAGS -> Text -> Out [String]
text flags txt =
  do outString "CGI.rawtext"
     when (generateBT flags) $ outMode (textMode txt)
     outChar ' '
     outs (textString txt)
     return []

attributes :: FLAGS -> [Attribute] -> ShowS
attributes flags atts = 
  f atts
    where
      f [] = id
      f (att:atts) = 
	attribute flags att .
	showString " >> " .
	f atts

attribute :: FLAGS -> Attribute -> ShowS
attribute flags (Attribute m n v) = 
  showString "(CGI.attr" .
  (if generateBT flags then (attrvalueBT m v) else id) .
  showChar ' ' .
  shows n . 
  showString " " .
  attrvalue v .
  showString ")"
attribute flags (AttrPattern pat) =
  showString "( " .
  showString pat .
  showString " )"
attribute flags a = error $ "Unknown type: attribute -- " ++ (show a)

attrvalue :: AttrValue -> ShowS
attrvalue (AText t) = 
  shows t
attrvalue (ACode c) =
  showString "( " .
  showString c .
  showString " )"
attrvalue a = error $ "Unknown type: attrvalue -- " ++ (show a)

raw_attrvalue :: AttrValue -> String
raw_attrvalue (AText t) = t
raw_attrvalue (ACode c) = c
raw_attrvalue a = error $ "Unknown type: raw_attrvalue -- " ++ show a

attrvalueBT :: Mode -> AttrValue -> ShowS
attrvalueBT V _ = id
attrvalueBT m (AText _) = showMode m . showChar 'S'
attrvalueBT m (ACode _) = showMode m . showChar 'D'
attrvalueBT m a = error $ "Unknown type: attrvalueBT -- " ++ (show a)

getAttribute :: [Attribute] -> String -> String
getAttribute [] atname = ""
getAttribute (Attribute m n v : rest) atname 
  | n == atname = raw_attrvalue v
  | otherwise   = getAttribute rest atname
getAttribute (_ : rest) atname =
  getAttribute rest atname

removeAttributes :: (String -> Bool) -> [Attribute] -> [Attribute]
removeAttributes p = 
  filter g
  where
    g (Attribute m n v) = not (p n)
    g (AttrPattern _) = True

getTextualContent :: [Content] -> String
getTextualContent = concatMap g
  where
  g (CElement _)  = "" 
  g (CText txt) = textString txt
  g (CCode _) = ""
  g (CComment _) = ""
  g (CReference txt) = textString txt

getTextualContentAsStringExpression :: [Content] -> String
getTextualContentAsStringExpression = 
  wrap . foldrx h z . map g
  where
  foldrx a b [] = b
  foldrx a b xs = foldr1 a xs
  z = "\"\""
  h e1 e2 = e1 ++ " ++ " ++ e2
  g (CElement _)  = z
  g (CText txt) = show (textString txt)
  g (CCode ccode) = getCodeFragsAsStringExpression ccode
  g (CComment _) = z
  g (CReference txt) = show (textString txt)
  wrap s = '(' : s ++ ")"

getCodeFragsAsStringExpression =
  concatMap g
  where
  g (HFrag str) = str
  g (EFrag element) = ""
  g (HSFrag str) = str
  g (CFrag conts) = ""
  g (AFrag attrs) = ""
  g (VFrag str) = str
