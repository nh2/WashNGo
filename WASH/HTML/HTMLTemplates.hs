module WASH.HTML.HTMLTemplates where

import WASH.HTML.HTMLBase
import WASH.Utility.SHA1
import WASH.Utility.JavaScript
import qualified WASH.Utility.Base32 as Base32

import Control.Monad (unless)
import Data.List ((\\))

data ST s a =  ST { unST :: s -> (a, s) }
instance Monad (ST s) where
  return x = ST (\s -> (x, s))
  m >>= f  = ST (\s -> let (x', s') = unST m s
		       in  unST (f x') s')

runST :: s -> ST s a -> a
runST s m = fst (unST m s)

getST :: ST s s
getST = ST (\s -> (s, s))

setST :: s -> ST s ()
setST s = ST (const ((), s))

data Names = Names { ntable :: [(String, Int)], nseen :: [Int] }

----------------------------------------------------------------------
-- template generation
----------------------------------------------------------------------
showTemplatified :: ELEMENT_ -> ShowS
showTemplatified = showTemplate . analyze

showTemplate :: (Template, Mt) -> ShowS
showTemplate (tis, mt) =
  let ts = closed mt
      ndefs = length ts 
      at = actuals mt
      st = buildStringTableArgs at
      cst = cleanupStringTable ndefs st
      shownargs = runST (Names { ntable = cst, nseen = [] })
			(showActualArgs at)
  in
  showDefinitions ndefs ts .
  showString "<script name=\"BODY\">\n" .
  -- showStringTable cst .
  showString "S(" . shownargs . showString ",document)" .
  showString "\n</script>\n"

showDefinitions n [] =
  let scriptName = "STRINGBASE"
  in
  showString "<script name=\"" . showString scriptName . showString "\">\n" .
  showString "function S (template, out) {\n" .
  showString "  var ty = typeof template;\n" .
  showString "  if (ty == \"string\") out.write (template);\n" .
  showString "  else if (ty == \"object\")\n" .
  showString "    for (var i = 0; i<template.length; i++)\n" .
  showString "      S (template[i], out);\n" .
  showString "}\n" .
  showString "</script>\n"
    
showDefinitions n ((scriptName, (nr, nformals, t1)) :ts) =
  showString "<script name=\"" . showString scriptName . showString "\">\n" .
  (if nformals==0 then showString "var " else showString "function ") . showsIdent n . 
  (if nformals==0 then showString "=" else showString "(" . showFormals nformals . showString ")" .
  showString "{return") .
  showString "[" .
  showBody t1 .
  showString "]" .
  (if nformals==0 then id else showString "}\n") .
  showString "</script>\n" .
  showDefinitions (n-1) ts

showsIdent n = showString (identlist !! n)

charlist = (['A'..'Z'] ++ ['a'..'z'])
alphanumlist = ['0'..'9'] ++ charlist

identlist = ([ [c] | c <- charlist ]
	 ++ [ [c,d] | c <- charlist, d <- alphanumlist ])
	 \\ ["S","o","v"]

  
showBody [] = 
  id
showBody [ti] =
  showStatement ti
showBody (ti:tis) =
  showBody tis .
  showString "," .
  showStatement ti

showStatement (TOut str) =
  showString (jsShow str)
showStatement (TVar n) =
  showsIdent n
showStatement (TCall fname args) =
  error "this should not happen"

showFormals 0 =
  id
showFormals n =
  (if n>1 then showFormals (n-1) . showString "," else id) .
  showsIdent n

showActual (TOut str) =
  do names <- getST
     let cst = ntable names
	 seen = nseen names
     case lookup str cst of
       Nothing ->
	 return $ showString (jsShow str)
       Just strident ->
	 if strident `elem` seen
	 then return $ showsIdent strident
	 else
           do setST (names { nseen = strident : seen })
	      return $
		(showsIdent strident . showChar '=' . showString (jsShow str))
showActual (TVar n) =
  error "this should not happen"
showActual (TCall fname []) =
  return $ showsIdent fname
showActual (TCall fname args) =
  do saa <- showActualArgs args
     return (showsIdent fname . showString "(" .
	     saa .
	     showString ")")

showActualArgs [] = 
  return id
showActualArgs [arg] =
  showActualArg arg
showActualArgs (arg: args) =
  do x1 <- showActualArgs args
     x2 <- showActualArg arg
     return (x1 . showString "," . x2)

showActualArg [x] =
  showActual x
showActualArg xs = 
  do hxs <- h xs
     return (showString "[" . hxs . showString "]")
  where 
    h [] = return id
    h [x] = showActual x
    h (x:xs) = do sax <- showActual x
		  hxs <- h xs
		  return (sax . showChar ',' . hxs)

showStringTable =
  foldr g id
  where
    g (str, n) showrest =
      showString "var " . showsIdent n . showString "=" . showString (jsShow str) .
      showString ";\n" . showrest

cleanupStringTable ndefs st =
  zip [str | (str, n) <- st, n > 3 || length str > 2 && n > 1]
      [(ndefs+1) ..]
unite st1 st2 =
  foldr g st1 st2
  where g p@(str,i) st1 =
	  case lookup str st1 of
	    Nothing -> p:st1
	    Just j -> (str, i+j):[ p | (p@(str',_)) <- st1, str' /= str ]
buildStringTableArgs = 
  foldr unite [] . map buildStringTableArg
buildStringTableArg =
  foldr unite [] . map buildStringTableActual
buildStringTableActual (TOut str) =
  [(str, 1)]
buildStringTableActual (TVar n) =
  error "this should not happen"
buildStringTableActual (TCall fname args) =
  buildStringTableArgs args
	  
----------------------------------------------------------------------
-- template analysis
----------------------------------------------------------------------

analyze :: ELEMENT_ -> (Template, Mt)
analyze e = unM (collect e STATIC []) mt0

data Mt = Mt
    { open :: Templates
    , closed :: [(String, (Int, Int, Template))]
    , dynamics :: [Templates]
    , actuals :: Templates
    , count :: Int
    }
    deriving Show

mt0 = Mt { open = []
	 , closed = []
	 , dynamics = []
	 , actuals = []
	 , count = 0
	 }

type Templates = [Template]

type Template = [TemplateItem]

data TemplateItem
  = TOut String
  | TVar Int
  | TCall Int [Template]
  deriving Show

tout :: String -> [TemplateItem] -> [TemplateItem]
tout s (TOut s' : rest) = (TOut (s'++s) : rest) 
tout s tis = TOut s : tis

data M a = M { unM :: Mt -> (a, Mt) }

instance Monad M where
  return a = M (\t -> (a, t))
  m >>= f  = M (\t -> let (a,t') = unM m t in unM (f a) t')

pushOpen :: Template -> M ()
pushOpen t = M (\mt -> ((), mt { open = t : open mt
			       , dynamics = actuals mt : dynamics mt 
			       , actuals = []
			       } ))
popOpen :: M Template
popOpen = M (\mt -> (head (open mt), mt { open = tail (open mt)
					, actuals = head (dynamics mt)
					, dynamics = tail (dynamics mt)
					}))

pushClosed :: Template -> M Int
pushClosed tis = 
  M (\mt -> 
     let defs = closed mt 
	 name = Base32.encode (sha1 (show tis)) 
     in
     case lookup name defs of
       Nothing ->
	 let next = length (closed mt) + 1 in
	 (next, mt { closed = (name, (next, length (actuals mt), tis)) : defs })
       Just (last, nargs, _) ->
	 (last, mt))

pushActuals :: Template -> M Int
pushActuals tis = 
  M (\mt -> (length (actuals mt) + 1, mt { actuals = tis : actuals mt }))

getActuals :: M Templates
getActuals = M (\mt -> (actuals mt, mt))

get :: (Mt -> x) -> M x
get f = M (\mt -> (f mt, mt))

mergeActuals :: Template -> M ()
mergeActuals tis =
  M (\mt -> 
     let act0 : acts = actuals mt in
     ((), mt { actuals = (act0 ++ tis) : actuals mt }))

maybePushActuals :: Template -> Template -> M Template
maybePushActuals cur tis =
  case cur of
    TVar _ : _ ->
      do mergeActuals tis
	 return cur
    _ ->
      do vname <- pushActuals tis
	 return (TVar vname : cur)

-- |collect takes an element, a list of open templates, a list of finished
-- templates, and returns a pair (open templates, finished templates).
collect :: ELEMENT_ -> BT -> Template -> M Template
collect (EMPTY_ bt tag atts) cbt cur =
  let t1 = TOut ('<' : tag)
      t2 = tout "/>"
  in
  case bt of 
    TOPLEVEL -> 
      do pushOpen cur
	 ts <- collectAttrs atts STATIC [t1]
	 fname <- pushClosed (t2 ts)
	 parms <- get actuals
	 cur' <- popOpen
	 maybePushActuals cur' [TCall fname parms]
    DYNAMIC ->
      case cbt of
	STATIC ->
	  do ts <- collectAttrs atts DYNAMIC [t1]
	     maybePushActuals cur (t2 ts)
	DYNAMIC ->
	  do ts <- collectAttrs atts DYNAMIC (t1 : cur)
	     return (t2 ts)
    STATIC ->
      case cbt of
	STATIC ->
	  do ts <- collectAttrs atts STATIC (t1 : cur)
	     return (t2 ts)
	DYNAMIC ->
	  do pushOpen cur
	     ts <- collectAttrs atts STATIC [t1]
	     fname <- pushClosed (t2 ts)
	     parms <- get actuals
	     cur' <- popOpen
	     maybePushActuals cur' [TCall fname parms]

collect (ELEMENT_ bt tag atts elems) cbt cur =
  let t1 = TOut ('<' : tag)
      t1' = tout ('<' : tag)
      t2 = tout ">"
      t3 = tout ("</" ++ tag ++ ">")
  in
  case bt of 
    TOPLEVEL -> 
      do pushOpen cur
	 ts1 <- collectAttrs atts STATIC [t1]
	 ts2 <- collectElems elems STATIC (t2 ts1)
	 fname <- pushClosed (t3 ts2)
	 parms <- get actuals
	 cur' <- popOpen
	 maybePushActuals cur' [TCall fname parms]
    DYNAMIC ->
      case cbt of
	STATIC ->
	  do ts1 <- collectAttrs atts DYNAMIC [t1]
	     ts2 <- collectElems elems DYNAMIC (t2 ts1)
	     maybePushActuals cur (t3 ts2)
	DYNAMIC ->
	  do ts1 <- collectAttrs atts DYNAMIC (t1' cur)
	     ts2 <- collectElems elems DYNAMIC (t2 ts1)
	     return (t3 ts2)
    STATIC ->
      case cbt of
	STATIC ->
	  do ts1 <- collectAttrs atts STATIC (t1' cur)
	     ts2 <- collectElems elems STATIC (t2 ts1)
	     return (t3 ts2)
	DYNAMIC ->
	  do pushOpen cur
	     ts1 <- collectAttrs atts STATIC [t1]
	     ts2 <- collectElems elems STATIC (t2 ts1)
	     fname <- pushClosed (t3 ts2)
	     parms <- get actuals
	     cur' <- popOpen
	     maybePushActuals cur' [TCall fname parms]

collect (DOCTYPE_ bt strs elems) cbt cur =
  let t1 = TOut ("<!DOCTYPE" ++
		 (foldr (\str f -> showChar ' ' . showString str . f) id strs .
		  showString ">")
		 "<!-- generated by WASH/HTML 0.11\n-->")
  in
  case bt of 
    TOPLEVEL -> 
      do pushOpen cur
	 ts2 <- collectElems elems STATIC [t1]
	 fname <- pushClosed ts2
	 parms <- get actuals
	 cur' <- popOpen
	 maybePushActuals cur' [TCall fname parms]
    DYNAMIC ->
      case cbt of
	STATIC ->
	  do ts2 <- collectElems elems DYNAMIC [t1]
	     maybePushActuals cur ts2
	DYNAMIC ->
	  do collectElems elems DYNAMIC (t1 : cur)
    STATIC ->
      case cbt of
	STATIC ->
	  do collectElems elems STATIC (t1 : cur)
	DYNAMIC ->
	  do pushOpen cur
	     ts2 <- collectElems elems STATIC [t1]
	     fname <- pushClosed ts2
	     parms <- get actuals
	     cur' <- popOpen
	     maybePushActuals cur' [TCall fname parms]

collect (CDATA_ bt str) cbt cur =
  let t0 = TOut str
      t0' = tout str in
  case bt of 
    TOPLEVEL -> 
      do pushOpen cur
	 fname <- pushClosed [t0]
	 parms <- get actuals
	 cur' <- popOpen
	 maybePushActuals cur' [TCall fname parms]
    DYNAMIC ->
      case cbt of
	STATIC ->
	  do maybePushActuals cur [t0]
	DYNAMIC ->
	  do return [t0]
    STATIC ->
      case cbt of
	STATIC ->
	  do return (t0' cur)
	DYNAMIC ->
	  do pushOpen cur
	     fname <- pushClosed [t0]
	     parms <- get actuals
	     cur' <- popOpen
	     maybePushActuals cur' [TCall fname parms]

collect (COMMENT_ bt str) cbt cur =
  let t0 = TOut str
      t0' = tout str in
  case bt of 
    TOPLEVEL -> 
      do pushOpen cur
	 fname <- pushClosed [t0]
	 parms <- get actuals
	 cur' <- popOpen
	 maybePushActuals cur' [TCall fname parms]
    DYNAMIC ->
      case cbt of
	STATIC ->
	  do maybePushActuals cur [t0]
	DYNAMIC ->
	  do return [t0]
    STATIC ->
      case cbt of
	STATIC ->
	  do return (t0' cur)
	DYNAMIC ->
	  do pushOpen cur
	     fname <- pushClosed [t0]
	     parms <- get actuals
	     cur' <- popOpen
	     maybePushActuals cur' [TCall fname parms]

collectElems [] cbt cur =
  return cur
collectElems (at:ats) cbt cur =
  do ts <- collectElems ats cbt cur
     collect at cbt ts

collectAttrs [] cbt cur =
  return cur
collectAttrs (at:ats) cbt cur =
  do ts <- collectAttr at cbt cur
     collectAttrs ats cbt ts

collectAttr
  ATTR_ { attr_BT = bt
	, attr_value_BT = vbt
	, attr_name = aname
        , attr_value = aval
	} 
  cbt
  cur = let { t1 = TOut (' ' : aname ++ "=\"") ; t2 = TOut "\"";
	      t1' = tout (' ' : aname ++ "=\"") ; t2' = tout "\""; } in
  case bt of
    TOPLEVEL ->
      do pushOpen cur
	 ts <- collectAttrValue aval vbt STATIC [t1]
	 fname <- pushClosed (t2' ts)
	 parms <- get actuals
	 cur' <- popOpen
	 maybePushActuals cur' [TCall fname parms]
    DYNAMIC ->
      case cbt of
	STATIC ->
	  do ts <- collectAttrValue aval vbt DYNAMIC [t1]
	     maybePushActuals cur (t2' ts)
	DYNAMIC ->
	  do ts <- collectAttrValue aval vbt DYNAMIC (t1' cur)
	     return (t2' ts)
    STATIC ->
      case cbt of
	STATIC ->
	  do ts <- collectAttrValue aval vbt STATIC (t1' cur)
	     return (t2' ts)
	DYNAMIC ->
	  do pushOpen cur
	     ts <- collectAttrValue aval vbt STATIC [t1]
	     fname <- pushClosed (t2' ts)
	     parms <- get actuals
	     cur' <- popOpen
	     maybePushActuals cur' [TCall fname parms]

collectAttrValue aval bt cbt cur =
  let encVal = (htmlAttr aval "")
      t0 = TOut encVal
      t0' = tout encVal in
  case bt of
    TOPLEVEL ->
      do pushOpen cur
	 fname <- pushClosed [t0]
	 parms <- get actuals
	 cur' <- popOpen
	 maybePushActuals cur' [TCall fname parms]
    DYNAMIC ->
      case cbt of
	STATIC ->
	  do maybePushActuals cur [t0]
	DYNAMIC ->
	  do return [t0]
    STATIC ->
      case cbt of
	STATIC ->
	  do return (t0' cur)
	DYNAMIC ->
	  do pushOpen cur
	     fname <- pushClosed [t0]
	     parms <- get actuals
	     cur' <- popOpen
	     maybePushActuals cur' [TCall fname parms]


-- Local Variables: 
-- haskell-prog-switches: ("/home/thiemann/src/haskell/Utility/sha1lib.o")
-- End: 
