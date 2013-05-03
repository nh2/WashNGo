-- © 2001, 2002, 2003 Peter Thiemann
-- |creating, setting, reading, and deleting cookies. Cookies are type-indexed,
-- i.e., there is a different cookie for each name and type.
module WASH.CGI.Cookie (T, check, create, createExpiring, init, initExpiring, get, set, current, delete) where

import Data.Maybe (fromJust)
import System.Locale
import Prelude hiding (init)
import System.Random
import System.Time

import WASH.CGI.BaseCombinators
import WASH.CGI.CGIMonad
import WASH.HTML.HTMLMonad hiding (head, div, map, span)
import WASH.CGI.Types

import WASH.CGI.StateItem

-- |@check name@ returns the current handle to cookie @name@ if that exists.
check :: (Read a, Show a, Types a) => String -> CGI (Maybe (T a))
-- |@create name initValue@ creates cookie @name@ with initial value @initValue@
-- and returns its current handle. The cookie
-- expires at the end of the current run of the browser.
create  :: (Read a, Show a, Types a) => String -> a -> CGI (T a)
-- |like 'create' with additional parameter specifying number of minutes until
-- cookie expires.
createExpiring  :: (Read a, Show a, Types a) => String -> Int -> a -> CGI (T a)
-- |@init name initValue@ returns current handle to cookie @name@. If the
-- cookie did not exist before, it is created and set to @initialValue@. The cookie
-- expires at the end of the current run of the browser.
init    :: (Read a, Show a, Types a) => String -> a -> CGI (T a)
-- |@initExpiring name minutes initValue@ works like 'init' except that the
-- expiration time is @minutes@ in the future.
initExpiring :: (Read a, Show a, Types a) => String -> Int -> a -> CGI (T a)
-- |@get handle@ returns the cookie's value if the handle is current, otherwise
-- returns 'Nothing' 
get     :: (Read a, Show a, Types a) => T a -> CGI (Maybe a)
-- |@set handle newValue@ overwrites the cookie's value with @newValue@ if the
-- handle is current. In that case it returns a handle which is current for
-- @newValue@. Otherwise, the result is 'Nothing'.
set     :: (Read a, Show a, Types a) => T a -> a -> CGI (Maybe (T a))
-- |@current handle@ returns @Nothing@ if @handle@ is still current. Otherwise, it
-- returns @Just newHandle@ where @newHandle@ is current for the cookie pointed to by
-- @handle@.
current :: (Read a, Show a, Types a) => T a -> CGI (Maybe (T a))
-- |@delete handle@ removes the cookie determined by @handle@.
delete  :: (Types a) => T a -> CGI ()
-- 


data P a = P { nr :: Int, vl :: a }
  deriving (Read, Show)

t :: String -> P a -> T a
t name (P i a) = T name i

check name =
  once (unsafe_getHandle name)

unsafe_getHandle name =
  CGI (\cgistate ->
    let mresult = fmap (t name) $ cookieLookup cgistate typedName
	myTyspec = ty (tvirtual (fromJust mresult))
	typedName = makeTypedName name myTyspec
    in 
    return (mresult, cgistate))   

create name val = 
  once (unsafe_init False name val Nothing)

createExpiring name minutes val =
  once $ do timestr <- unsafe_io $ getTimeString minutes
	    unsafe_init False name val (Just timestr)

initExpiring name minutes val =
  once $ do timestr <- unsafe_io $ getTimeString minutes
	    unsafe_init True name val (Just timestr)

init name val = 
  once (unsafe_init True name val Nothing)

unsafe_init useExisting name val mexp =
  CGI (\cgistate ->
     case cookieLookup cgistate typedName of
     -- if name present and existing value is to be used
     -- then construct handle from map entry
       Just pair | useExisting ->
         return (t name pair, cgistate)
       _ -> 
     -- extend cookie map with name=val
	 do nonce <- randomIO
	    let p0val = P nonce val
		cm' = (typedName, (Just (show p0val), mexp)) : cookieMap cgistate
     -- register cookie for sending
                cts' = typedName : cookiesToSend cgistate
     -- construct handle
	    return (t name p0val,
		    cgistate { cookieMap = cm'
			     , cookiesToSend = cts'
			     }))
  where myTyspec = ty val
	typedName = makeTypedName name myTyspec
  
