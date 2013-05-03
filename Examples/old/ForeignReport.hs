module ForeignReport where

import Char
import Directory
import List hiding (head)
import Maybe
import Random
import Prelude hiding (head)
import WASH.HTML.HTMLMonad
import WASH.CGI.CGI
import Item
import RepBase
import System


reviewerlogin F0 = venueQuery "Reviewer Login" $ do
  p $ text "Reviewer ID:"
  ridF <- p $ inputField (fieldSIZE 10)
  submit ridF reviewercheck (fieldVALUE "Login")

reviewercheck ridF = do
  maybe_r <- io $ getReviewerData (unNonEmpty $ value ridF)
  maybe invalid newReport maybe_r



invalid = htell $ standardPage "Invalid Reviewer ID" $ backLink empty

newReport revdata = do
  subm <- io $ extractSubmission (reviewerPassword revdata)
  case subm of 
    DelItem _ -> invalid
    _ -> do
      ref <- makeReference subm
      writeReport (reviewerPCMember revdata) (reviewerName revdata) subm ref F0
