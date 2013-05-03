-- © 2001-2005 Peter Thiemann
module WASH.CGI.CGIInternals (module WASH.CGI.CGIInternals, getPathInfo)
{-- interface
  (ask		-- WithHTML x CGI a -> CGI ()
  ,tell		-- CGIOutput a => a -> CGI ()
  ,htell 	-- WithHTML x IO () -> CGI ()
  ,run		-- CGI () -> IO ()
  ,runWithHook 	-- ([String] -> CGI ()) -> CGI () -> IO ()
  )
--}
where

import Prelude hiding (head,div,span)
import qualified Prelude
import Control.Monad
import Data.List as List
import Data.Maybe
import System.IO

import WASH.Utility.Auxiliary
import qualified WASH.Utility.Base64 as Base64
import WASH.CGI.BaseCombinators
import WASH.CGI.CookieIO
import WASH.CGI.CGIMonad
import WASH.CGI.CGIOutput
import WASH.CGI.CGITypes
import WASH.CGI.EventHandlers
import WASH.CGI.Fields
import WASH.CGI.Frames
import WASH.CGI.CGIHistory
import qualified WASH.CGI.HTMLWrapper as H hiding (map)
import WASH.CGI.Images
import WASH.Utility.JavaScript
import qualified WASH.Utility.RFC2279 as RFC2279
import qualified WASH.Utility.RFC2397 as RFC2397
import WASH.CGI.RawCGIInternal hiding (CGIEnv (..), getSessionMode)
import qualified WASH.Utility.URLCoding as URLCoding

import WASH.CGI.CGIConfig

-- ======================================================================
-- internal references

-- |Create a hyperlink to internal entity.
makeRef :: (CGIMonad cgi, Monad m)
	=> String		-- ^internal name of entity
	-> H.WithHTML x m ()	-- ^body of the reference
	-> cgi (H.WithHTML y m ())
makeRef fileName elems =
  wrapCGI (\cgistate ->
  let fileURL = url cgistate ++ '?' : fileName in
  return (hlink (URL fileURL) elems, cgistate))

-- |Create a popup hyperlink to internal entity.
makePopupRef :: (CGIMonad cgi) =>
           String		-- ^name of popup window
	-> String		-- ^internal name of entity
	-> H.HTMLCons x y cgi ()
makePopupRef name fileName elems =
  do baseUrl <- H.lift getUrl
     let fileURL = baseUrl ++ '?' : fileName
     popuplink name (URL fileURL) elems

-- |Create hyperlink to internal entity @\/path?name@.
makeA :: (CGIMonad cgi) => String -> String -> HTMLField cgi x y ()
makeA path name elems =
  do url <- H.lift getUrl
     let querystring = if null name then "" else '?' : name
	 pathstring = if null path then "" else '/' : path
	 fullurl = url ++ pathstring ++ querystring
     hlink (URL fullurl) elems

-- ======================================================================
-- input fields & forms
-- 
data VALID = VALID
data INVALID = INVALID

data InputField a x = 
     InputField { ifName :: String
		, ifToken :: CGIFieldName  
     		, ifFty :: String
		, ifString :: Maybe String
		, ifValue :: Maybe a
		, ifRaw :: CGIParameters
		, ifBound :: Bool	    -- True if form submitted
		}

-- |create a virtual input field from the concatenation of two input fields
concatFields :: (Reason c, Read c)
	     => InputField c INVALID -> InputField Text INVALID
  	     -> InputField c INVALID
concatFields ifa ifb = 
  concatFieldsWith g ifa [ifb]
  where g sa [sb] = sa ++ sb

-- |Create a virtual input field from the result of applying a function to two
-- input fields. Parsing is applied to the result of the function call.
concatFieldsWith :: (Reason c, Read c) 
		 => (String -> [String] -> String)
		 -> InputField c INVALID 
		 -> [InputField Text INVALID]
                 -> InputField c INVALID
concatFieldsWith trans ifa ifbs =
  let newString = do stra <- ifString ifa
		     strbs <- mapM ifString ifbs
		     return (trans stra strbs)
      newValue  = do s <- newString
		     maybeRead s
  in 
  InputField { ifName = ifName ifa	-- ++ '|' : ifName ifb
	     , ifToken = ifToken ifa
	     , ifFty = ifFty ifa
	     , ifString = newString
	     , ifValue = newValue
	     , ifRaw = ifRaw ifa
	     , ifBound = ifBound ifa && all ifBound ifbs
	     }

