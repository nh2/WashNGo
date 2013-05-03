-- Vorlesung Internetprogrammierung, SS 2003
-- Musterloesung Uebungsblatt 2
-- Aufgabe 3
-- Matthias Neubauer

module Main where

import WASH.CGI.CGI hiding (map)
import System.Random
import Data.List 
import Data.Char

main :: IO ()
main = run mainCGI

mainCGI =
    do aWord <- io randomWordIO
       guessingPage 0 aWord [] ['a'..'z']
       
guessingPage :: Int -> String  -> [Char] -> [Char] -> CGI ()
guessingPage 10 word alreadyGuessed stillAvailable =
    standardQuery "Hangman" $ do
      p $ text "YOU LOST!"
      pre $ text $ showHangman 10
      p $ text $ "The answer was: " ++ word
guessingPage wrongGuesses word alreadyGuessed stillAvailable =
    if (length (nub word)) == (length alreadyGuessed) 
       then standardQuery "Hangman" $ text "You won!"
       else let wordShown = map 
			    (\ c -> if (toLower c) `elem` stillAvailable then '_' else c)
			    word
         in standardQuery "Hangman"$ do
	   p $ text $ intersperse ' ' wordShown
	   pre $ text $ showHangman wrongGuesses
	   p $ table $ tr $ mapM_ button stillAvailable 
   where 
   button letter =
     td $ submit0
                 (continueAction letter wrongGuesses word alreadyGuessed stillAvailable) 
		 (fieldVALUE ['_',letter,'_'])

continueAction letter wrongGuesses word alreadyGuessed stillAvail =
    let wrongGuesses' = wrongGuesses + 1
	stillAvail' = stillAvail \\ [letter]
    in if letter `elem` (map toLower word)
       then guessingPage wrongGuesses word (letter:alreadyGuessed) stillAvail'
       else guessingPage wrongGuesses' word alreadyGuessed stillAvail'
       
randomWordIO :: IO String
randomWordIO =
    do aNumber <- randomRIO (0, length dictionary - 1)
       return $ dictionary !! aNumber

dictionary :: [String]
dictionary = 
  ["Matthias"
  ,"Internetprogrammierung"
  ,"Elefant"
  ,"Webscripting"
  ,"Gorilla"
  ,"Krokodil"
  ,"Salamander"
  ,"Reiher"
  ,"Orchester"
  ,"Rastplatz"
  ,"Klarinette"
  ,"Violine"
  ,"Klavier"
  ,"Eigenschaft"
  ,"Rostlaube"
  ,"Volkswagen"
  ,"Schokolade"
  ,"Kassenwart"
  ,"Gummibaum"
  ,"Lampenschirm"
  ,"Lorbeerbusch"
  ,"Himbeere"
  ,"Brombeere"
  ,"Dampfschiff"
  ,"Durststrecke"
  ]

showHangman n = unlines (map (map (\(c, i) -> if i <= n then c else ' ')) hangmanData)

hangmanData = 
  [[(' ', 0), ('_', 2), ('_', 2), ('_', 2), ('_', 2), ('_', 2), ('_', 2)]
  ,[('|', 1), (' ', 0), ('/', 3), (' ', 0), (' ', 0), (' ', 0), ('|', 4)]
  ,[('|', 1), ('/', 3), (' ', 0), (' ', 0), (' ', 0), (' ', 0), ('o', 5)]
  ,[('|', 1), (' ', 0), (' ', 0), (' ', 0), (' ', 0), ('/', 7), ('|', 6), ('\\', 8)]
  ,[('|', 1), (' ', 0), (' ', 0), (' ', 0), (' ', 0), ('/', 9), (' ', 0), ('\\', 10)]
  ,[('|', 1)]
  ]
