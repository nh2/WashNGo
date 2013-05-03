-- © 2002 Peter Thiemann
module WASH.Utility.IntToString where

import Data.Char

intToString ndigits i =
  let g x = h $ divMod x 10
      h (q,r) = chr (ord '0' + fromInteger r) : g q
  in
  reverse $ take ndigits $ g i
