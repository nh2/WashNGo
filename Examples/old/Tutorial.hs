-- © 2002 Peter Thiemann
module Main where

import WASH.CGI.CGI hiding (head, div, span, map)
import qualified WASH.CGI.CGI as CGI
import Random
import qualified WASH.CGI.Persistent2 as P
import qualified WASH.CGI.Cookie as C
import WASH.CGI.Types -- for nhc98 

main = 
  run helo0


-- 
helo0 =
  standardQuery "Select an Example" $
  activate exAction (selectSingle exName Nothing examples) empty
--  do exampleF <- selectSingle exName Nothing examples empty
--     submit exampleF dispatch (attr "value" "GO")

data Example = Example {exName :: String, exAction :: CGI ()}
instance Eq Example where
  e1 == e2 = exName e1 == exName e2
examples = 
	[Example "Simple Hello World" helo1
	,Example "Hello World with a little HTML" helo2
	,Example "Hello World with a little Color" helo4
	,Example "Hello World Personalized" helo5
	,Example "Multiplication Table" helo6
	,Example "Multiplication Drill" helo7
	,Example "Multiplication Drill with Selection Box" helo8
	,Example "Multiplication Drill with Radio Buttons" helo9
	,Example "Multiplication Drill with Email Address" helo10
	,Example "Multiplication Drill with Cookies" helo11
	]

-- 

helo1 = ask $
	standardPage "Hello" $
	text "This is my first CGI program!"

-- 
helo2 = ask $
	standardPage "Hello" $
	do p (text "This is my second CGI program!")
	   p (do text "My hobbies are"
		 ul (do li (text "swimming")
			li (text "music")
			li (text "skiing")))
-- 

fgRed = "color" :=: "red"
bgGreen = "background" :=: "green"
styleImportant = fgRed :^: bgGreen

important x = using styleImportant x

helo4 = ask $
	standardPage "Hello" $
	important p (text "This is important!")

-- 

helo5 = standardQuery "What's your name?" $
  p (do text "Hi there! What's your name?"
	activate greeting textInputField empty)

greeting :: String -> CGI ()
greeting name =
  standardQuery "Hello" $
  do text "Hello "
     text name
     text ". This is my first interactive CGI program!"

-- 

helo6 = standardQuery "What's your name?" $
  p (do text "Hi there! What's your name?"
	activate mtable textInputField empty)

mtable name =
  standardQuery "Multiplication Table" $
  do p (text "Hello " >> text name >> text "!")
     p (text "Let's see a multiplication table!")
     p (text "Give me a multiplier " >>
        activate ptable inputField empty)

