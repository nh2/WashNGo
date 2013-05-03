module WASH.Mail.RFC2822 where

import Data.Char
-- 
import Text.ParserCombinators.Parsec

crLf = try (string "\n\r" <|> string "\r\n") <|> string "\n" <|> string "\r"

fws =
  do many1 ws1
     option "" (do crLf
		   many1 ws1)
  <|> 
  do crLf
     many1 ws1

ws1 = oneOf " \t"
lineChar :: Parser Char
lineChar = noneOf "\n\r"
headerNameChar :: Parser Char
headerNameChar = noneOf "\n\r:"

-- |parse contents of Date field according to RFC2822
data DateTime2822 =
  DateTime2822 (Maybe DayOfWeek) Date2822 Time2822
instance Show DateTime2822 where
  showsPrec i (DateTime2822 mDayOfWeek date2822 time2822) =
    (case mDayOfWeek of
      Just dayOfWeek ->
	showsDayOfWeek dayOfWeek . showString ", "
      Nothing ->
	id) .
    shows date2822 .
    showChar ' ' .
    shows time2822

parseDateTime =
  do mdow <- option Nothing (try $ do fws
				      dow <- parseDayOfWeek
				      char ','
				      return (Just dow))
     date <- parseDate
     fws
     time <- parseTime
     return (DateTime2822 mdow date time)

type DayOfWeek = Int
showsDayOfWeek 1 = showString "Mon"
showsDayOfWeek 2 = showString "Tue"
showsDayOfWeek 3 = showString "Wed"
showsDayOfWeek 4 = showString "Thu"
showsDayOfWeek 5 = showString "Fri"
showsDayOfWeek 6 = showString "Sat"
showsDayOfWeek 7 = showString "Sun"
parseDayOfWeek =
      (try (string "Mon") >> return (1 :: DayOfWeek))
  <|> (try (string "Tue") >> return 2)
  <|> (try (string "Wed") >> return 3)
  <|> (try (string "Thu") >> return 4)
  <|> (try (string "Fri") >> return 5)
  <|> (try (string "Sat") >> return 6)
  <|> (try (string "Sun") >> return 7)
  
data Date2822 =
  Date2822 Int Int Int

instance Show Date2822 where
  showsPrec i (Date2822 d m y) =
    showsDay d .
    showChar ' ' .
    showsMonth m .
    showChar ' ' .
    showsYear y

parseDate =
  do d <- parseDay
     m <- parseMonth
     y <- parseYear
     return (Date2822 d m y)

showsDay i = shows i
parseDay =
  do fws
     d1 <- digit
     md2 <- option Nothing (digit >>= (return . Just))
     case md2 of
       Nothing ->
	 return (digitToInt d1)
       Just d2 ->
	 return (digitToInt d2 + 10 * digitToInt d1)

monthList = 
  ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
parseMonthName =
  foldr1 (<|>) (zipWith g monthList [1::Int ..])
  where 
    g mname mnr = try (string mname) >> return mnr

showsMonth m =
  showString (monthList !! (m-1))
parseMonth =
  do fws
     m <- parseMonthName
     fws
     return m

showsYear y =
  showString (drop 1 (show (10000 + y)))
parseYear =
  do y1 <- digit
     y2 <- digit
     my3 <- option Nothing (digit >>= (return . Just))
     my4 <- option Nothing (digit >>= (return . Just))
     case (my3, my4) of
       (Just y3, Just y4) ->
	 return (1000 * digitToInt y1 + 100 * digitToInt y2 
		 + 10 * digitToInt y3 + digitToInt y4)
       -- interpretation of obs-year from RFC2822, 4.3
       (Just y3, Nothing) ->
         return (1900 + 100 * digitToInt y1 + 10 * digitToInt y2 + digitToInt y3)
       (Nothing, Nothing) ->
         let rawVal = 10 * digitToInt y1 + digitToInt y2 in
	 if rawVal < 50 
	 then return (2000 + rawVal)
	 else return (1900 + rawVal)
       _ ->
	 fail "parseYear"
data Time2822 =
  Time2822 TimeOfDay2822 Zone2822
instance Show Time2822 where
  showsPrec i (Time2822 timeOfDay2822 zone2822) =
    shows timeOfDay2822 .
    showChar ' ' .
    shows zone2822

parseTime =
  do tod <- parseTimeOfDay
     fws
     zone <- parseZone
     return (Time2822 tod zone)

data TimeOfDay2822 =
  TimeOfDay2822 Int Int Int
instance Show TimeOfDay2822 where
  showsPrec i (TimeOfDay2822 hh mm ss) =
    showString (drop 1 $ show (100+hh)) .
    showChar ':' .
    showString (drop 1 $ show (100+mm)) .
    showChar ':' .
    showString (drop 1 $ show (100+ss))

parseTimeOfDay =
  do hh <- parseTwoDigits
     char ':'
     mm <- parseTwoDigits
     ss <- option 0 (try $ do char ':'
			      parseTwoDigits)
     return (TimeOfDay2822 hh mm ss)

zoneInfoList =
  [( "UT",  (Zone2822 '+' 0 0))
  ,( "GMT", (Zone2822 '+' 0 0))
  ,( "EDT", (Zone2822 '-' 4 0))
  ,( "EST", (Zone2822 '-' 5 0))
  ,( "CDT", (Zone2822 '-' 5 0))
  ,( "CST", (Zone2822 '-' 6 0))
  ,( "MDT", (Zone2822 '-' 6 0))
  ,( "MST", (Zone2822 '-' 7 0))
  ,( "PDT", (Zone2822 '-' 7 0))
  ,( "PST", (Zone2822 '-' 8 0))
  ]

parseZoneInfo =
  foldr1 (<|>) (map g zoneInfoList)
  where 
    g (zname, zinfo) = try (string zname) >> return zinfo

data Zone2822 =
  Zone2822 Char Int Int
instance Show Zone2822 where
  showsPrec i (Zone2822 sign hh mm) =
    showChar sign .
    showString (drop 1 $ show (100+hh)) .
    showString (drop 1 $ show (100+mm))
    
parseZone =
  do sign <- oneOf "+-"
     hh <- parseTwoDigits
     mm <- parseTwoDigits
     return (Zone2822 sign hh mm)
  <|> parseZoneInfo
  -- anything else should be mapped to (Zone2822 '-' 0 0)

parseTwoDigits =
  do d1 <- digit
     d2 <- digit
     return (10 * digitToInt d1 + digitToInt d2)

