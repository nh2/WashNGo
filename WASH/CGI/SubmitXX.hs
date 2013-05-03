{-# OPTIONS_GHC -fglasgow-exts -fallow-undecidable-instances #-}
-- © 2002-2005 Peter Thiemann
-- |Extended-Haskell version of the submission functions.
module WASH.CGI.SubmitXX where

import WASH.CGI.CGIInternals
import WASH.CGI.CGIMonad
import WASH.CGI.EventHandlers

import Monad

class StripHandle hx x | hx -> x where
  validate :: hx -> Either [ValidationError] x
  isBound :: hx -> Bool
  ihNames :: hx -> [String]

instance StripHandle (InputField a x) a where
  validate inf =
    case validateInputField inf of
      Left ss ->
        Left ss
      Right _ ->
        Right $ valueInputField inf
  isBound inf =
    ifBound inf
  ihNames inf =
    [ifName inf]

instance StripHandle (RadioGroup a x) a where
  validate rg =
    case validateRadioGroup rg of
      Left ss ->
        Left ss
      Right _ ->
        Right $ valueRadioGroup rg
  isBound rg =
    radioBound rg
  ihNames rg =
    [radioName rg]

instance StripHandle () () where
  validate () = Right ()
  isBound () = True
  ihNames () = []

instance (StripHandle hx x, StripHandle hy y) => StripHandle (hx, hy) (x, y) where
  validate (hx, hy) =
    propagate (validate hx) (validate hy)
  isBound (hx, hy) =
    isBound hx && isBound hy
  ihNames (hx, hy) =
    ihNames hx ++ ihNames hy

instance (StripHandle hx x, StripHandle hy y, StripHandle hz z) 
	=> StripHandle (hx, hy, hz) (x, y, z) where
  validate (hx, hy, hz) =
    feither id (\ (x, (y, z)) -> (x, y, z)) $
    propagate (validate hx) (propagate (validate hy) (validate hz))
  isBound (hx, hy, hz) =
    isBound hx && isBound (hy, hz)
  ihNames (hx, hy, hz) =
    ihNames hx ++ ihNames (hy, hz)

instance (StripHandle hx x, StripHandle hy y, StripHandle hz z, StripHandle ha a)
	=> StripHandle (hx, hy, hz, ha) (x, y, z, a) where
  validate (hx, hy, hz, ha) =
    feither id (\ ((x, y), (z, a)) -> (x, y, z, a)) $
    propagate
      (propagate (validate hx) (validate hy))
      (propagate (validate hz) (validate ha))
  isBound (hx, hy, hz, ha) =
    isBound (hx, hy) && isBound (hz, ha)
  ihNames (hx, hy, hz, ha) =
    ihNames (hx, hy) ++ ihNames (hz, ha)

instance (StripHandle hx x, StripHandle hy y, StripHandle hz z, StripHandle ha a, StripHandle hb b)
	=> StripHandle (hx, hy, hz, ha, hb) (x, y, z, a, b) where
  validate (hx, hy, hz, ha, hb) =
    feither id (\ ((x, y), (z, (a, b))) -> (x, y, z, a, b)) $
    propagate
      (propagate (validate hx) (validate hy))
      (propagate (validate hz) (propagate (validate ha) (validate hb)))
  isBound (hx, hy, hz, ha, hb) =
    isBound (hx, hy) && isBound (hz, (ha, hb))
  ihNames (hx, hy, hz, ha, hb) =
    ihNames (hx, hy) ++ ihNames (hz, (ha, hb))

instance (StripHandle hx x, StripHandle hy y, StripHandle hz z, StripHandle ha a, StripHandle hb b, StripHandle hc c)
	=> StripHandle (hx, hy, hz, ha, hb, hc) (x, y, z, a, b, c) where
  validate (hx, hy, hz, ha, hb, hc) =
    feither id (\ ((x, y, z), (a, b, c)) -> (x, y, z, a, b, c)) $
    propagate
      (validate (hx, hy, hz)) (validate (ha, hb, hc))
  isBound (hx, hy, hz, ha, hb, hc) =
    isBound (hx, hy, hz) && isBound (ha, hb, hc)
  ihNames (hx, hy, hz, ha, hb, hc) =
    ihNames (hx, hy, hz) ++ ihNames (ha, hb, hc)

instance (StripHandle hx x, StripHandle hy y, StripHandle hz z, StripHandle ha a, StripHandle hb b, StripHandle hc c, StripHandle hd d)
	=> StripHandle (hx, hy, hz, ha, hb, hc, hd) (x, y, z, a, b, c, d) where
  validate (hx, hy, hz, ha, hb, hc, hd) =
    feither id (\ ((x, y, z), (a, b, c, d)) -> (x, y, z, a, b, c, d)) $
    propagate
      (validate (hx, hy, hz)) (validate (ha, hb, hc, hd))
  isBound (hx, hy, hz, ha, hb, hc, hd) =
    isBound (hx, hy, hz) && isBound (ha, hb, hc, hd)
  ihNames (hx, hy, hz, ha, hb, hc, hd) =
    ihNames (hx, hy, hz) ++ ihNames (ha, hb, hc, hd)

instance (StripHandle hx x, StripHandle hy y, StripHandle hz z, StripHandle ha a, StripHandle hb b, StripHandle hc c, StripHandle hd d, StripHandle he e)
	=> StripHandle (hx, hy, hz, ha, hb, hc, hd, he) (x, y, z, a, b, c, d, e) where
  validate (hx, hy, hz, ha, hb, hc, hd, he) =
    feither id (\ ((x, y, z), (a, b, c, d, e)) -> (x, y, z, a, b, c, d, e)) $
    propagate
      (validate (hx, hy, hz)) (validate (ha, hb, hc, hd, he))
  isBound (hx, hy, hz, ha, hb, hc, hd, he) =
    isBound (hx, hy, hz) && isBound (ha, hb, hc, hd, he)
  ihNames (hx, hy, hz, ha, hb, hc, hd, he) =
    ihNames (hx, hy, hz) ++ ihNames (ha, hb, hc, hd, he)

instance (StripHandle hw w, StripHandle hx x, StripHandle hy y, StripHandle hz z, StripHandle ha a, StripHandle hb b, StripHandle hc c, StripHandle hd d, StripHandle he e)
	=> StripHandle (hw, hx, hy, hz, ha, hb, hc, hd, he) (w, x, y, z, a, b, c, d, e) where
  validate (hw, hx, hy, hz, ha, hb, hc, hd, he) =
    feither id (\ ((w, x, y, z), (a, b, c, d, e)) -> (w, x, y, z, a, b, c, d, e)) $
    propagate
      (validate (hw, hx, hy, hz)) (validate (ha, hb, hc, hd, he))
  isBound (hw, hx, hy, hz, ha, hb, hc, hd, he) =
    isBound (hw, hx, hy, hz) && isBound (ha, hb, hc, hd, he)
  ihNames (hw, hx, hy, hz, ha, hb, hc, hd, he) =
    ihNames (hw, hx, hy, hz) ++ ihNames (ha, hb, hc, hd, he)

instance (StripHandle hx x) => StripHandle [hx] [x] where
  validate hxs =
    foldr (\ hx xs -> feither id (uncurry (:)) $ propagate (validate hx) xs)
          (Right []) hxs
  isBound hxs =
    all isBound hxs
  ihNames hxs =
    concatMap ihNames hxs

-- |create a submission button with attached action
submit, defaultSubmit :: (CGIMonad cgi, StripHandle handle_a a)
	=> handle_a
	-> (a -> cgi ())
	-> HTMLField cgi x y ()
submit = submitInternal False
defaultSubmit = submitInternal True

-- |create a continuation button with parameters
submit0 :: (CGIMonad cgi) => cgi () -> HTMLField cgi x y ()
submit0 cont = submit () (const cont)

submitInternal isDefault hinv g =
  case validate hinv of
    Right hval ->
      internalSubmitField isDefault (Right (g hval))
    Left ss ->
      internalSubmitField isDefault (Left ss)

newtype DTree cgi x y = DTree { unDTree :: HTMLField cgi x y () }

-- |submission with staged validation
submitx :: DTree cgi x y -> HTMLField cgi x y ()
submitx = unDTree

dtleaf :: (CGIMonad cgi) => cgi () -> DTree cgi x y
dtleaf action = DTree $ submit0 action

dtnode :: (CGIMonad cgi, StripHandle handle_a a) =>
  handle_a -> (a -> DTree cgi x y) -> DTree cgi x y
dtnode hinv next =
  if isBound hinv then
  case validate hinv of
    Right hval ->
      next hval
    Left ss ->
      DTree $ internalSubmitField False (Left ss)
  else 
    DTree $ internalSubmitField False (Left [])
  
-- |Attach a CGI action to the value returned by the input field. Activation
-- means that data is submitted as soon as it is entered.
activate :: (CGIMonad cgi, StripHandle ha a) =>
  (a -> cgi ()) -> HTMLField cgi x y ha -> HTMLField cgi x y ha
activate actionFun inputField attrs =
  do invalid_inf <- inputField (do attrs
				   onChange $ "WASHSubmit(this.name);")
     let rv = validate invalid_inf
     when (isBound invalid_inf) $
       activateInternal actionFun (head $ ihNames invalid_inf) rv
     return invalid_inf