ptable :: Integer -> CGI ()
ptable mpy =
  standardQuery "Multiplication Table" $
  table (mapM_ pLine [1..12])
  where
    align = attr "align" "right"
    pLine i = tr (do 
		     td (text (show i) ## align)
		     td (text "*")
		     td (text (show mpy))
		     td (text "=")
		     td (text (show (i * mpy)) ## align))

-- 

helo7 = standardQuery "What's your name?" $
  p (do text "Hi there! What's your name?"
	activate mdrill textInputField empty)

mdrill name =
  standardQuery "Multiplication" $
  do p (text "Hello ">> text name >> text "!")
     p (text "Let's exercise some multiplication!")
     mpyF <- p (text "Give me a multiplier " >>
                inputField (attr "value" "2"))
     rptF <- p (text "Number of exercises " >>
                inputField (attr "value" "10"))
     submit (F2 mpyF rptF) (firstExercise name) empty

firstExercise name (F2 mpyF rptF) = 
  runExercises 1 [] []
  where
    mpy, rpt :: Integer
    mpy = CGI.value mpyF
    rpt = CGI.value rptF
-- 
    runExercises nr successes failures =
      if nr > rpt then 
        finalReport
      else
        do factor <- io (randomRIO (0,12))
	   standardQuery ("Question " ++ show nr ++ " of " ++ show rpt) $
	     do text (show factor ++ " * " ++ show mpy ++ " = ")
		activate (checkAnswer factor) inputField empty
      where
	checkAnswer factor answer =
          let correct = answer == factor * mpy 
	      message = if correct then "correct! " else "wrong! "
	      continue F0 = if correct then 
	      		      runExercises (nr+1) (factor:successes) failures
			    else
			      runExercises (nr+1) successes (factor:failures)
	  in standardQuery ("Answer " ++ show nr ++ " of " ++ show rpt) $
	  do p (text (show factor ++ " * " ++ show mpy ++ " = " ++ show (factor * mpy)))
	     text ("Your answer " ++ show answer ++ " was " ++ message)
	     submit F0 continue (attr "value" "CONTINUE")
-- 
	finalReport =
	  let lenSucc = length successes 
	      pItem (m, l, r) = li (text ("Multiplier " ++ show m ++
	                              " : " ++ show l ++
				      " correct out of " ++ show r))
	  in
	  do initialHandle <- P.init ("multi-" ++ name) []
	     currentHandle <- P.add initialHandle (mpy, lenSucc, rpt)
	     hiScores <- P.get currentHandle
	     standardQuery "Final Report" $ 
	       do p (text "Here are your recent scores.")
		  ul (mapM_ pItem hiScores)
-- 

helo8 = standardQuery "What's your name?" $
  p (do text "Hi there! What's your name?"
	activate mdrillSelect textInputField empty)

mdrillSelect name =
  standardQuery "Multiplication" $
  do p (text "Hello ">> text name >> text "!")
     p (text "Let's exercise some multiplication!")
     mpyF <- p (text "Give me a multiplier " >>
                selectSingle show Nothing [2..12] empty)
     rptF <- p (text "Number of exercises " >>
                inputField (attr "value" "10"))
     defaultSubmit (F2 mpyF rptF) (firstExercise name) empty

-- 

helo9 = standardQuery "What's your name?" $
  p (do text "Hi there! What's your name?"
	activate mdrillRadio textInputField empty)

mdrillRadio name =
  standardQuery "Multiplication" $
  do p (text "Hello ">> text name >> text "!")
     p (text "Let's exercise some multiplication!")
     mpyF <- p (text "Give me a multiplier " >>
                selectSingle show Nothing [2..12] empty)
     rptF <- radioGroup
     p (text "Number of exercises " >>
        text " 5 " ## radioButton rptF 5 empty >>
	text " 10 " ## radioButton rptF 10 empty >>
	text " 20 " ## radioButton rptF 20 empty >>
	radioError rptF)
     submit (F2 mpyF rptF) (firstExercise name) empty

-- 

helo10 = standardQuery "What's your name?" $
  p (do text "Hi there! What's your email address?"
	activate mdrillEmail inputField empty
	-- inf <- inputField empty
	-- submit inf mdrillEmailHandle empty
	)

mdrillEmailHandle emailH =
  mdrillEmail (value emailH)
mdrillEmail email =
  let name = unEmailAddress email in
  standardQuery "Multiplication" $
  do p (text "Hello ">> text name >> text "!")
     p (text "Let's exercise some multiplication!")
     mpyF <- p (text "Give me a multiplier " >>
                selectSingle show Nothing [2..12] empty)
     rptF <- p (text "Number of exercises " >>
                inputField (attr "value" "10"))
     submit (F2 mpyF rptF) (firstExercise name) empty

-- 

helo11 = 
  C.check "name" >>= \mNameH ->
  case mNameH of
    Nothing ->
      standardQuery "What's your name?" $
        p (do text "Hi there! What's your name?"
	      activate mdrillCookie textInputField empty)
    Just nameC ->
      do mname <- C.get nameC
	 case mname of
	   Nothing ->
	     helo11					    -- retry if outdated
	   Just name ->
	     mdrill name

mdrillCookie name =
  do C.create "name" name
     mdrill name
