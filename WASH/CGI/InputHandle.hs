-- © 2005 Peter Thiemann
{-|
  Internal use only.
  Provides access to class "InputHandle" and thus enables the construction 
  new instances of this class, which requires knowledge about programming of
  validations. 
  -} 
module WASH.CGI.InputHandle where

import WASH.CGI.CGIInternals

class HasValue i where
  -- | extract a value from various kinds of input handles
  value :: i a VALID -> a

class InputHandle h where
  -- | transforms an unvalidated input handle into either an error or a valid handle
  validate :: h INVALID -> Either [ValidationError] (h VALID)
  isBound  :: h INVALID -> Bool
  ihNames  :: h INVALID -> [String]
