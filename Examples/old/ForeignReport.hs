module ForeignReport where

import Data.Char
import System.Directory
import Data.List hiding (head)
import Data.Maybe
import System.Random
import Prelude hiding (head)
import WASH.HTML.HTMLMonad
import WASH.CGI.CGI
import Item
import RepBase


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
