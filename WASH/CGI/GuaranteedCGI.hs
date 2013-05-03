module WASH.CGI.GuaranteedCGI (
	-- * Basics
	CGI, CGIMonad
	, ask, tell, io, run
	, once, forever, callWithCurrentHistory, htell, askOffline
	-- * Links and Images
	, Image, internalImage, externalImage, makeImg, makeRef, makePopupRef, makeA
	, backLink, hlink, popuplink, restart
	-- * Page Templates
	, standardPage, htmlHeader, WASH.CGI.GuaranteedCGI.html, cssPage, cssHeader
	-- * Forms and Widgets
	, HTMLField
	-- ** Form Creation
	, makeForm, standardQuery
	-- ** Form Submission
	, submit, submit0, defaultSubmit, resetField, activeInputField, activate
	, submitLink, submitLink0, defaultSubmitLink
        , submitx, DTree, dtleaf, dtnode
	-- ** Textual Input 
	, inputField, textInputField, checkedTextInputField, passwordInputField, makeTextarea
	-- ** Checkbox
	, checkboxInputField
	-- ** Button
	, makeButton, RadioGroup, radioGroup, radioButton, radioError
	-- ** Image
	, imageField
	-- ** Selection Box
	, selectMultiple, selectSingle, selectBounded
	-- ** File
	, fileInputField, checkedFileInputField
	-- ** Handle Manipulation
	, InputField, VALID, INVALID, value, InputHandle, HasValue
	, F0 (F0), F1 (F1), F2 (F2), F3 (F3), F4 (F4), F5 (F5), F6 (F6), F8 (F8)
	, FL (FL), FA (FA)
	-- ** Attribute Shortcuts
	, fieldSIZE, fieldMAXLENGTH, fieldVALUE
	-- * Advanced
	-- ** Installing Translators
	, runWithHook, docTranslator, lastTranslator
	-- ** Outputable Stuff
	, CGIOutput, Status(..), Location(..), FreeForm(..), FileReference (..)
	-- ** Predefined Types for Input Fields
	, Text(..), NonEmpty(..), AllDigits(..), Phone(..)
	, EmailAddress(..), CreditCardNumber(..), CreditCardExp(..)
	, Password(..), Optional(..)
	-- ** Lowlevel Options
	, CGIOption (..), CGIOptions, URL (..)
	-- ** Servlets
	, makeServlet, makeServletWithHook
	-- * HTML and Style
	, module WASH.HTML.HTMLMonad98
	, module WASH.CGI.Style
	-- * Experimental Stuff
	, FrameSet, FrameLayout(..), FrameSpacing(..), makeFrame, makeFrameset, framesetPage
	) where

import WASH.CGI.CGIMonad (CGIMonad())
import WASH.CGI.CGITypes
import WASH.CGI.Fields
import WASH.CGI.Style
import qualified WASH.CGI.CGIInternals as CGIInternals
import WASH.CGI.CGI (
  	CGI
	, tell, io, run, once, forever, callWithCurrentHistory
	, Image, internalImage, externalImage
	, HTMLField, RadioGroup, radioGroup, InputField, VALID, INVALID, value
	, InputHandle, HasValue
	, F0 (F0), F1 (F1), F2 (F2), F3 (F3), F4 (F4), F5 (F5), F6 (F6), F8 (F8)
	, FL (FL), FA (FA)
	, DTree, dtleaf, dtnode
	, runWithHook, docTranslator, lastTranslator
	, CGIOutput, Status(..), Location(..), FreeForm(..), FileReference (..)
	, Text(..), NonEmpty(..), AllDigits(..)
	, EmailAddress(..), CreditCardNumber(..), CreditCardExp(..)
	, CGIOption(..), CGIOptions
	, makeServlet, makeServletWithHook
	, FrameSet, FrameLayout(..), FrameSpacing(..)
	, makeFrameset, framesetPage
	, Style(..)
	)

import WASH.HTML.HTMLMonad98 hiding (html)
import qualified WASH.CGI.CGI as CGI

