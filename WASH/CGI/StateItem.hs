-- © 2002 Peter Thiemann
module WASH.CGI.StateItem where

import Char

-- 
-- |type of handles to a PE of type @a@
data T a = T String Int | Tvirtual { tvirtual :: a }
instance Show (T a) where
  showsPrec _ (T s i) = showChar 'T' . shows s . shows i
  showsPrec _ (Tvirtual _) = showChar 'V'
instance Read (T a) where
  readsPrec i str = 
    case dropWhile isSpace str of
      'T' : str' ->
        [(T s i, str''') | (s, str'') <- reads str', (i, str''') <- reads str'']
      'V' : str' ->
        [(Tvirtual (error "uninitialized tvirtual"), str')]
      _ -> []