get handle =
  once (do eitherTP <- unsafe_get_current handle
	   return $ either (const Nothing) Just eitherTP)

current handle =
  once (do eitherTP <- unsafe_get_current handle
	   return $ either Just (const Nothing) eitherTP)  

unsafe_get_current :: (Types a, Read a, Show a) => T a -> CGI (Either (T a) a)
unsafe_get_current t@(T name i) =
  CGI (\cgistate ->
     case cookieLookup cgistate typedName of
     -- if name present and types match then construct handle from map entry
       (Just pair)
         | nr pair == i ->
	   return (Right $ vl pair, cgistate)
	 | otherwise ->
	   return (Left $ T name (nr pair), cgistate)
       _ -> 
	 reportError "Cookie disappeared" 
	   (do let cm = cookieMap cgistate
		   mms = lookup typedName cm
		   mmp = if True then fmap (fmap reads . fst) mms 
		                 else Just (Just [(P 0 $ tvirtual t, "")])
	       pre $ text $ ("  " ++ typedName)
	       pre $ text $ show cm
	       pre $ text $ show mms
	       pre $ text $ show mmp)
	   cgistate)
  where myTyspec = ty (tvirtual t)
	typedName = makeTypedName name myTyspec

set handle val =
  once (unsafe_set handle val)

unsafe_set (T name i) val =
  CGI (\cgistate ->
    case cookieLookup cgistate typedName of
      (Just pair) | nr pair == i ->
        do nonce <- randomIO
	   let pair' = if True then P nonce val else pair    -- to unify their types
	       cts = cookiesToSend cgistate
	       cts' = if typedName `elem` cts then cts else typedName : cts
	       cm' = (typedName, (Just (show pair'), Nothing)) :
		     [ entry | entry@(aName, _) <- cookieMap cgistate
			     , aName /= typedName ]
	   return (Just (t name pair'),
		   cgistate { cookieMap = cm'
			    , cookiesToSend = cts'
			    })
      _ -> return (Nothing, cgistate))
  where myTyspec = ty val
	typedName = makeTypedName name myTyspec

delete t = 
  once (unsafe_delete t)

unsafe_delete t@(T name i) =
  CGI (\cgistate ->
       let  cts = cookiesToSend cgistate
	    cts' = if typedName `elem` cts then cts else typedName : cts
       in return ( ()
	         , cgistate { cookieMap = (typedName, (Nothing, Nothing))
		 			  : cookieMap cgistate
		            , cookiesToSend = cts'
			    }))
  where myTyspec = ty (tvirtual t)
	typedName = makeTypedName name myTyspec

cookieLookup :: (Show a, Read a) => CGIState -> String -> Maybe (P a)
cookieLookup cgistate typedName =
  let cm = cookieMap cgistate
      fn = lookup typedName cm		    -- Maybe (Maybe String, Maybe String)
      cn = fmap (fmap reads . fst) fn	    -- Maybe (Maybe [(P a, String)])
      checkType [] = 
        Nothing
      checkType ((pair,_):_) =
        Just pair
  in  cn >>= \mtp -> mtp >>= checkType

makeTypedName :: String -> TySpec -> String
makeTypedName s tys = s ++ '-' : tid tys ""

-- 

getTimeString :: Int -> IO String
getTimeString minutes =
  do now <- getClockTime
     let expireAt = addToClockTime TimeDiff {tdYear = 0,
	 				     tdMonth = 0,
					     tdDay = 0,
					     tdHour = 0,
					     tdMin = minutes,
					     tdSec = 0,
					     tdPicosec = 0} now
	 -- Wdy, DD-Mon-YYYY HH:MM:SS GMT
	 fmt = "%a, %d-%b-%Y %H:%M:%S GMT"
	 loc = defaultTimeLocale
     return $ formatCalendarTime loc fmt (toUTCTime expireAt)
