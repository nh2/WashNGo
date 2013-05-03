module Main where

import WASH.CGI.CGI
import qualified WASH.CGI.Persistent2 as P

voteCounter :: CGI (P.T (Int, Int))
voteCounter = P.init "Votes for Giovanni's CyberPizza" (0,0)

main = run question

question = 
  once $ do 
    counterHandle <- voteCounter
    (pro, contra) <- P.get counterHandle
    standardQuery ("Voting for Giovannis CyberPizza") $
      p $ do 
	text "I'm "
	activate acknowledge (selectSingle showB Nothing [True, False]) empty
	text " Giovannis CyberPizza"
  >> question

acknowledge ans = 
  do counterHandle <- voteCounter
     (pro, contra) <- P.get counterHandle
     let (newpro, newcontra) | ans = (pro+1, contra)
                             | otherwise = (pro, contra+1)
     P.set counterHandle (newpro, newcontra)
     standardQuery ("Acknowledged vote \"" ++ showB ans ++ "\" ") 
       (submit0 finish (fieldVALUE "CONTINUE"))

finish = return ()

showB True = "for"
showB False = "against"