-- |Combine the values of separately parsed fields
combineFieldsWith2 f2 if1 if2 =
  InputField { ifName = ifName if1	-- ++ '|' : ifName if2
	     , ifToken = ifToken if1
	     , ifFty = ifFty if1
	     , ifString = Nothing
	     , ifValue = liftM2 f2 (ifValue if1) (ifValue if2)
	     , ifRaw = ifRaw if1
	     , ifBound = ifBound if1 && ifBound if2
	     }

-- transition code
name = ifName
string = ifString
valueInputField inf =
  case ifValue inf of
    Nothing -> error ("InputField { " ++
		      "ifName = " ++ show (ifName inf) ++ ", " ++
		      "ifString = " ++ show (ifString inf) ++ ", " ++
		      "ifBound = " ++ show (ifBound inf) ++
		      " }")
    Just vl -> vl
-- raw = ifRaw
-- transition code end

feither :: (a -> b) -> (c -> d) -> Either a c -> Either b d
feither f g (Left a) = Left (f a)
feither f g (Right b) = Right (g b)

-- to expose less of the implementation, the following type could be 
-- propagate :: MonadPlus err => Either (err x) a -> .. Either (err x) (a, b)
propagate :: Either [err] a -> Either [err] b -> Either [err] (a,b)
propagate (Right a) (Right b) = Right (a, b)
propagate (Right a) (Left bss) = Left bss
propagate (Left ass) (Right b) = Left ass
propagate (Left ass) (Left bss) = Left (mplus ass bss)

data ValidationError =
     ValidationError { veName :: String			    -- name of erroneous field
		     , veToken :: CGIFieldName		    -- token of erroneous field
		     , veString :: Maybe String		    -- value of erroneous field
		     }

validateInputField inf =
    case ifValue inf of 
      Nothing | ifBound inf -> 
        Left [ValidationError (ifName inf) (ifToken inf) (ifString inf)]
      _ ->
        Right InputField{ ifName = ifName inf
			, ifToken = ifToken inf
			, ifFty  = ifFty inf
			, ifString = ifString inf
			, ifValue = ifValue inf
			, ifRaw = ifRaw inf
			, ifBound = ifBound inf
			}

-- internal
data InputType = TEXT | PASSWORD | CHECKBOX |
    RADIO | SUBMIT | RESET |
    FILE | HIDDEN | IMAGE | BUTTON
    deriving (Eq)

instance Show InputType where
  show TEXT = "text"
  show PASSWORD = "password"
  show CHECKBOX = "checkbox"
  show RADIO = "radio"
  show SUBMIT = "submit"
  show RESET = "reset"
  show FILE = "file"
  show HIDDEN = "hidden"
  show IMAGE = "image"
  show BUTTON = "button"

textual :: InputType -> Bool
textual TEXT = True
textual PASSWORD = True
textual FILE = True
textual _ = False

-- |Every input widget maps the content generator for the widget (which may
-- produce HTML elements or attributes) to the content generator of the widget. 
type HTMLField cgi x y a = H.WithHTML x cgi () -> H.WithHTML y cgi a

-- |Creates a reset button that clears all fields of a form.
resetField :: (CGIMonad cgi) => HTMLField cgi x y (InputField () INVALID)
resetField = 
  genericField RESET (const (Just ()))

-- |Creates a submit button. Unsafe. Internal use only.
submitField :: (CGIMonad cgi) => cgi () -> HTMLField cgi x y ()
submitField action =
  internalSubmitField False (Right action)

defaultSubmitField :: (CGIMonad cgi) => cgi () -> HTMLField cgi x y ()
defaultSubmitField action =
  internalSubmitField True (Right action)

internalSubmitField isDefault what attrs =
  do sf <- genericField SUBMIT (const (Just ())) attrs
     attachAction (ifName sf) isDefault what

