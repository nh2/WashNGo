module Report2 where

import WASH.Utility.Auxiliary
import Char
import Directory
import List hiding (head)
import Maybe
import Monad
import Random
import Prelude hiding (head)
import WASH.HTML.HTMLMonad
import WASH.CGI.CGI
import WASH.CGI.CGIInternals (unsafe_io)
import WASH.CGI.CGIMonad
import WASH.CGI.Fields
import RepBase
import System
import WASH.Mail.Email

-- pcAccess :: (?venuePath :: String) => F0 -> CGI ()
pcAccess F0 = venueQuery "PC Login" $ do
 table $ do
  pcNameF   <- tr (td (text "PC Login") >>
                   td (inputField (fieldSIZE 20)))
  passwordF <- tr (td (text "Password") >>
                   td (passwordInputField (fieldSIZE 20)))
  tr (td (submit (F2 pcNameF passwordF) doLogin (fieldVALUE "Login")) >> td empty)

doLogin (F2 pcNameF passwordF) = 
 let ?pcname   = unNonEmpty (value pcNameF) in
 let password = unNonEmpty (value passwordF) in
 validPCPassword ?pcname password >>= \valid ->
 if not valid 
  then htell $ standardPage "Login incorrect" $ backLink empty
  else mainMenu

-- TODO
validPCPassword pcname password = 
 io $ do s <- readFileNonExistent pcmembersFile ""
	 let alist = fmap read $ lines s
	     result = lookup pcname alist
	 case result of
	   Just pw | password == pw -> return True
	   _                        -> return False

getRights name =
  io $ do s <- readFileNonExistent accessrightsFile ""
	  let alist = fmap read $ lines s
	      result = lookup name alist
	  case result of
	    Nothing -> return []
	    Just xs -> return xs

data ReportAction
	= Reviewing
	| AcceptedPapers
	| AcceptedEmails

mainMenu :: (?storeDirectory :: String, ?venuePath :: String, ?pcname :: String) =>
	CGI ()
mainMenu = 
 do rights <- getRights ?pcname
    venueQuery "Menu of Activities" $ do
      p (submit0 (excerptlist False) (fieldVALUE "OVERVIEW"))
      p (submit0 (reportlist Reviewing) (fieldVALUE "Abstracts and Reviews"))
      p (submit0 (reportlist AcceptedPapers) (fieldVALUE "List of Accepted Papers"))
      p (submit0 (reportlist AcceptedEmails) (fieldVALUE "List of Accepted Papers"))
      p (submit0 (reviewerlist) (fieldVALUE "List of Outside Reviewers"))
      when ("chair" `elem` rights)
	   (p (submit0 (excerptlist True) (fieldVALUE "DECISIONS")))

reviewerlist ::
	(?storeDirectory :: String, ?venuePath :: String, ?pcname :: String) => CGI ()
reviewerlist = do
  reps <- unsafe_io allReports
  let outside rep = not (reportReviewer rep == reportPCMember rep)
      reviewers = nub $ sort $ Prelude.map reportReviewer (filter outside reps)
      format reviewer = li (text reviewer)
      doc = textDOC "plain" reviewers
      message = simpleMail [?pcname] (venueName ++ ": List of Reviewers") doc
  exitcode <- unsafe_io (sendmail message)
  venueQuery "List of Reviewers" $ ul $
    mapM_ format reviewers

reportlist reportAction = do
 subs <- unsafe_io allSubmissions
 refs <- mapM makeReference subs
 reps <- unsafe_io allReports
 acceptedStr <- unsafe_io (readFileNonExistent acceptedFile "[]")
 let orps = rightOrder subs reps
     accepted :: [Int]
     accepted = read acceptedStr
 case reportAction of
   Reviewing ->
     venueQuery "List of Submissions" $
       sequence $ zipWith3 formatSubmission subs refs orps
   AcceptedPapers ->
     venueQuery "List of Accepted Papers" $ 
       formatList listItem accepted subs
   AcceptedEmails ->
     venueQuery "Email Addresses of Accepted Authors" $
       formatList emailItem accepted subs

