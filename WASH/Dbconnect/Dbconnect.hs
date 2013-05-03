-- © 2003-2004 Stefan Lack
{-|
Module to connect to a PostgreSQL Database <http://www.postgresql.org/>
  -} 
module WASH.Dbconnect.Dbconnect ( 
   -- * Connection Creation  
   DBService,
   createDBService,
   
   -- * Data Manipulation 
   execute,

   -- * Select Statements
   selectReturnTuples,
   selectReturnRow,
   selectReturnList,
   selectReturnOne,

   -- * Exceptions
   catchDB, 

   DBException (DBError, Exception), 
   ErrorType (ConnectionError, ExecuteError),

   -- * Tools
   setclause, setclausex,
   escapeQuery,
   QueryString
   )

where

import WASH.Dbconnect.Libpqfe
import Foreign


import IO
--import qualified Prelude as Pre(head, map, span, div)
import Prelude hiding (fail)
import qualified Control.Monad as C
import qualified Control.Exception as CE
import Data.Dynamic (Typeable)

type QueryString = String

-- | Specifies an Exception which may be thrown by createDBService or any of
--   the DBService functions. Use catchDB to catch this Exception in the main routine.
--   See also: @DBConnectExample@.
data DBException = 
       -- | Constructor taking the type of error and a string
       --   with a more detailed description
       DBError ErrorType String
     | Exception 
       --IOError | 
       --Exception
       deriving (Typeable, Show)

-- | Specifies the type of an error, so you can do exception
--   handling depending on the type of exception
data ErrorType =
	-- | There's something wrong with the connection: usually the connection is broken
        ConnectionError
      | -- | There's something wrong with the query: the execution returns
        --   an error
        ExecuteError
      deriving (Typeable, Show)

-- |takes a data manipulating statement (insert or update), 
--  sends it to the database and
--  returns the number of affected rows
execute :: DBService -> QueryString -> IO Int
execute = executeImp

-- |Executes a select query, returns the entire result
selectReturnTuples :: DBService -> QueryString -> IO [[String]]
selectReturnTuples = selectReturnTuplesImp

-- |Executes a select query, returns the /i/th row
selectReturnRow :: DBService -> QueryString -> Int -> IO [String]
selectReturnRow = selectReturnRowImp

-- |Executes a select query, returns a list of the first elements of each tuple,
--  the same as 
--  @do \{i <- selectReturnTuples query; return (map head i)\}@
selectReturnList :: DBService -> QueryString -> IO [String]
selectReturnList = selectReturnListImp

-- | Executes a select query, returns the first element of the
--   first row, or @\"\"@ if the result is empty.
--   Useful if the query result is a single value
selectReturnOne :: DBService -> QueryString -> IO String
selectReturnOne = selectReturnOneImp


data DBService = DBService  {

  -- |takes a data manipulating statement (insert or update), 
  --  sends it to the database and
  --  returns the number of affected rows
  executeImp:: String -> IO Int,

  -- |Executes a select query, returns the entire result
  selectReturnTuplesImp :: String -> IO [[String]],

  -- |Executes a select query, returns the /i/th row
  selectReturnRowImp :: String -> Int -> IO [String],

  -- |Executes a select query, returns a list of the firsts elements of each tuples,
  --  same as 
  --  @do \{i <- selectReturnTuples query; return (map head i)\}@
  selectReturnListImp :: String -> IO [String],

  -- | Executes a select query, returns the first element of the
  --   first row, or @\"\"@ if the result is empty.
  --   Useful if the query result is a single value
  selectReturnOneImp :: String -> IO String,

  appendLogImp :: String -> IO()
}
--   deriving (Show, Read)

-- | Create an open database handle
createDBService :: String -- ^ database server, either IP-address or servername
                -> String -- ^ name of the database to connect with
                -> String -- ^ commandline options to be sent to the server
                -> String -- ^ user name on server
                -> String -- ^ password of the user
		-> Maybe String -- ^ @Just pathname@ specifies location of logfile,
		                --   @Nothing@ selects default @\"\/tmp\/dbconnect.log\"@
                -> DBService