ask :: (CGIMonad cgi) => WithHTML DOCUMENT cgi a -> cgi ()
ask = CGI.ask
htell :: (CGIMonad cgi) => WithHTML HTML IO () -> cgi a
htell = CGI.htell
askOffline :: (CGIMonad cgi) => WithHTML HTML cgi a -> (Element -> IO ()) -> cgi ()
askOffline = CGI.askOffline
makeImg :: (Monad cgi, AdmitChildIMG y) => Image -> HTMLField cgi IMG y ()
makeImg = CGI.makeImg
makeRef :: (CGIMonad cgi, AdmitChildA y, Monad m) => String -> WithHTML A m () -> cgi (WithHTML y m ())
makeRef = CGI.makeRef
makeA :: (CGIMonad cgi, AdmitChildA y) => String -> String -> HTMLField cgi A y ()
makeA = CGI.makeA
makePopupRef :: (CGIMonad cgi, AdmitChildA y) => String -> String -> HTMLField cgi A y ()
makePopupRef = CGI.makePopupRef
backLink :: (AdmitChildA x, Monad m) => HTMLCons A x m ()
backLink = CGI.backLink
hlink :: (AdmitChildA y, Monad m) => URL -> HTMLCons A y m ()
hlink = CGI.hlink
popuplink :: (AdmitChildA y, Monad m) => String -> URL -> HTMLCons A y m ()
popuplink = CGI.popuplink
restart :: CGI ()
restart = CGI.restart
makeForm :: (AdmitChildFORM y) => WithHTML FORM CGI a -> WithHTML y CGI ()
makeForm = CGI.makeForm
standardQuery :: String -> WithHTML FORM CGI a -> CGI ()
standardQuery = CGI.standardQuery
submit :: (CGIMonad cgi, AdmitChildINPUT y, InputHandle h) => h INVALID -> (h VALID -> cgi ()) -> HTMLField cgi INPUT y ()
submit = CGI.submit
submit0 :: (CGIMonad cgi, AdmitChildINPUT y) => cgi () -> HTMLField cgi INPUT y ()
submit0 = CGI.submit0
defaultSubmit :: (CGIMonad cgi, AdmitChildINPUT y, InputHandle h) => h INVALID -> (h VALID -> cgi ()) -> HTMLField cgi INPUT y ()
defaultSubmit = CGI.defaultSubmit
submitLink :: (CGIMonad cgi, AdmitChildA y, InputHandle h) => h INVALID -> (h VALID -> cgi ()) -> HTMLCons A y cgi ()
submitLink = CGI.submitLink
submitLink0 :: (AdmitChildA y) => CGI () -> HTMLCons A y CGI ()
submitLink0 = CGI.submitLink0
defaultSubmitLink :: (AdmitChildA y, InputHandle h) => h INVALID -> (h VALID -> CGI ()) -> HTMLCons A y CGI ()
defaultSubmitLink = CGI.defaultSubmitLink
submitx :: (AdmitChildINPUT y) => DTree cgi INPUT y -> HTMLField cgi INPUT y ()
submitx = CGI.submitx
resetField :: (CGIMonad cgi, AdmitChildINPUT y) => HTMLField cgi INPUT y (InputField () INVALID)
resetField = CGI.resetField
activeInputField :: (CGIMonad cgi, AdmitChildINPUT y, Reason a, Read a) => (a -> cgi ()) -> HTMLField cgi INPUT y ()
activeInputField = CGI.activeInputField
activate :: (CGIMonad cgi, InputHandle (i a), HasValue i, AdmitChildINPUT y) => (a -> cgi ()) -> HTMLField cgi INPUT y (i a INVALID) -> HTMLField cgi INPUT y (i a INVALID)
activate = CGI.activate
inputField :: (CGIMonad cgi, AdmitChildINPUT y, Reason a, Read a) => HTMLField cgi INPUT y (InputField a INVALID)
inputField = CGI.inputField
checkedTextInputField :: (CGIMonad cgi, AdmitChildINPUT y) => (Maybe String -> Maybe String) -> HTMLField cgi INPUT y (InputField String INVALID)
checkedTextInputField = CGI.checkedTextInputField
textInputField :: (CGIMonad cgi, AdmitChildINPUT y) => HTMLField cgi INPUT y (InputField String INVALID)
textInputField = CGI.textInputField
passwordInputField :: (CGIMonad cgi, AdmitChildINPUT y, Reason a, Read a) => HTMLField cgi INPUT y (InputField a INVALID)
passwordInputField = CGI.passwordInputField
makeTextarea :: (CGIMonad cgi, AdmitChildTEXTAREA y) => String -> HTMLField cgi TEXTAREA y (InputField String INVALID)
makeTextarea = CGI.makeTextarea
checkboxInputField :: (CGIMonad cgi, AdmitChildINPUT y) => HTMLField cgi INPUT y (InputField Bool INVALID)
checkboxInputField = CGI.checkboxInputField
makeButton :: (CGIMonad cgi, AdmitChildINPUT y) => HTMLField cgi INPUT y (InputField Bool INVALID)
makeButton = CGI.makeButton
radioButton :: (CGIMonad cgi, AdmitChildINPUT y, Show a) => RadioGroup a INVALID -> a -> HTMLField cgi INPUT y ()
radioButton = CGI.radioButton
radioError :: (CGIMonad cgi, AdmitChildIMG x) => RadioGroup a INVALID -> WithHTML x cgi ()
radioError = CGI.radioError
imageField :: (CGIMonad cgi, AdmitChildINPUT y) => Image -> HTMLField cgi INPUT y (InputField (Int, Int) INVALID)
imageField = CGI.imageField
selectMultiple :: (CGIMonad cgi, AdmitChildSELECT y, Eq a) => (a -> String) -> [a] -> [a] -> (Int, Int) -> HTMLField cgi SELECT y (InputField [a] INVALID)
selectMultiple = CGI.selectMultiple
selectSingle :: (CGIMonad cgi, AdmitChildSELECT y, Eq a) => (a -> String) -> Maybe a -> [a] -> HTMLField cgi SELECT y (InputField a INVALID)
selectSingle = CGI.selectSingle
selectBounded :: (CGIMonad cgi, AdmitChildSELECT y, Enum a, Bounded a, Read a, Show a, Eq a) => Maybe a -> HTMLField cgi SELECT y (InputField a INVALID)
selectBounded = CGI.selectBounded
checkedFileInputField :: (CGIMonad cgi, AdmitChildINPUT y) => (Maybe FileReference -> Maybe FileReference) -> HTMLField cgi INPUT y (InputField FileReference INVALID)
checkedFileInputField = CGI.checkedFileInputField
fileInputField :: (CGIMonad cgi, AdmitChildINPUT y) => HTMLField cgi INPUT y (InputField FileReference INVALID)
fileInputField = CGI.fileInputField

