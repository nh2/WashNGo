module WASH.CGI.HTTP where

import Char

data Method =
    OPTIONS
  | GET
  | HEAD
  | POST
  | PUT
  | DELETE
  | TRACE
  | CONNECT
  | Extension String
  deriving Eq

instance Show Method where
  showsPrec _ OPTIONS = showString "OPTIONS"
  showsPrec _ GET     = showString "GET"
  showsPrec _ HEAD    = showString "HEAD"
  showsPrec _ POST    = showString "POST"
  showsPrec _ PUT     = showString "PUT"
  showsPrec _ DELETE  = showString "DELETE"
  showsPrec _ TRACE   = showString "TRACE"
  showsPrec _ CONNECT = showString "CONNECT"
  showsPrec _ (Extension s) = showString s

instance Read Method where
  readsPrec _ s =
    let (token, rest) = span isAlphaNum s in
    [(
     case token of
       "OPTIONS" -> OPTIONS
       "GET" -> GET
       "HEAD" -> HEAD
       "POST" -> POST
       "PUT" -> PUT
       "DELETE" -> DELETE
       "TRACE" -> TRACE
       "CONNECT" -> CONNECT
       other -> Extension other
     , dropWhile isSpace rest)]
