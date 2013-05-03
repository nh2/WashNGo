module WASH.Dbconnect.Libpqfe where 
--  c2hs /usr/include/postgresql/libpq-fe.h Libpq-fe.chs
--  ghc 

import C2HS


{#enum ConnStatusType as ConnStatusType  {underscoreToCase} deriving (Show, Eq)#}

{#enum PostgresPollingStatusType as PostgresPollingStatusType {underscoreToCase}#}

{#enum ExecStatusType as ExecStatusType {underscoreToCase} deriving (Show, Eq)#}


--{#get PGnotify.relname#}
--{#get PGnotify.be_pid#}

mCIntToConnStatusType :: CInt -> ConnStatusType
mCIntToConnStatusType = (toEnum . fromEnum)

mCIntToExecStatusType :: CInt -> ExecStatusType
mCIntToExecStatusType = (toEnum . fromEnum)
mExecStatusTypeToCInt :: ExecStatusType -> CInt
mExecStatusTypeToCInt =  (toEnum . fromEnum)

mCIntToBool :: CInt -> Bool
mCIntToBool = (toEnum . fromEnum)

data X_PGconn = X_PGconn
data X_PQresult = X_PQresult
data X_PGresult = X_PGresult

type PGconn = Ptr X_PGconn 
type PQresult = Ptr X_PQresult
type PGresult = Ptr X_PGresult

setdbLogin = {#fun PQsetdbLogin as ^ { `String', `String', `String', `String', `String', `String', `String' } -> `PGconn' castPtr #}
pqConnectDB = {#fun PQconnectdb as ^ { `String' } -> `PGconn' castPtr #}
finish = {#call PQfinish as ^ #}


--   char *PQerrorMessage(const PGconn* conn);
-- |returns the status from the last operation of the given connection
errorMessage = {#fun PQerrorMessage as ^ { castPtr `PGconn' } -> `String' #}

--   char *PQresultErrorMessage(const PGresult *res);
-- |returns the error message associated with the query, or an empty string if there was no error.
resultErrorMessage = {#fun PQresultErrorMessage as ^ {castPtr `PGresult'} -> `String' #}

--   PGresult *PQexec(PGconn *conn,
--                    const char *query);
exec = {#fun PQexec as ^ { castPtr `PGconn', `String'} -> `PGresult' castPtr #}

--   ConnStatusType PQstatus(const PGconn *conn)
status = {#fun PQstatus as ^ { castPtr `PGconn' } -> `ConnStatusType' mCIntToConnStatusType #}

--   char *PQresStatus(ExecStatusType status);
-- |Converts the enumerated type returned by PQresultStatus into a string constant 
--describing the status code.
resStatus ={#fun pure PQresStatus as ^ { mExecStatusTypeToCInt `ExecStatusType' } -> `String' #}

-- |Returns the result status of the command given a PGresult 
resultStatus = {#fun PQresultStatus as ^ { castPtr `PGresult' } -> `ExecStatusType' mCIntToExecStatusType #}
clear = {#fun PQclear as ^ { castPtr `PGresult' } -> `()'#}


--   int PQntuples(const PGresult *res);
ntuples = {#fun PQntuples as ^ {castPtr `PGresult'} -> `Int' #}
--   int PQnfields(const PGresult *res);
nfields = {#fun PQnfields as ^ {castPtr `PGresult'} -> `Int' #}


--   char * PQcmdTuples(PGresult *res);
-- |Returns the number of rows affected by the sql-command
-- If the SQL command that generated the PGresult was INSERT, UPDATE or DELETE, this returns 
-- a string containing the number of rows affected. If the command was anything else, 
-- it returns the empty string
cmdTuples = {#fun PQcmdTuples as ^ {castPtr `PGresult'} -> `String' #}

--   char *PQfname(const PGresult *res,
--                       int field_index);
-- |Returns the column name associated with the given column number. Column numbers start at 0
fname = {#fun PQfname as ^ { castPtr `PGresult', `Int' } -> `String' #}


--   char * PQcmdStatus(PGresult *res);
-- |Returns the command status tag from the SQL command that generated the PGresult.
cmdStatus = {#fun PQcmdStatus as ^ {castPtr `PGresult'} -> `String' #}


--   int PQfnumber(const PGresult *res,
--                 const char *field_name);
fnumber = {#fun PQfnumber as ^ { castPtr `PGresult', `String' } -> `Int' #}

--   Oid PQftype(const PGresult *res,
--               int field_index);
ftype = {#call PQftype  as ^ #}

--   int PQfmod(const PGresult *res,
--              int field_index);
fmod = {#fun PQfmod as ^ { castPtr `PGresult', `Int' } -> `Int' #}
  
--   int PQfsize(const PGresult *res,
--               int field_index);
fsize = {#fun PQfsize as ^ { castPtr `PGresult', `Int' } -> `Int' #}

--   char* PQgetvalue(const PGresult *res,
--                    int tup_num,
--                    int field_num);
getValue = {#fun PQgetvalue as ^ { castPtr `PGresult', `Int', `Int' } -> `String' #}

--   int PQgetisnull(const PGresult *res,
--                   int tup_num,
--                   int field_num);
-- should be Bool
getisnull = {#fun PQgetisnull as ^ { castPtr `PGresult', `Int', `Int' } -> `Bool' mCIntToBool #}

--   int PQgetlength(const PGresult *res,
--                   int tup_num,
--                   int field_num);

getlength = {#fun PQgetlength as ^ { castPtr `PGresult', `Int', `Int' } -> `Int' fromEnum #}


--   int PQbinaryTuples(const PGresult *res);
--may be Bool?
binaryTuples = {#fun PQbinaryTuples as ^ { castPtr `PGresult' } -> `Bool' mCIntToBool #}




--   char *PQresultErrorField(const PGresult *res, int fieldcode);
-- |Returns an individual field of an error report.
resultErrorField = {#fun PQresultErrorField as ^ { castPtr `PGresult', `Int' } -> `String' #}


{-

/*
 * Identifiers of error message fields.  Kept here to keep common
 * between frontend and backend, and also to export them to libpq
 * applications.
 */
#define PG_DIAG_SEVERITY		'S'
#define PG_DIAG_SQLSTATE		'C'
#define PG_DIAG_MESSAGE_PRIMARY	'M'
#define PG_DIAG_MESSAGE_DETAIL	'D'
#define PG_DIAG_MESSAGE_HINT	'H'
#define PG_DIAG_STATEMENT_POSITION 'P'
#define PG_DIAG_CONTEXT			'W'
#define PG_DIAG_SOURCE_FILE		'F'
#define PG_DIAG_SOURCE_LINE		'L'
#define PG_DIAG_SOURCE_FUNCTION	'R'

Since enum define hooks are not implementated
-}


