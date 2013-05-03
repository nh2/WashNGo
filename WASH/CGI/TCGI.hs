-- © 2006 Peter Thiemann
{- | Wrapper for the WASH.CGI.CGI monad type. Internal use only. Intended for
-- wrapping transactions. 
-}

module WASH.CGI.TCGI where

import WASH.CGI.CGIMonad

-- |Type of a 'CGI' action in a transactional scope with a result variable of
-- type @a@.
newtype TCGI b a =
  TCGI { unTCGI :: CGIAction a }

outof :: TCGI b a -> CGI a
outof = CGI . unTCGI

into :: CGI a -> TCGI b a
into = TCGI . unCGI 

instance Monad (TCGI b) where
  return x = 
    into (return x)
  m >>=  f = 
    into (outof m >>= (outof . f))

instance CGIMonad (TCGI b) where
  wrapCGI = TCGI
  unwrapCGI = unTCGI
  chooser x y = return y

