module Main (
  main, 
  -- * sample Forms and Pages
  addPersonForm, askDeletePerson,
  -- * Sample accsess to database
  sampleSelect, delPerson, writePerson, details,
  -- * Helper funcions
  myTextField, myInputField,  textBackLink,
  -- * sample Styles2
  myStyleStandardQuery, mystyles
  )
where

import HTMLMonad
import CGI
import System.IO
import qualified Control.Exception as CE

import CGITypes
import AbstractSelector
import Prelude hiding (head, map, span, div, init, fail)
import qualified Prelude as Pre(head, map, span, div)
import Control.Monad
import AbstractSelector

import CGIOutput(itell)
import Dbconnect
import Style2


-- | Start function. runs sampleSelect, wraps the exception-handling functions around it
main :: IO ()
main =  
  let
    dbservice = createDBService "127.0.0.1" "ducktales" "sl" "" Nothing
  in
   catch 
     (catchDB (run $ sampleSelect dbservice) 
              (processException))
     processAllException

-- | Processing of all DBError-Execeptions
processException :: DBException  -> IO ()
processException e = case e of
  DBError  ConnectionError s ->
       itell stdout $ standardCssPage "Datenbankfehler"
	       (do (text s) 
                   br empty
                   textBackLink "Zurück" empty
                   br empty
                   (hlink (URL "javascript:location.reload()") 
                         (text "Erneut versuchen")))
               mystyles
  DBError ExecuteError s ->
       itell stdout $ standardCssPage "Datenbankfehler"
	       (do (text $ "Fehler beim Ausführen des Querys: "++ s) 
                   br empty
                   textBackLink "Zurück" empty)
                mystyles

-- |This function should process all UserError Exception, wich
-- are thrown with Control.Exception.fail. Fill in your code here
processAllException e = 
       itell stdout $ standardCssPage "Fehler"
	       ( (text $ show e) >> (br empty) >>
                 (textBackLink "Zurück" empty))
                mystyles

-- | Selects persons from the database, displays the result in a table
sampleSelect :: DBService -> CGI ()
sampleSelect db = 
  let 
    makeRow person = do
       tr  (do (mapM makeCol person)
	       td $ submit0 (askDeletePerson (person!!1) (person!!2) db)
	                    (fieldVALUE "Person entfernen")
               td $ submit0 (details (person!!1) (person!!2) db)
		            (fieldVALUE "Details"))
    makeCol item = td $ text item
  in
  do 
  persons <- io $ selectReturnTuples 
      db  
      "SELECT anrede, given_name, sur_name, email FROM persons"
  myStyleStandardQuery ("Beispielanfrage") $ do
    using (Named "datatable") table $ do
       tr  $ mapM (\item -> th ( text item))
                  ["Anrede", "Vorname", "Nachname", "EMail"]       
       mapM makeRow persons
    submit0 (addPersonForm db) (fieldVALUE "Person zufügen")


-- | Ask wether to delete a selected Person from the database or not
askDeletePerson :: String -> String ->DBService -> CGI()
askDeletePerson vorname nachname db =
  myStyleStandardQuery "Entfernen bestätigen" $ do
    text $ "Person: "++vorname++" " ++ nachname++" wirklich entfernen?"
    br empty
    submit0 (delPerson vorname nachname db) (fieldVALUE "Ja")
    submit0 (sampleSelect db) (fieldVALUE "Nein")

-- | A sample Form, Input of a new person-tuple
addPersonForm :: DBService -> CGI()
addPersonForm db=
  let userData =[]  
  in
  myStyleStandardQuery "Person zufügen" $
   table $ do 
     anrede <- tr $
	                td (text "Anrede") >>
	                td (selectSingle id (Just "" )
				 ["Herr","Frau"] empty)
     vorname <- tr $
	                   td (text "Vorname") >>
	                   td (myInputField  "20" "")
     nachname <- tr $
       td (text "Nachname") >>
       td (myInputField "20" "")
     email <- tr $
       td (text "E-Mail") >>
       td (inputField $ (attr "size" "50") >> (attr "value" ""))
     notes <- tr $ do
       td $ text "Beschreibung" 
       td $ myTextField "50" ""
     tr $ td $ submit (F5 anrede vorname nachname email notes) (writePerson db) (fieldVALUE "Speichern")
	       
-- | performs the deleting of a person tuple
delPerson ::String -> String -> DBService -> CGI()
delPerson vorname nachname db = do
  io $ execute db $ "DELETE FROM persons WHERE given_name='"++vorname++
                     "' AND sur_name='"++nachname++"'"
  sampleSelect db


-- | writes to the database: Insert a person. Demonstrate how to handle userinput.
writePerson  db (F5 anredeF vornameF nachnameF emailF notesF)  = 
  let 
      anrede = value anredeF
      vor =escapeQuery $ unNonEmpty $ value vornameF  --unNonEmpty( value vornameF)
      nach =escapeQuery $ unNonEmpty $ value nachnameF  --unNonEmpty(value nachnameF)
      email = escapeQuery $  unEmailAddress (value emailF)
      notes = value notesF
      
  in
  do io $ execute db $ "INSERT INTO persons VALUES ('"++anrede++"','"++ vor++
	           "','"++nach++"','"++ email++"','"++notes++"');"
     
     standardQuery "Add Person: Daten erfolgreich geschrieben" $ 
        submit0 (sampleSelect db)  (fieldVALUE "Weiter")



-- |Selecting one element of the table events. Note that (given_name, sur_name) is primary key of persons, thus we can use selectReturnOne here
details ::String -> String -> DBService-> CGI()
details vorname nachname db= do
  info <- io $ selectReturnOne db $ "SELECT notes FROM persons WHERE " ++
                                 "sur_name='"++nachname ++"' AND given_name='"++vorname++"';"
  myStyleStandardQuery "Details" $ do
    p $ text $ "Person : "++nachname++", "++vorname
    p $ text $ "Nähere Informationen: "++ info
    p $ textBackLink "Zurück!" empty


myTextField size value =
    textInputField (do (attr "size" size);(attr "value" value))

myInputField size value =
    inputField (do (attr "size" size);(attr "value" value))

-- |construct a javascript:back() link with the given label string
textBackLink :: Monad m => String -> HTMLCons x y m ()
textBackLink infoS attrs =
  hlink (URL "javascript:back()") (text infoS >> attrs)


-- |Sample Stylesheet definition
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
  (".datatable th", thStyle):[]

thStyle = "background-color" :=: "#004080" --"#44446f"
          :^: "color" :=: "#FFFFFF"
	  :^:"font-weight" :=:"normal"

-- |page that uses the style \'mystyles\'
myStyleStandardQuery :: String -> WithHTML x CGI ()-> CGI()
myStyleStandardQuery ttl elems  = do
  ask (standardCssPage ttl (makeForm elems) mystyles )