createDBService server database options user psword logfile=
  let 
    conn :: PGconn
    conn = unsafePerformIO (openConnection  server options  database user psword)

    -- | opens a connection to database. Whenever the connection to the database
    --   is brocken, this method will throw a 'DBError' exception
    openConnection :: String ->  String -> String ->  String ->  String ->  IO PGconn
    openConnection server options database user passwd  = 
     let
      err = "Error: unable to open connection to server: "++ server++
               " database: "++ database
     in
     do
      connh <-  setdbLogin server "" options  "" database user passwd
      status <- status connh
      if status == ConnectionOk
       then return connh
       else do
         appendLog $ "openConnection: "++ err 
         throwDB (DBError ConnectionError err)


    -- this is
    executeQuery' :: String -> IO PGresult
    executeQuery' query =  do 
	 pgres <- exec conn query
         m <- errorMessage  conn
         appendLog $ query ++"\n"
         if m == "" then return ()
	            else appendLog ("executeQuery, "++m++"\n Query was: "++query++"\n")
         return pgres
   
    
    execute' :: String -> IO Int
    execute' query =
     do res <- executeQuery' query
        tups <-cmdTuples res
        status <- resultStatus res
        if elem status  [PgresCommandOk, PgresTuplesOk]
          then do
            return $ read tups
	  else do
	    message <- resultErrorMessage res 
	    throwDB $ DBError ExecuteError message
    
    selectReturnOne' :: String -> IO String
    selectReturnOne' query =
      do res <- executeQuery' query
         tuples <- getTuples res
         clear res
         if (length  tuples)==0
          then do
           return ""
          else
           return ((tuples !! 0)!!!0)
      
    selectReturnList' :: String -> IO [String]
    selectReturnList' query =
       do res <- executeQuery' query
          tuples <- getTuples res
          clear res
          if (tuples == [[]])
           then return []
           else return (map  (head) tuples )
    
    
    selectReturnRow' :: String -> Int -> IO [String]
    selectReturnRow' query row =
      do res <- executeQuery' query
         tuples <- (getTuples res)
         clear res
         return (tuples!!row)
    
    selectReturnTuples' :: String -> IO [[String]]
    selectReturnTuples' q =
      do res <- executeQuery' q
         tuples <- getTuples res
         clear res
         return tuples

    getTuples :: PGresult -> IO [[String]]
    getTuples pgres = do
      ntup <- ntuples (castPtr pgres )
      if (ntup==0)
	 then do appendLog "getTuples: empty result \n"
		 return  [[]]
	 else do nfie <- nfields (castPtr pgres)
		 ts <-  mapM (getTuple (castPtr pgres) nfie) [0..(ntup-1)]
		 return ts

	    



    -- | Appends a string to the logfile
    appendLog :: String -> IO() 
    appendLog err =	
      let 
        logFile :: FilePath
	logFile = case logfile of
           Nothing -> "/tmp/dbconnect.log"
	   Just s  -> s
        errorLogH ::  IO Handle
        errorLogH = openFile logFile AppendMode

      in do 
       hand <- openFile logFile AppendMode
       hPutStr hand err
       hClose hand


    
  in 
  DBService { 
        appendLogImp = appendLog,
	executeImp = execute',
	selectReturnTuplesImp = selectReturnTuples',
	selectReturnRowImp = selectReturnRow',
	selectReturnListImp = selectReturnList',
	selectReturnOneImp = selectReturnOne'
	}


catchDB :: IO a -> (DBException -> IO a) -> IO a
catchDB = CE.catchDyn
throwDB :: DBException -> a
throwDB = CE.throwDyn



-- | Construct the string: @\"columname=\'value\' \"@
setclause :: String -- ^ columnname
          -> String -- ^ value
          -> String 
setclause name var = name++"='"++var++"'"

-- | Construct the string: @\"columname=\'value\',\"@
setclausex :: String -- ^ columnname
          -> String -- ^ value
          -> String 
setclausex name var = name++"='"++var++"',"



getTuple res nFiel tupNumber =
    mapM (getValue res tupNumber) [0.. (nFiel-1)]

--getField res tupNumber fieldNumber =
--    getValue res tupNumber fieldNumber

-- |Escaping a string. Useful to secure untrustworthy user input in forms
escapeQuery :: String -> String
escapeQuery s =
  foldr replace "" s

replace '\'' = ('\\' :) . ('\'' :)
replace '\\' = ('\\' :) . ('\\' :)
replace '\"' = ('\\' :) . ('\"' :)
replace x    = (x :)

-- |Takes a list /li/ of Strings and an Int /x/. Returns @/li/!!/x/@ if there is
-- an index /x/ in the list, returns @\"\"@ otherwise

(!!!) :: [String] -> Int -> String
li !!! x =
  if (elem x  [0..((length li)-1)])
  then li !! x
  else ""




-- Create a new sequenced id given a tableseqence name from the database
-- Examples : events_seq, subtitles_seq, time_location_seq
{-
getID' :: String -> IO String
getID' name = do 
  let query = "SELECT nextval('"++name++"');"
  res <-  executeQuery query
  id <- getField res 0 0
  clear res
  return (id)
-}
