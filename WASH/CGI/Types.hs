-- © 2001, 2002, 2003 Peter Thiemann
{-| The Types module aims at providing a representation for (first-order)
monomorphic Haskell types. Two type representations are equal if and
only if the represented types have identical definitions. Thus a type
representation consists of a type term and the smallest list of all
(data or newtype) definitions needed either in the type term or in
another definition. The list of definitions is sorted to make
representations unique.

The main use of type representations is to provide a type index for
storing Haskell values externally and for reading them back into a
running program without sacrificing type safety. Just reading them
back with the @Read@ class is not sufficient because

 * @Read@ does not distinguish between @Int@ and @Integer@, @Float@ and @Double@y

 * @Read@ cannot avoid accidental matches of constructor names

Meanwhile, the 'Data.Typeable' class of GHC provides an encoding with similar
goals.
-}
module WASH.CGI.Types where

import Data.Maybe (fromJust)

-- | A type specification consists of a type representation 'TyRep' and a list of
-- type declarations.
data TySpec = 
     TS TyRep [TyDecl]					    -- declarations sorted!
  deriving (Read, Show, Eq)

-- | A type representation is built from base types, type variables, tuples, and
-- references to data-defined types.
data TyRep =
     TRBase  String
   | TRVar   String
   | TRTuple [TyRep]
   | TRData  String [TyRep]
  deriving (Read, Show, Eq)

-- | A data declaration consists of the name of the data type, a list of type
-- variables, and a list of constructor representations.
data TyDecl =
     TD String [String] [ConRep]
  deriving (Read, Show, Eq)

-- | A constructor is represented by its name, a list of field names (if defined
-- using record notation), and the list of its argument types
data ConRep =
     CR String						    -- ctor name
       	(Maybe [String])				    -- field names
	[TyRep]						    -- field types
  deriving (Read, Show, Eq)

class Types a where
  ty :: a -> TySpec

instance Types () where
  ty i = TS (TRBase "()") []

instance Types Bool where
  ty i = TS (TRBase "Bool") []
  
instance Types Int where
  ty i = TS (TRBase "Int") []
  
instance Types Integer where
  ty i = TS (TRBase "Integer") []
  
--instance Types Rational where
--  ty i = TS (TRBase "Rational") []

instance Types Double where
  ty d = TS (TRBase "Double") []

instance Types Float where
  ty d = TS (TRBase "Float") []

instance Types Char where
  ty c = TS (TRBase "Char") []

instance (Types a, Types b) => Types (a,b) where
  ty xy = TS (TRTuple [tra, trb]) (merge defsa defsb)
    where TS tra defsa = ty (fst xy)
	  TS trb defsb = ty (snd xy)

instance (Types a, Types b, Types c) => Types (a,b,c) where
  ty ~(xa,xb,xc) = TS (TRTuple [tra, trb, trc]) (merge (merge defsa defsb) defsc)
    where TS tra defsa = ty xa
	  TS trb defsb = ty xb
	  TS trc defsc = ty xc

instance (Types a, Types b, Types c, Types d) => Types (a,b,c,d) where
  ty ~(xa,xb,xc,xd) = TS (TRTuple [tra, trb, trc, trd]) 
			 (merge (merge defsa defsb) (merge defsc defsd))
    where TS tra defsa = ty xa
	  TS trb defsb = ty xb
	  TS trc defsc = ty xc
	  TS trd defsd = ty xd

instance (Types a, Types b, Types c, Types d, Types e) => Types (a,b,c,d,e) where
  ty ~(xa,xb,xc,xd,xe) = TS (TRTuple [tra, trb, trc, trd, tre]) 
			    (merges [defsa, defsb, defsc, defsd, defse])
    where TS tra defsa = ty xa
	  TS trb defsb = ty xb
	  TS trc defsc = ty xc
	  TS trd defsd = ty xd
	  TS tre defse = ty xe

instance (Types a) => Types [a] where
  ty xs = TS (TRData (tdName listDef) [tr]) (merge defs [listDef])
    where TS tr defs = ty (head xs)

listDef :: TyDecl
listDef = TD "[]" ["a"]	[CR "[]" Nothing []
			,CR ":"  Nothing [TRVar "a"
					 ,TRData (tdName listDef) [TRVar "a"]]]

instance (Types a) => Types (Maybe a) where
  ty mx = TS (TRData (tdName maybeDef) [tr]) (merge defs [maybeDef])
    where TS tr defs = ty (fromJust mx)

-- fromJust (Just x) = x -- in Module Maybe

maybeDef :: TyDecl
maybeDef = 
	TD "Maybe" ["a"][CR "Nothing" Nothing []
			,CR "Just"    Nothing [TRVar "a"]]

instance (Types a, Types b) => Types (Either a b) where
  ty xy = TS (TRData (tdName eitherDef) [tra, trb]) 
  	     (merge (merge defsa defsb) [eitherDef])
    where TS tra defsa = ty (fromLeft xy)
	  TS trb defsb = ty (fromRight xy)

fromLeft  (Left x)  = x
fromRight (Right y) = y

eitherDef :: TyDecl
eitherDef =
	TD 	"Either"
		["a", "b"]
		[CR "Left"  Nothing [TRVar "a"]
		,CR "Right" Nothing [TRVar "b"]]

tdName (TD name _ _) = name

merge :: [TyDecl] -> [TyDecl] -> [TyDecl]
merge [] ys = ys
merge xs [] = xs
merge (x:xs) (y:ys) 
  | x == y               = x : merge xs ys
  | tdName x == tdName y = error ("Different types with identical name: " ++ tdName x)
  | tdName x <= tdName y = x : merge xs (y:ys)
  | otherwise            = y : merge (x:xs) ys

merges :: [[TyDecl]] -> [TyDecl]
merges tss = foldr merge [] tss

class TID a where
  tid :: a -> ShowS
  
instance TID TySpec where
  tid (TS tyRep tyDecls) =
    tid tyRep . tid tyDecls

instance TID a => TID [a] where
  tid [] = showChar '.'
  tid (x : xs) = showChar ',' . tid x . tid xs

instance TID TyRep where
  tid (TRBase str) = showChar 'B' . shows str
  tid (TRVar  str) = showChar 'V' . shows str
  tid (TRTuple tyReps) = showChar 'T' . tid tyReps
  tid (TRData  str tyReps) = showChar 'D' . shows str . tid tyReps

instance TID TyDecl where
  tid (TD name tyvars conreps) =
    shows name . shows tyvars . tid conreps

instance TID ConRep where
  tid (CR ctorname mFields tyReps) =
    shows ctorname . shows mFields . tid tyReps

