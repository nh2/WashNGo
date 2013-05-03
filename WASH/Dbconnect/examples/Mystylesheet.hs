module Mystylesheet where

import Prelude hiding (head, map, span, div, init)

import HTMLMonad
import CGI
import Style2

import qualified Prelude as Pre(head, map, span, div)



left_and_right =
  "padding" :=:"5px"

left = left_and_right 
  :^: "border-width" :=: "thin"
  :^: "border-color" :=:"black" 
  :^: "background-color" :=: "#FFFFFF"  
  :^: "vertical-align":=: "top"
  :^: "border-style" :=: "solid"
  :^: "margin-left" :=: "0px"  
right = left_and_right 
    :^: "width" :=: "800px"
    :^: "border-style" :=: "solid"
    :^: "border-width" :=: "thin"
    :^: "vertical-align" :=: "top"
leftmenu = left

{- Style definitions for the menu -}
menu_style = "align" :=: "center"
	     :^: "text-align":=:"justify"



   


mystyles :: [Style2]
mystyles =
  ("body","background-color" :=: "rgb(207, 207, 255)"
       :^:"color" :=: "rgb(0, 0, 0)" ):
  (".datatable",   "border-color" :=:"black" 
	      :^: "border-style" :=: "solid"
	      :^: "padding" :=:"5px"
              :^: "border-width":=: "thin"
              :^: "background-color" :=:"#8080C0"
              ):
--  (".showeventlist", 
  (".showevent", "border-color" :=:"black" 
	      :^: "border-style" :=: "solid"
	      :^: "padding" :=:"5px"
              :^: "border-width":=: "thin"
              :^: "background-color" :=:"#8080C0"
              :^: "border-spacing" :=: "10px"):
  (".left",left):
  (".right",right):  
--  (".menutable", "border-color" :=:"red" 
--	      :^: "border-style" :=: "solid"
--	      :^: "padding" :=:"5px"
--              :^: "vertical-align":=:"top"):
  --("td.datatable", thStyle):   
  (".datatable th", thStyle):
  (".leftmenu",leftmenu):
  (".leftmenu input", "width":=:"140px"):
--  (".submenu td", "font-size":=:"50%"):

  ("h1", "background-color":=:"#FFFFFF"
   :^: "width" :=: "100%"
   :^: "border-width" :=: "thin"
   :^: "border-color" :=:"black" 
   :^: "border-style" :=: "solid"
   :^: "margin-bottom":=:"1px"
   :^: "margin-left" :=: "2px"
   :^: "margin-top":=:"3px"):
  ("h2",  "background-color":=:"#FFFFFF"
   :^: "width" :=: "50%"
   :^: "font-size" :=: "-1"
   :^: "border-width" :=: "thin"
   :^: "border-color" :=:"black" 
   :^: "border-style" :=: "solid"
   :^: "margin-bottom":=:"1px"
   :^: "margin-left" :=: "2px"
   :^: "margin-top":=:"3px"):
  ("h3",  --"background-color":=:"#FFFFFF"
--   :^: "width" :=: "50%"
   "font-size" :=: "-3"
   :^: "border-width" :=: "thin"
   :^: "border-color" :=:"black" 
   :^: "border-style" :=: "none"
   :^: "margin-bottom":=:"1px"
   :^: "margin-left" :=: "5px"
   :^: "margin-top":=:"3px"):[]

thStyle = "background-color" :=: "#004080" --"#44446f"
          :^: "color" :=: "#FFFFFF"
	  :^:"font-weight" :=:"normal"
tdStyle = thStyle


-- Same Style as tdStyle, but with special with
-- used by editTermin
tdwStyle = tdStyle
           :^:"width" :=: "150px"


myStyleStandardQuery :: String -> WithHTML x CGI ()-> CGI()
myStyleStandardQuery ttl elems  = do
  ask (standardCssPage ttl (makeForm elems) mystyles )

