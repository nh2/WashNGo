-- © 2002-2005 Peter Thiemann
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

helo1 = standardQuery "Hello" 
        <#>This is my first CGI program!</#>

-- 
helo2 = standardQuery "Hello" $
    do <p>This is my second CGI program!</p>
       <p>My hobbies are
	 <ul><li>swimming</li>
	     <li>music</li>
	     <li>skiing</li>
	 </ul>
       </p>
-- 

fgRed = "color" :=: "red"
bgGreen = "background" :=: "green"
styleImportant = fgRed :^: bgGreen

important x = using styleImportant x

helo4 = standardQuery "Hello" $
	important p (text "This is important!")

-- 

helo5 = standardQuery "What's your name?" $
  <p>Hi there! What's your name?
    <% activate greeting textInputField empty %>
  </p>

greeting :: String -> CGI ()
greeting name =
  standardQuery "Hello" $
  <#>Hello <%= name %>. This is my first interactive CGI program!</#>

-- 

helo6 = standardQuery "What's your name?" $
  <p>Hi there! What's your name?
    <% activate mtable textInputField empty %>
  </p>

mtable name =
  standardQuery "Multiplication Table" $
  do <p>Hello <%= name %>!</p>
     <p>Let's see a multiplication table!</p>
     <p>Give me a multiplier 
        <% activate ptable inputField empty %>
     </p>

ptable :: Integer -> CGI ()
ptable mpy =
  standardQuery "Multiplication Table" $
  <table><% mapM_ pLine [1..12] %></table>
  where
    pLine i = 
      <tr>
	<td align="right"><%= i %></td>
	<td>*</td>
	<td><%= mpy %></td>
	<td>=</td>
	<td align="right"><%= (i * mpy) %></td>
      </tr>

-- 

helo7 = standardQuery "What's your name?" $
  <p>Hi there! What's your name?
    <% activate mdrill textInputField empty %>
  </p>

mdrill name =
  standardQuery "Multiplication" $
  <#>
    <p>Hello <%= name %>!</p>
    <p>Let's exercise some multiplication!</p>
    <p>Give me a multiplier 
      <input type="text" value="2" name="mpyF" />
    </p>
    <p>Number of exercises 
      <input type="text" value="10" name="rptF" />
    </p>
    <input type="submit" value="GO!"
	   WASH:callback="firstExercise name" WASH:parms="mpyF,rptF" />
  </#>

firstExercise :: String -> (Int, Int) -> CGI ()
firstExercise name (mpy, rpt) = 
  runExercises 1 [] []
  where
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
  <#>
    <p>Hello <%= name %>!</p>
    <p>Let's exercise some multiplication!</p>
    <p>Give me a multiplier 
      <% mpyF <- selectSingle show Nothing [2..12] empty %>
    </p>
    <p>Number of exercises 
      <input type="text" value="10" name="rptF" />
    </p>
    <input type="submit" value="GO!"
	   WASH:callback="firstExercise name" WASH:parms="mpyF,rptF" />
  </#>

-- 

helo9 = standardQuery "What's your name?" $
  p (do text "Hi there! What's your name?"
	activate mdrillRadio textInputField empty)

mdrillRadio name =
  standardQuery "Multiplication" $
  <#>
    <p>Hello <%= name %>!</p>
    <p>Let's exercise some multiplication!</p>
    <p>Give me a multiplier 
      <% mpyF <- selectSingle show Nothing [2..12] empty %>
    </p>
    <% rptF <- radioGroup %>
    <p>Number of exercises 
      5  <% radioButton rptF 5 empty %>
      10 <% radioButton rptF 10 empty %>
      20 <% radioButton rptF 20 empty %>
      <% radioError rptF %>
    </p>
    <input type="submit" value="GO!"
	   WASH:callback="firstExercise name" WASH:parms="mpyF,rptF" />
  </#>

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
  <#>
    <p>Hello <%= name %>!</p>
    <p>Let's exercise some multiplication!</p>
    <p>Give me a multiplier 
      <% mpyF <- selectSingle show Nothing [2..12] empty %>
    </p>
    <p>Number of exercises 
      <input type="text" value="10" name="rptF" />
    </p>
    <input type="submit" value="GO!"
	   WASH:callback="firstExercise name" WASH:parms="mpyF,rptF" />
  </#>

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