attachAction fname isDefault what =
  do pageInfo <- H.lift getInfo
     let mbnds = bindings pageInfo
	 localAction = 
	   case what of
	     Right action ->
	       let act = resetFrame >> action in
	       do H.lift (setAction (const act))
		  H.lift (registerAction fname (const act))
	     Left sts ->
	       let names = map veName sts
		   values = map (fromMaybe "" . veString) sts
	       in
	       do H.lift (setAction tell)			    -- CHANGE THIS
		  H.lift (registerAction fname tell)
		  H.lift (setFaulty $ zip names values)
{-- 
     lift (unsafe_io (do appendFile "/tmp/CGIMBNDS" ("\nlooking for "++name sf++"\n")
			 appendFile "/tmp/CGIMBNDS" (show mbnds)))
--}
     case mbnds of
       Nothing ->
	 return ()
       Just bnds ->
	 case assocParm fname bnds of
	   Just _ ->
	     localAction
	   Nothing ->
	     case assocParm subVar bnds of
	       Just submitter |
		 submitter == fname || submitter == "" && isDefault 
		 -> localAction
	       _ -> return ()
	 
-- |Creates an input field that submits the field to the browser when data is
-- entered into this field. 
activeInputField :: (CGIMonad cgi, Reason a, Read a)
	=> (a -> cgi ())	-- ^Function that maps input data to a CGI action.
	-> HTMLField cgi x y ()
activeInputField actionFun attrs =
  activateI actionFun inputField attrs

-- |Attach a CGI action to the value returned by the input field. Activation
-- means that data is submitted as soon as it is entered.
activateI :: (CGIMonad cgi) =>
  (a -> cgi ()) -> HTMLField cgi x y (InputField a INVALID) -> HTMLField cgi x y ()
activateI actionFun inputField attrs =
  do js_enabled <- H.lift getJSEnabled
     let use_js = maybe True id js_enabled
     invalid_inf <- inputField (do attrs
				   when use_js $ onChange $ "WASHSubmit(this.name);")
     let r = validateInputField invalid_inf
	 rv = either Left (Right . valueInputField) r
     when (ifBound invalid_inf) $
       activateInternal actionFun (ifName invalid_inf) rv

activateInternal actionFun name what =
  case what of
    Right val -> 
      let act = resetFrame >> actionFun val in
      do H.lift (setAction (const act))
	 H.lift (registerAction name (const act))
    Left sts ->
      let names = map veName sts
	  values = map (fromMaybe "" . veString) sts
      in
      do H.lift (setAction tell)			    -- CHANGE THIS
	 H.lift (setFaulty $ zip names values)
	 H.lift (registerAction name tell)

-- |Create a textual input field. Return type can be *anything* in class 'Reason'
-- and 'Read'.
inputField :: (CGIMonad cgi, Reason a, Read a) => HTMLField cgi x y (InputField a INVALID)
inputField = 
  genericField TEXT (maybeRead . fromMaybe "")

maybeRead :: Read a => String -> Maybe a
maybeRead s = g (reads s)
  where g ((a,""):_) = Just a
	g _ = Nothing

-- |Create a textual input field that returns the string entered. (Avoids having
-- to put quotes around a string.)
textInputField :: (CGIMonad cgi) => HTMLField cgi x y (InputField String INVALID)
textInputField =
  genericField TEXT id

-- |Creates a textual input field that takes a custom validation function.
checkedTextInputField :: (CGIMonad cgi) => (Maybe String -> Maybe String)
			 -> HTMLField cgi x y (InputField String INVALID)
checkedTextInputField g attrs =
  genericField TEXT g attrs

-- |Like 'inputField' but the characters are not echoed on the screen.
passwordInputField :: (CGIMonad cgi, Reason a, Read a) => HTMLField cgi x y (InputField a INVALID)
passwordInputField =
  genericField PASSWORD (maybeRead . fromMaybe "")

-- |Creates a checkbox. Returns 'True' if box was checked.
checkboxInputField :: (CGIMonad cgi) => HTMLField cgi x y (InputField Bool INVALID)
checkboxInputField =
  genericField CHECKBOX g
  where g Nothing = Just False
	g (Just _) = Just True

-- |Creates a file input field. Returns a temporary 'FileReference'. The
-- 'fileReferenceName' of the result is *not* guaranteed to be persistent. The
-- application is responsible for filing it away at a safe place.
fileInputField :: (CGIMonad cgi) => HTMLField cgi x y (InputField FileReference INVALID)
fileInputField attrs =
  H.lift (setEnctype "multipart/form-data") >>
  genericField FILE (maybeRead . fromMaybe "") attrs

-- |Creates a file input field. Like 'fileInputField' but has an additional
-- parameter for additional validation of the input.
checkedFileInputField :: (CGIMonad cgi) => (Maybe FileReference -> Maybe FileReference) 
			  -> HTMLField cgi x y (InputField FileReference INVALID)
