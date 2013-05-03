module Item where

import Prelude hiding (head,map,span,div)
import qualified Prelude (head,map,span,div)
import System.Random
import System.Directory
import WASH.CGI.CGI
import WASH.HTML.HTMLMonad
import Data.List hiding (head)
import Data.Char
import Data.Maybe
import WASH.Utility.Locking
import System.IO
import WASH.Utility.Auxiliary

----------------------------------------
enabledFile, registryFile, submissionsFile, reportFile, counterFile, reviewerFile, pcmembersFile, accessrightsFile, acceptedFile, instructionsFile :: (?storeDirectory :: String) => String
enabledFile	= ?storeDirectory ++ "SUBMISSION_ENABLED"
registryFile    = ?storeDirectory ++ "REGISTRY"
submissionsFile = ?storeDirectory ++ "SUBMISSIONS"
reportFile      = ?storeDirectory ++ "REPORTS"
counterFile     = ?storeDirectory ++ "COUNTER"
reviewerFile    = ?storeDirectory ++ "REVIEWERS"
pcmembersFile   = ?storeDirectory ++ "PCMEMBERS"
accessrightsFile= ?storeDirectory ++ "ACCESSRIGHTS"
acceptedFile    = ?storeDirectory ++ "ACCEPTED"
instructionsFile= ?storeDirectory ++ "INSTRUCTIONS"
----------------------------------------

translator names@(name:_) =
  let fileName = ?storeDirectory ++ name in
  do ex <- io (doesFileExist fileName)
     if ex 
       then tell FileReference { fileReferenceName = fileName
                          , fileReferenceContentType = guessContentType name
			  , fileReferenceExternalName = ""
			  }
       else lastTranslator names
translator names = lastTranslator names

guessContentType name 
  | ".ps"	`isSuffixOf` name = "application/postscript"
  | ".ps.gz"	`isSuffixOf` name = "application/postscript"   -- correct?
  | ".pdf"	`isSuffixOf` name = "application/pdf"
  | ".html"	`isSuffixOf` name = "text/html"
  | otherwise = "application/octet-stream"

venueQuery ttl body =
  case ?venuePath of
    [] -> standardQuery ttl body
    _  -> standardQuery (tail ?venuePath ++ ": " ++ ttl) body

venueName :: (?venuePath :: String) => String
venueName = case ?venuePath of
	      [] -> "(venue not set)"
	      _:rest -> rest

inventPassword :: (?storeDirectory :: String) => IO String
inventPassword =
  do obtainLock registryFile 
     registry <- readFileNonExistent registryFile ""
     let passwords = lines registry
     inventPassword' passwords

inventPassword' passwords =
  do g <- newStdGen
     let candidate = take 8 $ randomRs ('a','z') g
     if candidate `elem` passwords then inventPassword' passwords
       else do writeFile registryFile (unlines (candidate : passwords))
	       releaseLock registryFile
	       return candidate

readFileStrictly filePath =
  do h <- openFile filePath ReadMode
     contents <- hGetContents h
     hClose (g contents h)
     return contents
  where
    g [] h = h
    g (_:rest) h = g rest h

----------------------------------------
data SubmissionItem =
    AddItem { itemPassword :: String
    	    , itemAuthor :: String
	    , itemTitle :: String
	    , itemAffiliation :: String
	    , itemEmail :: String
	    , itemAbstract :: String
	    , itemExtension :: String
            , itemNumber :: Int
 	    }
  | DelItem { itemPassword :: String }
  deriving (Read, Show)

addItem password author title affiliation email abstract extension = do
  item <- extractSubmission password
  obtainLock counterFile
  countstr <- readFileNonExistent counterFile "0"
  let count :: Int
      count = read countstr
      action count' = appendFile submissionsFile
                      ((show $ AddItem password author title affiliation email abstract extension count') ++ "\n")
  case item of 
    DelItem _ -> 
      do let count' = count + 1
	 action count'
	 writeFile counterFile (show count')
    _ -> action count
  releaseLock counterFile

delItem password = do
  obtainLock counterFile
  appendFile submissionsFile ((show $ DelItem password) ++ "\n")
  releaseLock counterFile

readSubmissions :: (?storeDirectory :: String) => IO [SubmissionItem]
readSubmissions =
  do contents <- readFileNonExistent submissionsFile ""
     return $ Prelude.map read (lines contents)

extractSubmission :: (?storeDirectory :: String) => String -> IO SubmissionItem
extractSubmission password =
  do items <- readSubmissions
     return $ extractItem password items (DelItem password)

extractItem password [] def = def
extractItem password (item : items) def
  | password == itemPassword item = extractItem password items item
  | otherwise = extractItem password items def

allSubmissions :: (?storeDirectory :: String) -> IO [SubmissionItem]
allSubmissions = do
 pwdl <- readFileNonExistent registryFile ""
 items <- readSubmissions
 let pwds  = reverse $ lines pwdl
     extrs = fmap (\pw -> extractItem pw items (DelItem pw)) pwds
     res   = filter (\x -> case x of {DelItem _ -> False; _ -> True;}) extrs
 return res


----------------------------------------
data Report = Report 
 { reportPassword    :: String
 , reportReviewer    :: String
 , reportPCMember    :: String  -- 
 , reportForAuthor   :: String  -- Comment for Author
 , reportForPC       :: String  -- Comment for PC
 , reportRating      :: Integer -- 0-9
 , reportRelevance   :: Integer -- 0-4
 , reportOriginality :: Integer -- 0-4
 , reportClarity     :: Integer -- 0-4
 , reportSoundness   :: Integer -- 0-4
 , reportConfidence  :: Integer -- 0-4
 }
 deriving (Read, Show)

allReports :: (?storeDirectory :: String) -> IO [Report]
allReports = do
 contents <- readFileNonExistent reportFile ""
 return $ fmap read $ lines contents

extractReports :: String -> [Report] -> [Report]
extractReports password reports =
 filter test reports
  where
   test report = reportPassword report == password

addReport :: (?storeDirectory :: String) =>
	     String -> String -> String -> String -> String -> Integer -> 
             Integer -> Integer -> Integer -> Integer -> Integer -> IO ()
addReport password reviewer pcmember forAuthor forPC rating 
          relevance originality clarity soundness confidence =
  do obtainLock reportFile
     appendFile reportFile
       ((show $ 
         Report password reviewer pcmember forAuthor forPC rating 
               relevance originality clarity soundness confidence ) 
        ++ "\n")
     releaseLock reportFile

----------------------------------------
nonEmptyField mstr = 
  do str <- mstr
     let str' = dropWhile isSpace str
     if null str' then Nothing else Just str'


makeReference :: Monad m => SubmissionItem -> CGI (WithHTML x m ())
makeReference submission = 
 makeRef (itemPassword submission ++ itemExtension submission) (text "view paper")

