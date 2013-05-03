-- Vorlesung Internetprogrammierung, SS 2003
-- Musterloesung Uebungsblatt 2
-- Aufgabe 2
-- Matthias Neubauer

module Main where

import WASH.CGI.CGI hiding (div)
import WASH.CGI.Fields
import System.Time
import Data.Char
import Data.Ix

main =
  run $ standardQuery "Days of Life!" $
    do nameF <- p $ do text "What's your name?"
		       textInputField empty
       bdayF <- p $ do text "What's your birthday?"
		       inputField empty
       submit (F2 nameF bdayF) resultAction empty

resultAction (F2 nameF bdayF) =
  do Date yyN mmN ddN <- io getCurrentDay
     let name = value nameF
	 Date yy mm dd = value bdayF
	 now = CalendarTime yyN (mmToMonth mmN) ddN 0 0 0 0 Sunday 0 "MET" 0 True
         nowClock = toClockTime now
	 bDay = CalendarTime yy (mmToMonth mm) dd 0 0 0 0 Sunday 0 "MET" 0 True
	 bDayClock = toClockTime bDay
	 timeDiffSecs = tdSec $ diffClockTimes nowClock bDayClock
	 timeDiffDays = timeDiffSecs `div` (60 * 60 *24)
     standardQuery "Days of Life!" $
       do p $ text $ "Hi " ++ name ++ "!"
	  p $ text $ "You are " ++ (show timeDiffDays) ++ " days old!"

-- we roll our own data type for dates

data Date = Date { year :: Int, month :: Int , day :: Int }

instance Reason Date where
  reason _ = "date: yyyy-mm-dd"

instance Read Date where
  readsPrec i str = 
    let str' = dropWhile isSpace str
    in case str' of
      (y1:y2:y3:y4:'-':m1:m2:'-':d1:d2:rest) ->
	 let yearStr = [y1,y2,y3,y4]
	     monthStr = [m1,m2]
	     dayStr = [d1,d2]
	     year = read yearStr
	     month = read monthStr
	     day = read dayStr
	 in if all isDigit yearStr && all isDigit monthStr && all isDigit dayStr
	       && 1 <= month && month <= 12 && 1 <= day && day <= 31
	       then [(Date year month day, rest)]
	       else []
      _ -> []

instance Show Date where
  show (Date yy mm dd) = 
       (align 4 yy) ++ "-" ++ (align 2 mm) ++ "-" ++ (align 2 dd)
    where 
      align n i = let str = show i in replicate (n - length str) '0' ++ str

-- some aux. functions for dates

getCurrentDay :: IO Date
getCurrentDay =
  do now <- getClockTime
     let calTime = toUTCTime now
	 year = ctYear calTime
	 month = (index (January, December) $ ctMonth calTime) + 1
	 day = ctDay calTime
     return $ Date year month day

mmToMonth :: Int -> Month
mmToMonth mm = [January .. December] !! (mm - 1)