listItem sub =  (em (text (itemTitle sub))
	           ## text ", "
		   ## br empty
		   ## text (itemAuthor sub)
		   ## text ", "
		   ## text (itemAffiliation sub))

emailItem sub = (tt (text (itemEmail sub)))

formatList formatItem accepted subs =
  ol (mapM_ g subs)
  where g sub = 
	  if itemNumber sub `elem` accepted
	  then li (formatItem sub)
	  else empty

rightOrder :: [SubmissionItem] -> [Report] -> [[Report]]
rightOrder slist rlist =
 fmap (\sub -> extractReports (itemPassword sub) rlist) slist

formatSubmission ::
	(?storeDirectory :: String, ?venuePath :: String, ?pcname :: String) =>
	SubmissionItem -> WithHTML x CGI () -> [Report] -> WithHTML y CGI ()
formatSubmission submission reference reports = do 
 formatSubmissionStandard submission
 p reference
 p $ do submit F0 (writeReport ?pcname ?pcname submission reference)
		  (fieldVALUE "write report")
	submit F0 (askForReport ?pcname submission reference)
		  (fieldVALUE "ask for report")
	submit F0 (viewReports False submission reports reference)
		  (fieldVALUE "view reports")
	mapM_ text (fmap ((++ " ") . reportPCMember) reports)
 text "Abstract"
 p $ text $ itemAbstract submission
 hr empty

excerptlist deciding = do
 subs <- unsafe_io allSubmissions
 refs <- mapM makeReference subs
 reps <- unsafe_io allReports
 let orps = rightOrder subs reps 
 venueQuery ("List of Submissions" ++ if deciding then " [DECISIONS]" else "") $
  table $ do
    attr "border" "2"
    thead (th (text "Paper#") 
        ## th (text "Paper")
	## th (text (if deciding then "Decide" else "Reports"))
	## th (text "Conf")
	## th (text "Overall")
	## th (text "Reviewers"))
    let weightedRows = zipWith3 (excerptSubmission deciding) subs refs orps
	sortedRows = sortBy leq weightedRows
	leq r1 r2 = compare (fst r2) (fst r1)
	finalRows = Prelude.map snd sortedRows
    sequence $ finalRows

excerptSubmission deciding submission reference reports = 
  let wo = weightedOverall reports in
  (wo,
  tr $ do
  td (text (show (itemNumber submission)))
  td reference
  td (submit F0 (viewReports deciding submission reports reference) 
	(fieldVALUE (if deciding then "decide" else "view")))
  td (text (take 4 $ show (overallConfidence reports)))
  td (text (take 4 $ show wo))
  mapM (\ r -> td (text ('(':show (reportRating r)
                       ++'*':show (reportConfidence r)
                       ++')':reportPCMember r))) reports)


{-
--ratings1 :: Monad m => WithHTML CGI Select

--ratings1a :: Monad m => WithHTML m ()
ratings1a = table $ do
 tr $ do
  td (text "Relevance:")
  td (text "Originality:")
  td (text "Clarity:")
  td (text "Soundness:")
  td (text "Confidence:")
 e <- tr $ do
  relevanceF   <- td (selectFromList Nothing (fmap show [0..4]) empty)
  originalityF <- td (selectFromList Nothing (fmap show [0..4]) empty)
  clarityF     <- td (selectFromList Nothing (fmap show [0..4]) empty)
  soundnessF   <- td (selectFromList Nothing (fmap show [0..4]) empty)
  confidenceF  <- td (selectFromList Nothing (fmap show [0..4]) empty)
  return (relevanceF, originalityF, clarityF, soundnessF, confidenceF)
 return e



scale1 = ["4 = very good", "3 = good", "2 = average", "1 = weak", "0 = very weak"]
scale2 = ["4 = must accept", "3 = acceptable", "2 = marginal", "1 = reject", "0 = out of scope"]

horizontal xs = table $ tr $ mapM (td . text) xs >> return ()

vertical xs = table $ mapM (tr.td.text) xs >> return ()
-}


--------------------------------------------------------------------------------
askForReport pcname submission reference F0 = 
 venueQuery "ask for report" $ do
  p (formatSubmissionStandard submission)
  p $ text "Name of Reviewer"
  revF <- p $ inputField (fieldSIZE 30)  
  p $ text "Email of Reviewer"
  emailF <- p (inputField (fieldSIZE 30) ## text " (just the bare address, please)")
  subjectF <- p $ inputField (fieldSIZE 30 ## fieldVALUE "Request for a review")
  txtF <- p $  makeTextarea "" (attr "rows" "10" ## attr "cols" "75") ## attr "colspan" "2"
  let call = checkedSendMail pcname submission
  submit (F4 revF subjectF emailF txtF) call (fieldVALUE "send")
  hr empty
  p $ text "There will be a link to the paper detailed on top of this page at the end of the email sent to the external reviewer. You will receive a copy of the email sent to the reviewer and the system will send you a notification as soon as the reviewer enters his review."

checkedSendMail pcname submission (F4 revF subjectF emailF txtF) =
  let reviewer = unNonEmpty $ value revF
      email    = unEmailAddress $ value emailF
      subject  = unNonEmpty $ value subjectF
      txt      = value txtF
  in
  if not (null txt)
  then
    sendMail pcname submission reviewer subject email txt
  else
    venueQuery "Asking for Report was Unsuccessful" $
      (p (text "No text was entered in the body of the mail.")
       ## p (backLink empty))

sendMail pcname submission reviewer subject email txt = do
  url <- getUrl
  io (do rid <- newReviewer reviewer pcname (itemPassword submission)
	 let message = (simpleMail [email,pcname] subject
     	       (textDOC "plain" [txt
	       			, ""
				, "The paper is available through the reviewer login at"
				, url
				, "using your reviewer ID '" ++ rid ++ "' to login."]))
	       {headers= [Header ("From", pcname)
	       		 ,Header ("Reply-To", pcname)]}
	 sendmail message)
  htell $ standardPage "Ok" $ text "Mail is sent"

viewReports deciding submission reports reference F0 =
 let paperNr = itemNumber submission in
 venueQuery ("Reports for Paper #" ++ show paperNr) $ do
 formatSubmissionStandard submission
 br empty
 reference
 br empty
 hr empty
 table $ do
   attr "border" "2"
   tr (td (b (text "Reports by "))  ## 
           mapM (\ r -> td (text (reportPCMember r))) reports)
   tr (td (b (text "Weighted overall rating ")) ##
           td (text (show (weightedOverall reports))))
 hr empty
 when deciding (makeForm $
                p (submit F0 (notifyReject submission reports) (fieldVALUE "REJECT")
                ## submit F0 (notifyAccept submission reports) (fieldVALUE "ACCEPT")))
 mapM formatReport reports

weightedOverall reports = g 0 0 reports
  where g 0 _  [] = 0
	g n ws [] = fromInteger ws / fromInteger n
	g n ws (r:rs) = let conf = reportConfidence r in
			g (n + conf) (ws + conf * reportRating r) rs

overallConfidence reports = g 0 0 reports
  where g 0 _ [] = 0
	g n c [] = fromInteger c / fromInteger n
	g n c (r:rs) = g (n + 1) (c + reportConfidence r) rs

formatReport report = do
 let ratings = [ ("Overall Rating", show $ reportRating report)
               , ("Relevance", show $ reportRelevance report)
               , ("Originality", show $ reportOriginality report)
               , ("Clarity", show $ reportClarity report)
               , ("Soundness", show $ reportSoundness report)
               , ("Confidence", show $ reportConfidence report)
               ]
 table $ do
  tr $ td (b (text "Reviewer ")) >> td (text (reportReviewer report))
  tr $ td (b (text "PC Member ")) >> td (text (reportPCMember report))
  tr $ td $ (attr "colspan" "2") >> 
     table (do tr $ mapM (\ (x,y) -> td (b (text x))) ratings
		 tr $ mapM (\ (x,y) -> td (text y)) ratings
		 attr "border" "2")
  tr $ td $ (attr "colspan" "2") >> b (text "Comments for Authors")
  tr $ td $ (attr "colspan" "2") >> (pre (text (reportForAuthor report)))
  tr $ td $ (attr "colspan" "2") >> b (text "Comments for PC")
  tr $ td $ (attr "colspan" "2") >> (pre (text (reportForPC report)))
  --mapM (\(x,y) -> tr (td (b (text x)) >> td (text y))) ratings
 hr empty


maketable2 xs = mapM aux xs
 where
  aux (a,b) = tr (td (h2 (text a)) >> td (text b))

----------------------------------------------------------------------

notifyAccept submission reports F0 = do
  instr <- unsafe_io (readFile instructionsFile)
  let opening = textDOC "plain"
      	["Dear " ++ itemAuthor submission ++ ","
	,""
	,"I am pleased to inform you that your paper"
	,"    "++ itemTitle submission 
	,"has been selected for presentation at " ++ venueName
	,""
        ,"I am appending"
	,"* instructions for preparation and submittal of your final paper"
        ,"* the comments of the reviewers on your submission."
        ,"  Please do take them into account when revising your paper."
        ,""
	,"*Please acknowledge receipt of this message ASAP.*"
        ,""
	,"Best wishes"
	,"  " ++ ?pcname
	,"  program chair, " ++ venueName
	]
      instructions = 
        (textDOC "plain" (lines instr)) { filename= "AuthorInstructions" }
  notify ?pcname [opening, instructions] submission reports

notifyReject submission reports F0 = do
  let opening = textDOC "plain"
      	["Dear " ++ itemAuthor submission ++ ","
	,""
	,"I am sorry to inform you that your paper"
	,"    "++ itemTitle submission 
	,"was not selected for presentation at " ++ venueName
	,""
	,"The selection process was competitive; due to time and space limitations"
	,"some publishable submissions could not be accepted."
	,"Nonetheless, I hope that you will still be able to attend the meeting."
	,""
        ,"I am appending the comments of the reviewers on your submission."
        ,"I hope they prove useful to your further work."
        ,""
	,"Best regards"
	,"  " ++ ?pcname
	,"  program chair, " ++ venueName
	]
  notify ?pcname [opening] submission reports

notify pcname openings submission reports = do
  let doReport report nr =
        (textDOC "plain" (lines (reportForAuthor report)))
	{ filename= "Review#" ++ show nr }
      doc = multipartDOC "mixed" (openings ++ zipWith doReport reports [1..])
  testMessage <- return $
      ((simpleMail [pcname] (venueName ++ " Notification") doc)
      		{cc=	  [pcname]
		,headers= [Header ("From", pcname)
		          ,Header ("Reply-to", pcname)
			  ]
		})
  message <- return $
      ((simpleMail [itemEmail submission] (venueName ++ " Notification") doc)
      		{cc=	  [pcname]
		,headers= [Header ("From", pcname)
		          ,Header ("Reply-to", pcname)
			  ]
		})
  exitcode <- unsafe_io (sendmail message)
  htell (standardPage ("Message sent. Exitcode = " ++ show exitcode) empty)

