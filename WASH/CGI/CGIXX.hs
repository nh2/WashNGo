{-# OPTIONS -fglasgow-exts #-}
-- © 2001, 2002 Peter Thiemann
{-|
  One stop shop for the WASH\/CGI library. All high-level scripts should 
  get along with importing just this module. Low-level scripts may have to 
  import "RawCGI". This version requires features beyond Haskell98, in particular 
  multi parameter type classes and existential types.
  -} 
module WASH.CGI.CGIXX (
	-- * Basics
	CGI
	, ask, tell, io, run
	, once, forever, htell, askOffline
	-- * Links and Images
	, Image, internalImage, externalImage, makeImg, makeRef, makeA
	, backLink, hlink
	-- * Forms and Widgets
	, HTMLField
	-- ** Form Creation
	, makeForm, standardQuery
	-- ** Form Submission
	, submit, submit0, defaultSubmit, resetField, activeInputField, activate
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
	, InputField, VALID, INVALID
	-- ** Attribute Shortcuts
	, fieldSIZE, fieldMAXLENGTH, fieldVALUE
	-- * Advanced
	-- ** Installing Translators
	, runWithHook, docTranslator, lastTranslator
	-- ** Outputable Stuff
	, CGIOutput, Status(..), Location(..), FreeForm(..), FileReference (..)
	-- ** Predefined Types for Input Fields
	, Text(..), NonEmpty(..), AllDigits(..)
	, EmailAddress(..), CreditCardNumber(..), CreditCardExp(..)
	-- ** Lowlevel Options
	, CGIOption (..), CGIOptions
	-- ** Servlets
	, makeServlet, makeServletWithHook
	-- * HTML and Style
	, module WASH.CGI.HTMLWrapper
	, module WASH.CGI.Style
	-- * Experimental Stuff
	, FrameSet, FrameLayout(..), FrameSpacing(..), makeFrame, makeFrameset, framesetPage
	)
where

import qualified Prelude
import WASH.CGI.BaseCombinators
	( io, once, forever, callWithCurrentHistory, ask, askOffline
	, run, runWithOptions, runWithHook
	, tell, htell, backLink, hlink
	, docTranslator, lastTranslator
	, makeServlet, makeServletWithHook
	)
import WASH.CGI.CGITypes
	( FileReference(..), CGIOption(..), CGIOptions
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
import WASH.CGI.SubmitXX 
	( submit, submit0, defaultSubmit
        , submitx, DTree, dtleaf, dtnode
	, activate )
import WASH.CGI.CGIOutput
	( CGIOutput
	)
import WASH.CGI.CGITypes
	( Status(..), Location(..), FreeForm(..)
	)
import WASH.CGI.Fields
import WASH.CGI.Style 
import WASH.CGI.HTMLWrapper
  hiding (input, form, select, option, textarea)
import WASH.CGI.Frames
  (FrameSet, FrameLayout(..), FrameSpacing(..), makeFrame, makeFrameset, framesetPage)
