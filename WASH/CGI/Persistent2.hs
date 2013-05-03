-- © 2001, 2002, 2003 Peter Thiemann
{-|This is the preferred, type-indexed implementation of server-side state.

Glossary

A persistent entity (PE) is a time-indexed, named global value.
The current value of a PE is the value that the PE has now.
A handle gives access to a snapshot of a persistent entity at a particular time, potentially in the past.
A handle is /current/ if the value of the PE has not been @set@ or @add@ed to after the creation of the handle.
-}

module WASH.CGI.Persistent2 (T, init, get, set, add, current) where

import WASH.CGI.CGIConfig

import System
import Prelude hiding (init)
import qualified Prelude (init)
import List hiding (init)
import qualified List (init)
import Maybe
import IO
import Directory
import Monad
import Random

import WASH.Utility.Auxiliary
import WASH.CGI.CGI hiding (head, div, span, map)
import WASH.CGI.BaseCombinators (unsafe_io)
import WASH.CGI.Types
import qualified WASH.Utility.Locking as L

import WASH.CGI.StateItem
import WASH.CGI.MakeTypedName


-- |@init name initialValue@ creates a new PE with name @name@ with initial
-- value @initialValue@ and returns the handle to the initial value. If the PE
-- already exists, then @init@ returns the handle to the current value.
init    :: (Read a, Show a, Types a) => String -> a -> CGI (T a)
-- |@get handle@ retrieves the value of @handle@. This value may not be current
-- because the handle may point to a snapshot from the past.
get     :: (Read a, Types a) => T a -> CGI a
-- |@set handle newValue@ tries to overwrite the value of the pe pointed to by
-- @handle@ with @newValue@. Succeeds @Just handle1@ if @handle@ is current, in
-- this case it returns a handle to the new value. Fails @Nothing@ if the handle
-- is not current. 
set     :: (Read a, Show a, Types a) => T a -> a -> CGI (Maybe (T a))
-- |@add handle addValue@ conceptually, this operation adds @addValue@ to the
-- set of values stored in @handle@. Since this set is represented as a list,
-- @handle@ must point to a value of type @[a]@. Since the PE is assumed to
-- contain a set, it does not matter if @handle@ is current. However, the
-- returned handle is guaranteed to be current with a value that contains
-- @addValue@.
add     :: (Read a, Show a, Types a) => T [a] -> a -> CGI (T [a])
-- |@current handle@ returns a handle to the PE pointed to by
-- @handle@. It returns @Nothing@ if @handle@ is still /current/. Otherwise, it
-- returns @Just newHandle@ where @newHandle@ is /current/ in the sense defined
-- above. Using the @newHandle@ obtained from @current@ explicitly discards the
-- value pointed to by @handle@ in favor of a value that may have been stored
-- by a concurrently executing script. Use with caution!
current :: (Read a, Types a) => T a -> CGI (Maybe (T a))
-- 


data P a = P { nr :: Int, vl :: a }
  deriving (Read, Show)

t :: String -> P a -> T a
t name (P i a) = T name i

traceInit =
  -- writeDebugFile (persistent2Dir ++ "TRACE") "" >>
  return ()
trace s = 
  -- appendFile (persistent2Dir ++ "TRACE") (s ++ "\n") >>
  return ()

init name val = do
  unsafe_io $
     assertDirectoryExists (List.init persistent2Dir) (return ())
  io $ catch (
     do traceInit
	trace ("P2: init " ++  name ++ " " ++ show val)
	trace ("P2: ty = " ++ show myTyspec)
	trace ("P2: tid ty = " ++ tid myTyspec "")
	trace ("P2: typedName = " ++ typedName)
	trace ("P2: fileName = " ++ show fileName)
	L.obtainLock fileName
	trace ("P2.init: after obtainLock ")
	contents <- readFileStrictly fileName
	trace ("P2.init: after readFileStrictly " ++ contents)
	L.releaseLock fileName
	trace ("P2.init: after releaseLock[1] " ++ contents)
	pairs <- return $ read contents
	return $ t name $ head $ pairs
     )
     $ \ ioError ->
     do trace ("P2.init: ioError caught")
	nonce <- randomIO
	let initialP = P nonce val
	writeFile fileName (show [initialP])
	trace ("P2.init: writing " ++ show [initialP])
	L.releaseLock fileName
	return (t name initialP)
  where
    fileName = persistent2Dir ++ typedName
    myTyspec = ty val
    typedName = makeTypedName name myTyspec

get tn@(T name i) =
  unsafe_io $
  do trace ("P2: get " ++ name ++ " " ++ show i)
     L.obtainLock fileName
     contents <- readFileStrictly fileName
     L.releaseLock fileName
     trace ("P2.get: fileName = " ++ show fileName)
     pairs <- return $ read contents
     return $ vl $ fromJust $ find ((== i) . nr) pairs
  where
    typedName = makeTypedNameFromVal name (tvirtual tn)
    fileName = persistent2Dir ++ typedName

set (T name i) val =
  io $
  do trace ("P2: set " ++ name ++ " " ++ show i ++ " " ++ show val)
     L.obtainLock fileName
     contents <- readFileStrictly fileName
     pairs <- return $ read contents
     i' <- randomIO
     if nr (head pairs) == i
       then do writeFile fileName (show (P i' val : take 15 pairs))
	       L.releaseLock fileName
	       return (Just (T name i'))
       else do L.releaseLock fileName
	       return Nothing
  where
    typedName = makeTypedNameFromVal name val
    fileName = persistent2Dir ++ typedName

add (T name _) val =
  io $
  do trace ("P2: add " ++ name ++ " " ++ show val)
     L.obtainLock fileName
     contents <- readFileStrictly fileName
     pairs <- return $ read contents
     let P i vals = head pairs
     i' <- randomIO
     writeFile fileName (show (P i' (val : vals) : take 15 pairs))
     L.releaseLock fileName
     return (T name i')
  where
    typedName = makeTypedNameFromVal name [val]
    fileName = persistent2Dir ++ typedName

current tn@(T name i) =
  io $
  do trace ("P2: current " ++ name ++ " " ++ show i)
     L.obtainLock fileName
     contents <- readFileStrictly fileName
     L.releaseLock fileName
     pairs <- return $ read contents
     let P i' vals = head pairs
     if i==i'
       then return Nothing
       else return (Just (t name (head pairs)))
  where
    typedName = makeTypedNameFromVal name (tvirtual tn)
    fileName = persistent2Dir ++ typedName

