-- © 2001-2003 Peter Thiemann
{-|
  One stop shop for the WASH\/CGI library. All high-level scripts should 
  get along with importing just this module. Low-level scripts may have to 
  import "RawCGI".
  -} 
module WASH.CGI.CGI (
	-- * Basics
	CGI, CGIMonad
	, ask, tell, io, run, runWithOptions
	, once, forever, callWithCurrentHistory, htell, askOffline
	-- * Links and Images
	, Image, internalImage, externalImage, makeImg, makeRef, makePopupRef, makeA
	, backLink, hlink, popuplink, restart
	-- * Page Templates
	, H.standardPage, H.htmlHeader, H.html, H.cssPage, H.cssHeader
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
	-- ** Abstract Selection
	, as_rows, as_cols, table_io, getText, unAR
	, selectionGroup, selectionButton, selectionDisplay
	, choiceGroup, choiceButton, choiceDisplay
	-- ** Handle Manipulation
	, InputField, VALID, INVALID, value, InputHandle, HasValue
	, F0 (F0), F1 (F1), F2 (F2), F3 (F3), F4 (F4), F5 (F5), F6 (F6), F7 (F7), F8 (F8)
	, FL (FL), FA (FA)
	-- ** Handle Concatenation
	, concatFields, concatFieldsWith
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
	-- ** Lowlevel Stuff
	, CGIOption (..), CGIOptions, URL (..)
	-- ** Servlets
	, makeServlet, makeServletWithHook
	-- * HTML and Style
	, module WASH.CGI.HTMLWrapper
	, module WASH.CGI.Style
	-- * Experimental Stuff
	, FrameSet, FrameLayout(..), FrameSpacing(..), makeFrame, makeFrameset, framesetPage
	)
where

import WASH.CGI.CGIMonad (CGIMonad())
-- import qualified Prelude
import WASH.CGI.AbstractSelector
  	( as_rows, as_cols, table_io, getText, unAR
	, selectionGroup, selectionButton, selectionDisplay
	, choiceGroup, choiceButton, choiceDisplay
	)
import WASH.CGI.BaseCombinators
	( io, once, forever, callWithCurrentHistory, ask, askOffline
	, run, runWithOptions, runWithHook
	, tell, htell, backLink, hlink
	, docTranslator, lastTranslator
	, makeServlet, makeServletWithHook
	)
import WASH.CGI.CGITypes
	( FileReference(..), CGIOption(..), CGIOptions, URL(..)
	)
import WASH.CGI.CGIMonad (CGI)
import WASH.CGI.CGIInternals 
	( makeRef, makeA, makePopupRef, popuplink
	, InputField, VALID, INVALID
	, makeForm, makeImg, Image, internalImage, externalImage
	, HTMLField, resetField, activeInputField
	, inputField, textInputField, checkedTextInputField, passwordInputField
	, checkboxInputField, fileInputField, checkedFileInputField, imageField
	, RadioGroup, radioGroup, radioButton, radioError, makeButton
	, makeTextarea
	, selectMultiple, selectSingle, selectBounded
	, fieldSIZE, fieldMAXLENGTH, fieldVALUE
	, restart
	, concatFields, concatFieldsWith
	, standardQuery
	)
import WASH.CGI.Submit98 
	( value, InputHandle, HasValue
	, F0 (F0), F1 (F1), F2 (F2), F3 (F3), F4 (F4), F5 (F5), F6 (F6), F7 (F7), F8 (F8)
	, FL (FL), FA (FA)
	, submit, submit0, defaultSubmit, DTree, submitx, dtleaf, dtnode
	, submitLink, submitLink0, defaultSubmitLink
	, activate
	)
import WASH.CGI.CGIOutput
	( CGIOutput
	)
import WASH.CGI.CGITypes
	( Status(..), Location(..), FreeForm(..)
	)
import WASH.CGI.Fields
import WASH.CGI.Style 
import WASH.CGI.HTMLWrapper
  hiding (input, form, select, option, textarea, 
          cssHeader, cssPage, html, htmlHeader, standardPage)
import qualified WASH.CGI.HTMLWrapper as H

import WASH.CGI.Frames 
  (FrameSet, FrameLayout(..), FrameSpacing(..), makeFrame, makeFrameset, framesetPage)
