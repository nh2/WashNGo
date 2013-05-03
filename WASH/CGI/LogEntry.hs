-- © 2001- 2006 Peter Thiemann
-- |Definition of the type of the redo log entries
module WASH.CGI.LogEntry where

import WASH.CGI.RawCGITypes

data PARAMETER 
  = PAR_RESULT String		-- ^ result of an IO operation shown as a string
  | PAR_VALUES CGIParameters	-- ^ record of a form input
  | PAR_MARK   String		-- ^ recorded stateID before the mark
  | PAR_IGNORED
  | PAR_TRANS  String		-- ^ recorded stateID at start of transaction
  | PAR_CRE_TV String String    -- ^ record of a @create@ or @init@ operation
  | PAR_REM_TV String	        -- ^ record of a @remove@ operation
  | PAR_GET_TV String String    -- ^ record of a @get@ operation
  | PAR_SET_TV String String	-- ^ record of a @set@ operation
  | PAR_DB     String		-- ^ record entry for all DB operations.
                                -- the string is already the result of a 
                                -- show operation for DB tuples, so it is
			        -- doubly encoded :-(

instance Show PARAMETER where
  showsPrec i par = case par of
    PAR_RESULT str -> showString ":R" . shows str
    PAR_VALUES cps -> showString ":V" . shows cps
    PAR_MARK   str -> showString ":M" . shows str
    PAR_IGNORED    -> showString ":I"
    PAR_TRANS  str -> showString ":T" . shows str
    PAR_CRE_TV n v -> showString ":C" . shows n . shows v
    PAR_REM_TV n   -> showString ":E" . shows n
    PAR_GET_TV n v -> showString ":G" . shows n . shows v
    PAR_SET_TV n v -> showString ":S" . shows n . shows v
    PAR_DB     str -> showString ":D" . shows str

instance Read PARAMETER where
  readsPrec i str = case str of
    ':' : rest -> g rest
    _  -> []
    where g ('R' : str) = [(PAR_RESULT v, rest) | (v, rest) <- reads str]
	  g ('V' : str) = [(PAR_VALUES v, rest) | (v, rest) <- reads str]
	  g ('M' : str) = [(PAR_MARK   v, rest) | (v, rest) <- reads str]
	  g ('I' : str) = [(PAR_IGNORED, str)]
	  g ('T' : str) = [(PAR_TRANS  v, rest) | (v, rest) <- reads str]
	  g ('C' : str) = [(PAR_CRE_TV n v, rest)
			  |(n, str1) <- reads str, (v, rest) <- reads str1]
	  g ('E' : str) = [(PAR_REM_TV n, rest)
			  |(n, rest) <- reads str]
	  g ('G' : str) = [(PAR_GET_TV n v, rest)
			  |(n, str1) <- reads str, (v, rest) <- reads str1]
	  g ('S' : str) = [(PAR_SET_TV n v, rest)
			  |(n, str1) <- reads str, (v, rest) <- reads str1]
	  g ('D' : str) = [(PAR_DB v, rest)     | (v, rest) <- reads str]
	  g _           = []
