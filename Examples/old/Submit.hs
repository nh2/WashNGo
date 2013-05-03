-- © 2001 Peter Thiemann
module Submit where

import WASH.Utility.Auxiliary
import Data.Char
import System.Directory
import WASH.CGI.Fields
import Data.List hiding (head)
import Data.Maybe
import Control.Monad
import System.Random
import Prelude hiding (head)
import WASH.HTML.HTMLMonad
import WASH.CGI.CGI
import WASH.CGI.RawCGI
import Item
import Report2
import ForeignReport

data MainAction = Submit | Revise | Withdraw
  deriving (Eq, Read, Show)

entryPage :: (?storeDirectory :: String, ?venuePath :: String) => IO ()
entryPage = 
  runWithHook [] translator $
  do submissionEnabled <- io $ catch (readFile enabledFile >> return True)
                                     (const (return False))
     venueQuery "Reviewing Engine" $
       table $ do
         when submissionEnabled $
	   tr (td (submit0 submission (fieldVALUE "Start new submission")
              ## attr "align" "center"))
	 tr (td (submit0 rwsub
	 	 (fieldVALUE "Revise/withdraw submission") ## attr "align" "center"))
	 tr (td (submit0 pcAccess (fieldVALUE "PC access") ## attr "align" "center"))
	 tr (td (submit0 reviewerlogin (fieldVALUE "External Reviewer access") ## attr "align" "center"))

rwsub =
  venueQuery "Revise/Withdraw Paper" $
  table $
  do emailF <- tr $ question "Email" (inputField (fieldSIZE 60))
     keyF   <- tr $ question "Password" (passwordInputField (fieldSIZE 20))
     submit (F2 emailF keyF) dispatch (fieldVALUE "Revise/withdraw paper")

dispatch :: (?storeDirectory :: String, ?venuePath :: String) =>
	F2 (InputField EmailAddress) (InputField NonEmpty) VALID -> CGI ()
dispatch (F2 emailF keyF) =
  revision emailF keyF

submission =
  venueQuery "Paper Submission" $
  table $
  let standardField :: (Reason a, Read a) => WithHTML x CGI (InputField a INVALID)
      standardField = inputField (fieldSIZE 60) in
  do authorF      <- tr $ question "Authors"     	standardField
     titleF       <- tr $ question "Title of paper"	standardField
     affiliationF <- tr $ question "Affiliation" 	standardField
     emailF       <- tr $ question "Email"       	standardField
     tr $ (td empty ## td (text "(corresponding author only)"))
     _            <- tr ( td (text "Abstract" ## attr "colspan" "2")) 
     abstractF    <- tr ( td (makeTextarea "" (attr "rows" "10" ## attr "cols" "75")
     			      ## attr "colspan" "2"))
     paperF       <- tr $ question "Filename of paper" (fileInputField (fieldSIZE 40))
     tr (td (text "Acceptable file formats:") ## (td (text ".ps, .ps.gz and .pdf" )))
     tr $ td (attr "align" "center"
          ## submit (F6 authorF titleF affiliationF emailF abstractF paperF)
	            (processSubmission Nothing)
		    (fieldVALUE "Submit paper"))

--question :: Field input => String -> input -> [Element]
question str inf =
  td (text str) >> td inf

--answer :: Show a => String -> InputField a x -> [Element]
answer str inf =
  td (b (text str)) >> td (text (show (value inf)))

processSubmission maybePassword
  (F6 authorF titleF affiliationF emailF abstractF paperF) = 
  let author = unNonEmpty (value authorF)
      title  = unNonEmpty (value titleF)
      affiliation = unNonEmpty (value affiliationF)
      paper = value paperF
      email = unEmailAddress (value emailF)
      extension = getFileSuffix (fileReferenceExternalName paper) 
      contentType = fileReferenceContentType paper
  in
--  if allOK then
  do password <- case maybePassword of
		   Just pw -> return pw
		   Nothing -> io inventPassword
     let fileName = password ++ extension
	 storeFile = ?storeDirectory ++ fileName
     io (readFile (fileReferenceName paper) >>= writeFile storeFile)
     ref <- makeRef fileName (text "view paper")
     io (addItem password author title affiliation email
		 (value abstractF)
		 extension)
     htell $
       standardPage "Paper Submission Acknowledgement" $ 
       (table
         (  tr (td (b $ text "Your password") ## td (text password))
	 ## tr ( answer "Authors" authorF)
    	 ## tr ( answer "Title of paper"   titleF)
	 ## tr ( answer "Affiliation" affiliationF)
	 ## tr ( answer "Email" emailF)
	 ## tr (td (attr "colspan" "2" ## b (text "Abstract")))
	 ## tr (td (text (value abstractF) ## attr "colspan" "2"))
	 ## tr (td (b (text "File format")) ## td (analyseContentType contentType))
	 ## tr (td (b (text "View downloaded file"))
	     ## td ref))
       ## hr empty
       ## text "Please save this page for future reference. "
       ##  text "Using the password, you can revise and/or withdraw your paper and your submission information until the deadline is expired."
       ##  text "Double check that your e-mail address is correct because it is the only way that we can reach you.")

analyseContentType contentType =
  if contentType `elem` ["application/postscript", "application/pdf"] then
     text contentType
  else
     attr "bgcolor" "red" ## text contentType ## text " might be a problem"

revision emailF keyF = 
  let password = unNonEmpty (value keyF)
      email = unEmailAddress (value emailF)
  in
  do item <- io (extractSubmission password)
     ref <- makeRef (itemPassword item ++ itemExtension item) (text "view here")
     case item of
       DelItem _ ->
         htell $ standardPage "Error: invalid email/password" (text "No such paper.")
       _ ->
         let standardField val = inputField (fieldSIZE 60 ## fieldVALUE val)
	 in venueQuery  "Revision/Withdrawal of Submission" $
         do text "Previously submitted version: "
	    ref
	    br empty
	    table $
	      do authorF <- tr $ question "Authors" (standardField (NonEmpty $ itemAuthor item))
		 titleF  <- tr $ question "Title of paper" (standardField (NonEmpty $ itemTitle item))
		 affiliationF <- tr $ question "Affiliation" (standardField (NonEmpty $ itemAffiliation item))
		 emailF  <- tr $ question "Email" (standardField (EmailAddress (itemEmail item)))
		 tr $ (td empty ## td (text "(corresponding author only)"))
		 tr (td (text "Abstract" ## attr "colspan" "2"))
		 abstractF <- tr (td (makeTextarea (itemAbstract item) (attr "rows" "10" ## attr "cols" "75") ## attr "colspan" "2"))
		 paperF <- tr $ question "Filename of paper" (fileInputField (fieldSIZE 40))
		 tr (td (submit (F6 authorF titleF affiliationF emailF abstractF paperF)
		                (processSubmission (Just password))
				(fieldVALUE "Resubmit paper") ## attr "align" "center")
		  ## td (submit0 (withdraw item) (fieldVALUE "Withdraw paper") ## attr "align" "center"))


withdraw item =
  do let password = itemPassword item
     io (delItem password)
     let fullName = ?storeDirectory ++ password ++ itemExtension item
     io (writeFile fullName "")
     htell $ standardPage "Withdrawal complete" 
     	    (text "Your submission has been removed from the system.")

notImplemented =
  htell $ standardPage "Not yet implemented..." empty

getFileSuffix name 
 | ".ps"    `isSuffixOf` name = ".ps"
 | ".ps.gz" `isSuffixOf` name = ".ps.gz" 
 | ".pdf"   `isSuffixOf` name = ".pdf"
 | otherwise                  = ""
 