checkedFileInputField filter attrs =
  H.lift (setEnctype "multipart/form-data") >>
  genericField FILE (filter . maybeRead . fromMaybe "") attrs

instance Reason FileReference where
  reason _ = "FileReference"

genericField :: (Reason a, CGIMonad cgi) => InputType -> (Maybe String -> Maybe a) -> HTMLField cgi x y (InputField a INVALID)
genericField inputType decode fieldAttrs =
  let isSUBMIT = inputType == SUBMIT 
      isFILE   = inputType == FILE
  in
  do fieldName'' <- H.lift nextName
     let fieldName' = show fieldName''
	 fieldName | isSUBMIT = 's' : tail fieldName' 
	 	   | otherwise = fieldName'
	 fieldType = show inputType
	 isTextual = textual inputType
     info <- H.lift getInfo
     js_enabled <- H.lift getJSEnabled
     let use_js = maybe True id js_enabled
     (explanation, result) <-
       H.input_T
	     (do H.attr_SS "type" fieldType
		 H.attr_SD "name" fieldName
		 fieldAttrs
		 -- unless isTextual $ H.attr_SD "name" fieldName
		 when (use_js && isSUBMIT) $
		   onClick ("this.form."++subVar++".value=this.name; return true")
		 attrs <- H.get_attrs
		 let [nameAttr] = [ H.attr_value a 
				  | a <- attrs, H.attr_name a == "name" 
				  ]
		     bds = bindings info
		     maybestring = bds >>= assocParm nameAttr
		     rawvalues = maybeToList bds >>= assocParmR nameAttr
		     mdecoded = decode maybestring
		     decoded = fromJust mdecoded
		     isBound = isJust bds
		     theReason = reason decoded
		     advice = "Enter " ++ prependArticle theReason
		     explanation = theReason ++ " expected"
		 -- H.attr_SD "washtype" (washtype decoded)
		 when (use_js && isTextual) $ do
		   onMouseOver ("self.status=" ++ jsShow advice ++ "; return true")
		   onMouseOut  ("self.status=''; return true")
		 unless (isFILE || isSUBMIT) $ case maybestring of 
	           Nothing -> H.empty
		   Just str -> H.attr_SD "value" str
		 H.attr_SS "title" explanation
		 return (explanation,
		   InputField { ifName = nameAttr
			      , ifToken = fieldName''
     		  	      , ifFty = fieldType
			      , ifString = maybestring
			      , ifValue = mdecoded
			      , ifRaw = rawvalues
			      , ifBound = isBound
			      }))
     H.lift $ addField (ifName result) isTextual
--     {- obsoleted by working css stuff -}
--     when isTextual $ do
--       nothingI <- internalImage nothing explanation
--       makeImg nothingI 
--         (do H.attr_SS "align" "center"
--	     H.attr_SD "name" ('i' : ifName result))
     return result

-- |generates a hyperlink that submits the current form.
internalSubmitLink :: (CGIMonad cgi) =>
  Bool -> Either [ValidationError] (cgi ()) -> H.HTMLCons x y cgi ()
internalSubmitLink isDefault what subs =
  do fieldToken <- H.lift nextName
     let fieldName = show fieldToken
	 atv = "javascript:" ++ "WASHSubmit('"++fieldName++"'); void 0;"
     H.a_T (H.attr_SS "href" atv >> subs)
     attachAction fieldName isDefault what

-- |Create an input field from an image. Returns (x,y)
-- position clicked in the image.
imageField :: (CGIMonad cgi) => Image -> HTMLField cgi x y (InputField (Int, Int) INVALID)
imageField image fieldAttrs =
  do fieldToken <- H.lift nextName
     let fieldName = show fieldToken
     H.input_T (do H.attr_SS "type" "image"
		   H.attr_SD "name" fieldName
		   H.attr_SD "src" (unURL $ imageSRC image)
		   fieldAttrs)
     H.lift $ addField fieldName False
     info <- H.lift getInfo
     return $
       let maybe_xy = 
	    do bds <- bindings info
	       x <- assocParm (fieldName ++ ".x") bds
	       y <- assocParm (fieldName ++ ".y") bds
	       return (x, y)
       in
       InputField { ifName = fieldName
		  , ifToken = fieldToken
       		  , ifFty = "image"
		  , ifString = do (x, y) <- maybe_xy
				  return ("(" ++ x ++ "," ++ y ++ ")")
		  , ifValue  = do (x, y) <- maybe_xy
				  return (read x, read y)
     		  , ifRaw = []
		  , ifBound = isJust (bindings info)
		  }

