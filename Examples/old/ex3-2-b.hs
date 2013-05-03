module Main where

import WASH.CGI.CGI
import qualified WASH.CGI.Persistent2 as P

voteCounter :: CGI (P.T (Int, Int))
voteCounter = P.init "Votes for Giovanni's CyberPizza" (0,0)

main = run result

result = 
  do counterHandle <- voteCounter
     (pro, contra) <- P.get counterHandle
     standardQuery ("Result of Voting for Giovanni's CyberPizza") $ do
       p (text "Votes for the CypberPizza: " >> text (show pro))
       p (text "Votes against it: " >> text (show contra))