fieldSIZE :: (Monad m, AdmitAttrSIZE e, AttrValueSIZE v) => v -> WithHTML e m ()
fieldSIZE = WASH.HTML.HTMLMonad98.atSIZE
fieldMAXLENGTH :: (Monad m, AdmitAttrMAXLENGTH e, AttrValueMAXLENGTH v) => v -> WithHTML e m ()
fieldMAXLENGTH = WASH.HTML.HTMLMonad98.atMAXLENGTH
fieldVALUE :: (Monad m, AdmitAttrVALUE e, AttrValueVALUE v) => v -> WithHTML e m ()
fieldVALUE = WASH.HTML.HTMLMonad98.atVALUE

-- module HTMLWrapper
standardPage :: (AdmitChildHTML y, Monad m) => String -> WithHTML BODY m a -> WithHTML y m ()
standardPage = CGI.standardPage
htmlHeader :: (AdmitChildHTML y, Monad m) => String -> WithHTML HTML m a -> WithHTML y m ()
htmlHeader = CGI.htmlHeader
html :: (Monad m, AdmitChildHTML y) => WithHTML HTML m a -> WithHTML y m ()
html = CGI.html
cssHeader :: (AdmitChildHTML y, Monad m) => String -> String -> WithHTML HTML m a -> WithHTML y m ()
cssHeader = CGI.cssHeader
cssPage :: (AdmitChildHTML y, Monad m) => String -> String -> WithHTML BODY m a -> WithHTML y m ()
cssPage = CGI.cssPage

-- module Style
using :: (AdmitAttrSTYLE x, Monad m)
	=> Style
	-> (WithHTML x m b -> c)	-- ^a field constructor, typically 'HTMLField'
	-> WithHTML x m b -> c		-- ^styled version of this constructor
using = CGI.using

makeFrame :: WithHTML FRAME IO () -> CGI () -> CGI FrameSet
makeFrame = CGI.makeFrame