-- a virtual field that never appears on the screen
data RadioGroup a x =
     RadioGroup { radioName   :: String
		, radioToken  :: CGIFieldName
                , radioString :: Maybe String
		, radioValue  :: Maybe a
		, radioBound  :: Bool
		}

validateRadioGroup rg =
  case radioValue rg of 
    Nothing | radioBound rg -> 
      Left [ValidationError (radioName rg) (radioToken rg) (radioString rg)]
    _ ->
      Right RadioGroup  { radioName = radioName rg
			, radioToken = radioToken rg
			, radioString = radioString rg
			, radioValue = radioValue rg
			, radioBound = radioBound rg
			}

valueRadioGroup rg =
  case radioValue rg of
    Nothing -> error ("RadioGroup { " ++
		      "radioName = " ++ show (radioName rg) ++ ", " ++
		      "radioString = " ++ show (radioString rg) ++ ", " ++
		      "radioBound = " ++ show (radioBound rg) ++
		      " }")
    Just vl -> vl

-- |Create a handle for a new radio group. /This handle is invisible on the screen!/
radioGroup :: (CGIMonad cgi, Read a) => H.WithHTML x cgi (RadioGroup a INVALID)
radioGroup =
  do token <- H.lift nextName
     let fieldName = show token
     info <- H.lift getInfo
     H.lift $ addField fieldName False
     let bds = bindings info
	 maybeString = bds >>= assocParm fieldName
	 maybeVal = maybeString >>= (g . reads . URLCoding.decode)
	 g ((a,""):_) = Just a
	 g _ = Nothing
     return $
       RadioGroup { radioName = fieldName
		  , radioToken = token
		  , radioString = maybeString
		  , radioValue = maybeVal
		  , radioBound = isJust bds
		  }

-- |Create a new radio button and attach it to an existing 'RadioGroup'.
radioButton :: (Show a, Monad cgi) => RadioGroup a INVALID -> a -> HTMLField cgi x y ()
radioButton rg val fieldAttrs =
  H.input_T (do H.attr_SS "type" "radio"
		H.attr_SD "name" (radioName rg)
		H.attr_SD "value" (URLCoding.encode (show val)) 
		fieldAttrs)

-- |Create and place the error indicator for an existing 'RadioGroup'. Becomes
-- visible only if no button of a radio group is pressed.
radioError :: (CGIMonad cgi) => RadioGroup a INVALID -> H.WithHTML x cgi ()
radioError rg = 
  let name = radioName rg in
  do im <- internalImage nothing "Select exactly one button"
     makeImg im (H.attr "align" "center" >> H.attr "name" ('i' : name))

-- buttons

-- |Create a single button.
makeButton :: (CGIMonad cgi) => HTMLField cgi x y (InputField Bool INVALID)
makeButton fieldAttrs =
  let fieldType = "button" in
  do fieldToken <- H.lift nextName
     let fieldName = show fieldToken
     H.input_T (do H.attr_SS "type" fieldType
		   H.attr_SD "name" fieldName 
		   fieldAttrs)
     H.lift $ addField fieldName False
     info <- H.lift getInfo
     let bds = bindings info
	 maybeString = bds >>= assocParm fieldName
	 maybeVal = 
	   case bds of
	     Nothing -> Nothing
	     Just parms ->
	       case maybeString of
	         Nothing -> Just False
		 Just _  -> Just True
     return $
       InputField { ifName = fieldName
		  , ifToken = fieldToken
     		  , ifFty = fieldType
		  , ifString = maybeString
		  , ifValue = maybeVal
		  , ifRaw = []
		  , ifBound = isJust bds
		  }

-- form
-- multiple arguments formed according to CGI 1.1 rev 3 spec
-- http://cgi-spec.golux.com/draft-coar-cgi-v11-03-clean.html#5.0

constructQuery url [] =
  url
constructQuery url args =
  url ++ '?' : concat (List.intersperse "+" (map URLCoding.encode args))

