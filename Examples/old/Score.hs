-- © 2001, 2002 Peter Thiemann
-- |score type for GuessNumber game
module Score where

import WASH.CGI.Types

data Score = Score String Int 
  deriving (Read, Show)
instance Types Score where
  ty ~(Score str i) =
    TS myRep (merge intDecls $ merge strDecls myDecls)
    where TS strRep strDecls = ty str
	  TS intRep intDecls = ty i
	  myRep = TRData "Score" []
	  myDecls = [TD "Score" [] [CR "Score" Nothing [strRep, intRep]]]

instance Eq Score where
  Score s1 i1 == Score s2 i2 = i1 == i2

instance Ord Score where
  Score s1 i1 <= Score s2 i2 = i1 <= i2
