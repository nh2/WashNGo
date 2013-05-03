module WASH.CGI.MakeTypedName where

import WASH.CGI.Types

import WASH.Utility.SHA1
import qualified WASH.Utility.Base32 as Base32

-- |Create a probabilistically unique filename from a name and a type
-- descriptor. 
makeTypedName :: String -> TySpec -> String
makeTypedName s tys = 
  Base32.encode (sha1 s) ++ '-' : Base32.encode (sha1 (tid tys ""))

-- |Create a probabilistically unique filename from a name and the type of a given value. 
makeTypedNameFromVal :: Types a => String -> a -> String
makeTypedNameFromVal name val =
  makeTypedName name (ty val)
