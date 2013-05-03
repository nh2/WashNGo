module RepBase (module Item, module RepBase) where

import Auxiliary
import Data.Char
import System.Directory
import Data.List hiding (head)
import Data.Maybe
import System.Random
import Prelude hiding (head)
import WASH.HTML.HTMLMonad
import WASH.CGI.CGI
import Item
import WASH.Utility.Locking
import WASH.Mail.Email

--------------------------------------------------------------------------------


newReviewer name pcname password = do
 obtainLock reviewerFile
 s <- readFileNonExistent reviewerFile ""
 let l = fmap read $ lines s
 addReviewer name pcname password l


addReviewer name pcname password rs = do
 g <- getStdGen
 let rid = take 8 $ randomRs ('a','z') g
 if elem rid (fmap reviewerID rs) 
  then addReviewer name pcname password rs 
  else do
   appendFile reviewerFile (show (Reviewer rid name pcname password) ++ "\n")
   releaseLock reviewerFile
   return rid
    
data Reviewer = Reviewer { reviewerID :: String
                         , reviewerName :: String
                         , reviewerPCMember :: String
                         , reviewerPassword :: String
                         }
 deriving (Read,Show)

getReviewerData rid = do
 obtainLock reviewerFile
 s <- readFileNonExistent reviewerFile ""
 releaseLock reviewerFile
 let l = fmap read $ lines s
 return $  listToMaybe [a | a <- l, reviewerID a == rid]

selector txt lo hi =
  do td (text txt)
     td (selectSingle show Nothing [lo..hi] empty)

ratings1 = table $ tr $ do
    relevanceF   <- selector "Relevance" 0 4
    originalityF <- selector "Originality" 0 4
    clarityF     <- selector "Clarity" 0 4
    soundnessF   <- selector "Soundness" 0 4
    confidenceF  <- selector "Confidence" 0 4
    return (relevanceF, originalityF, clarityF, soundnessF, confidenceF)



writeReport pcname reviewername submission reference F0 =
 venueQuery "Submit Review" $ do
  formatSubmissionStandard submission
  p reference
  p $ text ("PC Member: " ++ pcname)
  p $ text ("Reviewer: " ++ reviewername)
  (relevanceF, originalityF, clarityF, soundnessF, confidenceF) <- p ratings1 
  p (text "4 = very good/high, 3 = good, 2 = average, 1 = weak, 0 = very weak/low")
  ratingF <- p $ table (tr (selector "Overall Rating" 0 4 ##
                            td (text "4 = must accept, 3 = acceptable, 2 = marginal, 1 = reject, 0 = out of scope")))
  forAuthorF <- p $ do
    text "Comments for Author" >> br empty
    makeTextarea "" (attr "rows" "20" ## attr "cols" "75") ## 
		    attr "colspan" "2"
  forPCF <- p $ do
   text "Comments for PC" >> br empty
   makeTextarea "" (attr "rows" "3" ## attr "cols" "75") ## attr "colspan" "2"
  let password = itemPassword submission
      fields = F8 forAuthorF forPCF ratingF 
      		  relevanceF originalityF clarityF soundnessF confidenceF
      call = sendReport password reviewername pcname
  p $ submit fields call (fieldVALUE "Send report")


sendReport password reviewername pcname 
           (F8 forAuthorF forPCF ratingF 
	       relevanceF originalityF clarityF soundnessF confidenceF) = 
  do io (do addReport 
	         password 
		 reviewername 
		 pcname 
		 (value forAuthorF) 
		 (value forPCF)
		 (value ratingF)
		 (value relevanceF)
		 (value originalityF)
		 (value clarityF)
		 (value soundnessF)
		 (value confidenceF)
	    let message = simpleMail [pcname] (venueName ++ ": Review Received")
		     (textDOC "plain" 
		     ["Your reviewer " ++ reviewername ++ " entered a review."])
	    sendmail message)
     venueQuery "Review Received" $ text "Your report is saved. Thank you."

formatSubmissionStandard submission =
 table ((tr ((td (b $ text "Author"))      ## (td (text (itemAuthor      submission)))))
     ## (tr ((td (b $ text "Title"))       ## (td (text (itemTitle       submission)))))
     ## (tr ((td (b $ text "Affiliation")) ## (td (text (itemAffiliation submission)))))
     ## (tr ((td (b $ text "Email"))       ## (td (text (itemEmail       submission)))))
     ## (tr ((td (b $ text "Number"))      ## (td (text (show $ itemNumber submission)))))
       )