-- |Wraps an HTML form around its arguments. All standard attributes are
-- computed and need not be supplied explicitly.
makeForm :: (CGIMonad cgi) => H.WithHTML x cgi a -> H.WithHTML y cgi ()
makeForm attrs_elems = 
  makeFormWithErrorMark
    -- ["style.backgroundColor='red'", "style.borderColor='black'"]
    ["className='faultyinput'"]
    attrs_elems

makeFormWithErrorMark errorMarks attrs_elems = do
  url <- H.lift getUrl
  args <- H.lift getCGIArgs
  js_enabled <- H.lift getJSEnabled
  let use_js = maybe True id js_enabled
  when use_js $ H.script_S 
    (do H.attr_SS "type" "text/javascript"
	H.comment $
	      "\n" ++
	      "var SubmitAction=[];" ++ 
	      "function OnSubmit(){" ++
	      "var r=true;" ++
	      "for(var i=0;i<SubmitAction.length;i++){r=r&&SubmitAction[i]();};" ++ 
	      "return r;};"++
	      "function WASHSubmit(fn){" ++
	      "var ff = document.forms[0];" ++
	      "ff."++subVar++".value=fn;" ++
	      "ff.submit();" ++
	      "}" ++
	      "\n// "
	     )
  jsprog <- H.form_T $
    do H.attr_SD "action" (constructQuery url args)
       H.attr_SS "method" "post"
       when use_js $ onSubmit ("return OnSubmit();")
       attrs_elems
       H.attr_SS "target" "_self"		    -- ensure target attr is present
       -- formname <- liftM show $ H.lift nextName
       info <- H.lift getInfo
       parm <- H.lift getParm
       stid <- H.lift getStateID
       sessionMode <- H.lift getSessionMode
       encoder <- H.lift getEncoder
       fields <- H.lift getFields
       let ff = faultyfields info
	   realparm | null ff   = parm
                  | otherwise = tail parm
	   enabledString =
	     case js_enabled of
	       Just True -> "True"
	       _ -> "False"
       H.input_S
	 (do H.attr_SS "type" "hidden"
	     H.attr_SS "name" "js_enabled"
	     H.attr_SS "value" enabledString)
       H.input_S
	 (do H.attr_SS "type" "hidden"
	     H.attr_SS "name" subVar
	     H.attr_SS "value" "")
       when (sessionNeedsLog sessionMode) $
	 H.input_S 
	 (do H.attr_SS "type" "hidden"
	     H.attr_SS "name" "=CGI=parm="
	     H.attr_SD "value"
	       (Base64.encode' $ encoder $ RFC2279.encode $ show $ realparm))
       when (sessionNeedsState sessionMode) $
	 H.input_S 
	 (do H.attr_SS "type" "hidden"
	     H.attr_SS "name" "=CGI=stid="
	     H.attr_SD "value" (Base64.encode' stid))
       let 
	   checkForJS =
	     case js_enabled of
	       Nothing ->
		 "document.forms[0].js_enabled.value='True';"
	       _ -> ""
           iFields = [iname | (iname@('f':_), True) <- fields]
	   questionURL = url ++ '?' : ffName question
	   hilight =
	    case iFields of
	     [] -> []
	     name':_ ->  ["document.forms[0]." ++ name' ++ ".focus();"
	 		 ,"document.forms[0]." ++ name' ++ ".select();"]
	   markAsFaulty (fname, fvalue) | fname `elem` iFields =
	     "if(document.i" ++ fname ++ ")" ++
	     "document.i" ++ fname ++ ".src = " ++ jsShow questionURL ++ ";" ++
	     "else{" ++
	     (let f mark = "document.forms[0]." ++ fname ++ "." ++ mark ++ ";" in
	     List.concatMap f errorMarks) ++
	     "}"
	    | otherwise =
	     "popupstr += " 
	     ++ jsShow ("In a previous form, the field " ++ fname ++ 
			" had an unparsable input value: " ++ fvalue ++ "\n")
	     ++ ";"
	   jsprog | null ff = hilight
		| otherwise =
	    "popupstr = '';"
	    : map markAsFaulty ff
	    ++ "if (popupstr != '') alert(popupstr + 'Please go back and reenter!');"
	    : hilight
       when (not (null ff)) $ H.comment_T ("Faultyfields: " ++ show ff)
       -- H.attr_SD "name" formname
       H.attr_SD "enctype" (enctype info)
       return (checkForJS : jsprog)
  when (use_js && not (null jsprog)) $
      H.script_T
	 (do H.attr_SS "type" "text/javascript"
	     H.rawtext_S "<!-- "
	     H.rawtext ('\n' : unlines jsprog)
	     H.rawtext_S "// -->")

-- textarea

-- |Create a text area with a preset string.
makeTextarea :: (CGIMonad cgi) => String -> HTMLField cgi x y (InputField String INVALID)
makeTextarea fieldValue fieldAttrs =
  do token <- H.lift nextName
     info <- H.lift getInfo
     let bds = bindings info
	 mvalue = bds >>= assocParm name
	 name = show token
	 displayValue = fromMaybe fieldValue mvalue
     H.textarea_T (do H.attr_SD "name" name
		      H.text_S displayValue
		      fieldAttrs)
     return $
       InputField { ifName = name
		  , ifToken = token
       		  , ifFty = "textarea"
		  , ifString = mvalue
		  , ifValue = mvalue
		  , ifRaw = maybeToList bds >>= assocParmR name
		  , ifBound = isJust bds
		  }

-- select

selectTags = map (('o':) . show) [(1::Int)..] 

-- |Create a selection box where multiple entries can be selected.
selectMultiple :: (CGIMonad cgi, Eq a)
	=> (a -> String)	-- ^function to display values of type a
	-> [a]			-- ^list of preselected entries
	-> [a]			-- ^list of all possible entries
	-> (Int, Int)		-- ^(min, max) number of fields that must be selected 
	-> HTMLField cgi x y (InputField [a] INVALID)
selectMultiple shw defs opts (minSel, maxSel) attrs =
  do token <- H.lift nextName
     let name = show token
     info <- H.lift getInfo
     let bds = bindings info
	 rawvalues = maybeToList bds >>= assocParmR name
	 g ('o':i:rest) = i /= '0' 
	 g _ = False
	 inputs = filter g $ map fieldContents rawvalues
	 values = inputs >>=
		  (maybeToList . flip List.elemIndex selectTags) >>=
		  (\i -> [opts !! i])
	 len = length inputs
	 mvalue | minSel <= len && len <= maxSel = Just values
	        | otherwise = Nothing
	 revisedDefaults | isJust bds && not (null inputs) = values
	 		 | otherwise = defs
     let makeoption (opt, tag) = 
	   H.option_T (do H.text (shw opt)
			  H.attr_SD "value" tag
			  when (opt `elem` revisedDefaults) $
			       H.attr_SS "selected" "selected")
	 makeChoice :: Int -> String
	 makeChoice n | n == 0 = "no choice"
                   | n == 1 = "1 choice"
		   | n == maxBound = "arbitrary many choices"
		   | otherwise = show n ++ " choices"
	 makeRange :: Int -> Int -> String
	 makeRange lo hi | lo == maxBound = "Arbitrary many choices"
                      | lo == hi = "Exactly " ++ makeChoice lo
                      | otherwise = "Minimum " ++ makeChoice lo ++
		      		    "; maximum " ++ makeChoice hi
     H.select_T
       (do attrs
	   H.attr_SD "name" name
	   when (maxSel > 1) $
		H.attr_SS "multiple" "multiple"
	   when (null defs && minSel > 0) $
		H.option_S (do H.text_S "--"
			       H.attr_SS "value" "o0")
	   mapM_ makeoption (zip opts selectTags))
     im <- internalImage nothing (makeRange minSel maxSel)
     makeImg im (do H.attr_SS "align" "center"
		    H.attr_SD "name" ('i' : name))
     return $ 
       InputField { ifName = name
		  , ifToken = token
       		  , ifFty = "select"
		  , ifString = Nothing -- fmap show value
		  , ifValue = mvalue
		  , ifRaw = rawvalues
		  , ifBound = isJust bds
		  }

-- |Create a selection box where exactly one entry can be selected.
selectSingle :: (CGIMonad cgi, Eq a)
	=> (a -> String)	-- ^function to display values of type a
	-> Maybe a		-- ^optional preselected value
	-> [a]			-- ^list of all possible values
	-> HTMLField cgi x y (InputField a INVALID)
selectSingle shw mdef opts attrs =
  do inf <- selectMultiple shw (maybeToList mdef) opts (1,1) attrs
     return $
       InputField { ifName = ifName inf
		  , ifToken = ifToken inf
       		  , ifFty = "select"
		  , ifString = ifString inf
		  , ifValue = fmap Prelude.head (ifValue inf)
		  , ifRaw = ifRaw inf
		  , ifBound = ifBound inf
		  }

-- |Selection box for elements of a "Bounded" type. Argument is the optional
-- preselected value.
selectBounded :: (CGIMonad cgi, Enum a, Bounded a, Read a, Show a, Eq a) =>
		 Maybe a -> HTMLField cgi x y (InputField a INVALID)
selectBounded def =
  selectSingle show def [minBound..maxBound]
     
-- ======================================================================
-- attributes

-- |Create a 'SIZE' attribute from an 'Int'.
fieldSIZE :: Monad m => Int -> H.WithHTML x m ()
fieldSIZE i = H.attr_SD "size" (show i)

-- |Create a 'MAXLENGTH' attribute from an 'Int'.
fieldMAXLENGTH :: Monad m => Int -> H.WithHTML x m ()
fieldMAXLENGTH i = H.attr_SD "maxlength" (show i)

-- |Create a 'VALUE' attribute from any 'Show'able.
fieldVALUE :: (Monad m, Show a) => a -> H.WithHTML x m ()
fieldVALUE a = H.attr_SD "value" (show a)


-- Images

data Image =
  Image { imageSRC :: URL
  	, imageALT :: String
	}

-- |Reference to internal image.
internalImage :: (CGIMonad cgi) =>
	   FreeForm		-- ^the raw image
	-> String		-- ^alternative text
	-> H.WithHTML x cgi Image
internalImage ff alttext =
  do baseUrl <- H.lift getUrl
     externalImage (URL (baseUrl ++ '?' : ffName ff)) alttext

-- |Reference to internal image via data URL (small images, only).
dataImage :: (CGIMonad cgi) =>
	   FreeForm		-- ^the raw image
	-> String		-- ^alternative text
	-> H.WithHTML x cgi Image
dataImage ff alttext =
  let url = URL (RFC2397.encode (ffContentType ff, ffRawContents ff)) in
  externalImage url alttext

-- |Reference to internal image via javascript URL (does not seem to work).
jsImage :: (CGIMonad cgi) =>
	   FreeForm		-- ^the raw image
	-> String		-- ^alternative text
	-> H.WithHTML x cgi Image
jsImage ff alttext =
  let url = URL ("javascript:" ++ jsShow (ffRawContents ff)) in
  externalImage url alttext

-- |Reference to image by URL.
externalImage :: (CGIMonad cgi) =>
	   URL			-- ^URL of image
	-> String		-- ^alternative text
	-> H.WithHTML x cgi Image
externalImage url alttext =
     return $ Image { imageSRC = url
     		    , imageALT = alttext
		    }

-- |Create an inline image.
makeImg :: (Monad cgi) => Image -> HTMLField cgi x y ()
makeImg image attrs = 
     H.img_T (do H.attr_SD "src" (unURL $ imageSRC image)
		 H.attr_SD "alt" (imageALT image)
		 H.attr_SD "title" (imageALT image)
		 attrs)


-- |Hyperlink that creates a named popup window from an URL string.
popuplink :: Monad m => String -> URL -> H.HTMLCons x y m ()
popuplink name url subs = 
  let atv = "javascript:window.open(" ++
            jsShow (unURL url) ++ "," ++
	    jsShow name ++
	    "); void(0);" in
  H.a_T (H.attr_SD "href" atv >> subs)

-- |restart application.
restart :: (CGIMonad cgi) => cgi ()
restart = 
  do myurl <- getUrl
     tell (Location $ URL myurl)

-- |Convenient workhorse. Takes the title of a page and a monadic HTML value for
-- the contents of the page. Wraps the contents in a form so that input fields
-- and buttons may be used inside.
standardQuery :: (CGIMonad cgi) => String -> H.WithHTML x cgi a -> cgi ()
standardQuery ttl elems =
  ask (H.standardPage ttl (makeForm elems))

-- 
debug message = unsafe_io $
  do putStrLn "content-type: text/plain"
     putStrLn ""
     putStrLn message
     putStrLn "------------------------------------------------------------"
-- 
prependArticle "" = ""
prependArticle xs@(x:_) =
  if x `elem` "aeiouAEIOU" then "an " ++ xs else "a " ++ xs

