-- Vorlesung Internetprogrammierung, SS 2003
-- Musterloesung Uebungsblatt 1
-- Matthias Neubauer

module Main where

import WASH.CGI.CGI hiding (map)

-- Aufgabe 1

-- (a)

xor :: Bool -> Bool -> Bool
xor True  = not 
xor False = id

-- (b)

foo :: Int -> Int -> Int -> Int
foo x y z = x + y + z - min (min x y) z

-- (c)

sumOfPowers :: Int -> Int -> Int
sumOfPowers x n = sum $ take (n + 1) $ iterate (* x) 1

sumOfPowers' :: Int -> Int -> Int
sumOfPowers' x 0 = 1
sumOfPowers' x n = x * (sumOfPowers' x (n - 1)) + 1

-- Aufgabe 2
 
-- (a)

sublist :: Int -> Int -> [a] -> [a]
sublist 0 0 _      = []
sublist 0 _ []     = []
sublist 0 t (c:cs) = c : sublist 0 (t-1) cs
sublist s t (c:cs) = sublist (s-1) (t-1) cs

-- (b)

sublist' :: Int -> Int -> [a] -> [a]
sublist' s t cs = drop s $ take t cs

sublist'' s t = (drop s) . (take t)

-- Aufgabe 3

-- (a)

type XMLElementName = String
type XMLAttributeName = String
type XMLAttributeValue = String
type XMLTextType = String

data XMLAttribute = XMLAttribute XMLAttributeName XMLAttributeValue
  deriving Show

data XMLDoc = XMLText XMLTextType
            | XMLElement XMLElementName [XMLAttribute] [XMLDoc]
  deriving Show

-- (b)

xmlExtractText :: XMLDoc -> [String]
xmlExtractText (XMLText str) = [str]
xmlExtractText (XMLElement _ _ subDocs) = concat $ map xmlExtractText subDocs

exampleDocument = 
  XMLElement 
    "HTML"
    []
    [XMLElement 
       "HEAD"
       []
       [XMLElement 
	  "TITLE"
	  []
	  [XMLText "Testpage"]
       ]
    ,XMLElement 
       "BODY"
       []
       [XMLElement 
	  "H1"
	  []
	  [XMLText "Heading"]
       ,XMLElement
	  "P"
	  []
	  [XMLText "Hello World!"]
       ]
    ]

-- Aufgabe 4

main = 
  run $ 
  standardQuery "Matthias Neubauers Lieblingsrezept" $ 
  griessbreiPage

griessbreiPage =
  do myH2 $ text "Griessbrei ist das Beste uberhaupt!!!"
     myH3 $ text "Zutaten"
     griessbreiZutaten
     myH3 $ text "Anleitung"
     griessbreiAnleitung
     myP1 $ text "Viel Spass und Guten Appetit"
     myP2 $ text "wunscht der Matthias!"

griessbreiZutaten =
  tableWithBorder $
  mapM_ makeMyRow
        [("1 Liter", "Milch")
	,("175 Gramm", "Griess")
	,("3 Essloeffel", "Zucker")
	,("1 Priese", "Salz")
	,("1", "unbehandelte Zitrone")
	,("nach belieben", "Rosinen")
	]

griessbreiAnleitung =
  tableWithBorder $
  mapM_ makeMyRow
        [("1.", "Griess, Zucker und Salz in ein Gefaess geben")
	,("2.", "Zitrone mit kochendem Wasser abspuelen und mit Kuechentuch kraeftig abreiben")
	,("3.", "Abgeriebene Schale der Zitrone in das Gefaess geben und gut vermengen")
	,("4.", "Milch zum Kochen bringen")
	,("5.", "Mit Schneebesen unter staendigem Ruehren Inhalt des Gefaesses in die kochende Milch geben")
	,("6.", "Solange weiterruehren bis die Masse breiige Konsistenz besitzt")
	,("7.", "Rosinen hineingeben")
	,("8.", "Servieren!")
	]

makeMyRow (ammount, item) =
  tr $ do using style2 td $ text ammount
	  using style1 td $ text item

-- my elements got style

myH2 = using style3 h2
myH3 = using style4 h3
myP1 = using style4 p
myP2 = using style3 p

tableWithBorder elems = 
  table $ do attr "border" "1"
	     attr "cellpadding" "2"
	     elems

-- some nice lookin' attributes

fgRed    = "color" :=: "red"
fgYellow = "color" :=: "yellow"
fgBlue   = "color" :=: "blue"
fgGreen  = "color" :=: "green"
bgRed    = "background" :=: "red"
bgYellow = "background" :=: "yellow"
bgBlue   = "background" :=: "blue"

style1 = fgRed    :^: bgBlue
style2 = fgYellow :^: bgBlue
style3 = fgYellow :^: bgRed
style4 = fgBlue   :^: bgYellow
