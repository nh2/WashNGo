-- © 2002 Peter Thiemann
module Main where

import Prelude hiding (head, div, span, map)

import WASH.Utility.Auxiliary
import WASH.CGI.CGI
import qualified WASH.CGI.Cookie as C
import qualified WASH.CGI.Persistent2 as P

theFlag :: String -> CGI (C.T Bool)
theFlag ttl = C.initExpiring ("voted for "++ttl) 1440 False

voteCounter :: String -> CGI (P.T (Int, Int))
voteCounter ttl = P.init ("votes for "++ttl) (0,0)

main = 
  do pathInfo <- protectedGetEnv "PATH_INFO" "/"
     run $ overview (tail pathInfo)

showBool True = "for"
showBool False = "against"

overview ttl = once (
  do votedHandle <- theFlag ttl
     counterHandle <- voteCounter ttl
     (pro, contra) <- P.get counterHandle
     let doVote ans = do mvoted <- C.get votedHandle
			 case mvoted of
			   Nothing ->
			     problem ttl
			   Just voted ->
			     do C.set votedHandle True
				if voted then sorry ttl
			                 else acknowledge ttl ans
     standardQuery ("Voting for "++ ttl) $ do
       p (text "Votes for " ## text ttl ## text ": " ## text (show pro))
       p (text "Votes against " ## text ttl ## text ": " ## text (show contra))
       p (text "I'm " ##
          activate doVote (selectSingle showBool Nothing [True, False]) empty ## 
	  text " " ##
	  text ttl))
  >> overview ttl

problem ttl =
  standardQuery ("Problem with voting on topic " ++ ttl)
    (text "Reload this URL to try again.")

sorry ttl =
  standardQuery ("Sorry, you voted before on topic " ++ ttl)
    (submit0 finish (fieldVALUE "CONTINUE"))

acknowledge ttl ans = 
  do counterHandle <- voteCounter ttl
     (pro, contra) <- P.get counterHandle
     let (newpro, newcontra) | ans = (pro+1, contra)
                             | otherwise = (pro, contra+1)
     P.set counterHandle (newpro, newcontra)
     standardQuery ("Acknowledged vote "++ showBool ans ++ " " ++ ttl) 
       (submit0 finish (fieldVALUE "CONTINUE"))

finish = return ()
