-- © 2002-2005 Peter Thiemann
-- |Haskell98 version of the submission functions.
module WASH.CGI.Submit98
	( InputHandle, HasValue (value)
	, F0 (F0), F1 (F1), F2 (F2), F3 (F3), F4 (F4), F5 (F5), F6 (F6), F7 (F7), F8 (F8)
	, FL (FL), FA (FA)
	, deF0, deF1, deF2, deF3, deF4, deF5, deF6, deF7, deF8
	, deFL, deFA
	, deValueF0, deValueF1, deValueF2, deValueF3, deValueF4, deValueF5, deValueF6, deValueF7, deValueF8
	, deValueFL, deValueFA
	, submit, submit0, defaultSubmit, DTree, submitx, dtleaf, dtnode
	, submitLink, submitLink0, defaultSubmitLink
	, activate
	)
	where

import WASH.CGI.AbstractSelector
import WASH.CGI.CGIInternals
import WASH.CGI.CGIMonad
import WASH.CGI.EventHandlers
import qualified WASH.CGI.HTMLWrapper as H
import WASH.CGI.InputHandle

import Monad

instance HasValue InputField where
  value inf = valueInputField inf

instance InputHandle (InputField a) where
  validate inf = validateInputField inf
  isBound  inf = ifBound inf
  ihNames  inf = [ifName inf]

data F0 x = F0
deF0 :: r -> (F0 x -> r)
deF0 r F0 = r

deValueF0 r F0 = r

instance InputHandle F0 where
  validate F0 = Right F0
  isBound  F0 = True
  ihNames  F0 = []

data F1 a x = F1 (a x)
deF1 :: (a x -> r) -> (F1 a x -> r)
deF1 g (F1 ax) = g ax

deValueF1 g (F1 ax) = g (value ax)

instance InputHandle a => InputHandle (F1 a) where
  validate (F1 ainv) =
    feither id F1 (validate ainv)
  isBound (F1 ainv) = isBound ainv
  ihNames (F1 ainv) = ihNames ainv

data F2 a b x = F2 (a x) (b x)
deF2 :: (a x -> b x -> r) -> (F2 a b x -> r)
deF2 g (F2 ax bx) = g ax bx

deValueF2 g (F2 ax bx) = g (value ax) (value bx)

instance (InputHandle a, InputHandle b) => InputHandle (F2 a b) where
  validate (F2 ainv binv) =
    feither id (uncurry F2)
    (propagate (validate ainv) (validate binv))
  isBound (F2 ainv binv) =
    isBound ainv && isBound binv
  ihNames (F2 ainv binv) =
    ihNames ainv ++ ihNames binv

data F3 a b c x = F3 (a x) (b x) (c x)
deF3 :: (a x -> b x -> c x -> r) -> (F3 a b c x -> r)
deF3 g (F3 ax bx cx) = g ax bx cx

deValueF3 g (F3 ax bx cx) = g (value ax) (value bx) (value cx)

instance (InputHandle a, InputHandle b, InputHandle c) => InputHandle (F3 a b c) where
  validate (F3 ainv binv cinv) =
    feither id (\ (aval,(bval,cval)) -> F3 aval bval cval)
    (propagate (validate ainv)
     (propagate (validate binv) (validate cinv)))
  isBound (F3 ainv binv cinv) =
    isBound ainv && isBound binv && isBound cinv
  ihNames (F3 ainv binv cinv) =
    ihNames ainv ++ ihNames binv ++ ihNames cinv

data F4 a b c d x = F4 (a x) (b x) (c x) (d x)
deF4 :: (a x -> b x -> c x -> d x -> r) -> (F4 a b c d x -> r)
deF4 g (F4 ax bx cx dx) = g ax bx cx dx

deValueF4 g (F4 ax bx cx dx) = g (value ax) (value bx) (value cx) (value dx)

instance (InputHandle a, InputHandle b, InputHandle c, InputHandle d)
       => InputHandle (F4 a b c d) where
  validate (F4 ainv binv cinv dinv) =
    feither id (\ (aval,(bval,(cval,dval))) -> F4 aval bval cval dval)
    (propagate (validate ainv) 
     (propagate (validate binv)
      (propagate (validate cinv) (validate dinv))))
  isBound (F4 ainv binv cinv dinv) =
    isBound ainv && isBound binv && isBound cinv && isBound dinv
  ihNames (F4 ainv binv cinv dinv) =
    ihNames ainv ++ ihNames binv ++ ihNames cinv ++ ihNames dinv

data F5 a b c d e x = F5 (a x) (b x) (c x) (d x) (e x)
deF5 :: (a x -> b x -> c x -> d x -> e x -> r) -> (F5 a b c d e x -> r)
deF5 g (F5 ax bx cx dx ex) = g ax bx cx dx ex

deValueF5 g (F5 ax bx cx dx ex) = g (value ax) (value bx) (value cx) (value dx) (value ex)

instance (InputHandle a, InputHandle b, InputHandle c, InputHandle d, InputHandle e)
       => InputHandle (F5 a b c d e) where
  validate (F5 ainv binv cinv dinv einv) =
    feither id (\ (aval,(bval,(cval,(dval,eval)))) -> F5 aval bval cval dval eval)
    (propagate (validate ainv) 
     (propagate (validate binv)
      (propagate (validate cinv)
       (propagate (validate dinv) (validate einv)))))
  isBound (F5 ainv binv cinv dinv einv) =
    isBound ainv && isBound binv && isBound cinv && isBound dinv && isBound einv
  ihNames (F5 ainv binv cinv dinv einv) =
    ihNames ainv ++ ihNames binv ++ ihNames cinv ++ ihNames dinv ++ ihNames einv

data F6 a b c d e f x = F6 (a x) (b x) (c x) (d x) (e x) (f x)
deF6 :: (a x -> b x -> c x -> d x -> e x -> f x -> r) -> (F6 a b c d e f x -> r)
deF6 g (F6 ax bx cx dx ex fx) = g ax bx cx dx ex fx

deValueF6 g (F6 ax bx cx dx ex fx) = g (value ax) (value bx) (value cx) (value dx) (value ex) (value fx)

instance (InputHandle a, InputHandle b, InputHandle c, InputHandle d, InputHandle e, InputHandle f)
       => InputHandle (F6 a b c d e f) where
  validate (F6 ainv binv cinv dinv einv finv) =
    feither id (\ (aval,(bval,(cval,(dval,(eval, fval))))) -> F6 aval bval cval dval eval fval)
    (propagate (validate ainv) 
     (propagate (validate binv)
      (propagate (validate cinv)
       (propagate (validate dinv) 
        (propagate (validate einv) (validate finv))))))
  isBound (F6 ainv binv cinv dinv einv finv) =
    isBound ainv && isBound binv && isBound cinv && isBound dinv && isBound einv && isBound finv
  ihNames (F6 ainv binv cinv dinv einv finv) =
    ihNames ainv ++ ihNames binv ++ ihNames cinv ++ ihNames dinv ++ ihNames einv ++ ihNames finv

data F7 a b c d e f g x = F7 (a x) (b x) (c x) (d x) (e x) (f x) (g x)
deF7 :: (a x -> b x -> c x -> d x -> e x -> f x -> g x -> r) -> (F7 a b c d e f g x -> r)
deF7 g (F7 ax bx cx dx ex fx gx) = g ax bx cx dx ex fx gx

deValueF7 g (F7 ax bx cx dx ex fx gx) = g (value ax) (value bx) (value cx) (value dx) (value ex) (value fx) (value gx)

instance (InputHandle a, InputHandle b, InputHandle c, InputHandle d, InputHandle e, InputHandle f, InputHandle g)
       => InputHandle (F7 a b c d e f g) where
  validate (F7 ainv binv cinv dinv einv finv ginv) =
    feither id (\ (aval,(bval,(cval,(dval,(eval, (fval, gval)))))) -> F7 aval bval cval dval eval fval gval)
    (propagate (validate ainv) 
     (propagate (validate binv)
      (propagate (validate cinv)
       (propagate (validate dinv) 
        (propagate (validate einv)
	 (propagate (validate finv) (validate ginv)))))))
  isBound (F7 ainv binv cinv dinv einv finv ginv) =
    isBound ainv && isBound binv && isBound cinv && isBound dinv && isBound einv && isBound finv && isBound ginv
  ihNames (F7 ainv binv cinv dinv einv finv ginv) =
    ihNames ainv ++ ihNames binv ++ ihNames cinv ++ ihNames dinv ++ ihNames einv ++ ihNames finv ++ ihNames ginv

data F8 a b c d e f g h x = F8 (a x) (b x) (c x) (d x) (e x) (f x) (g x) (h x)
deF8 :: (a x -> b x -> c x -> d x -> e x -> f x -> g x -> h x -> r) -> (F8 a b c d e f g h x -> r)
deF8 g (F8 ax bx cx dx ex fx gx hx) = g ax bx cx dx ex fx gx hx

deValueF8 g (F8 ax bx cx dx ex fx gx hx) = g (value ax) (value bx) (value cx) (value dx) (value ex) (value fx) (value gx) (value hx)

instance (InputHandle a, InputHandle b, InputHandle c, InputHandle d, InputHandle e, InputHandle f, InputHandle g, InputHandle h)
       => InputHandle (F8 a b c d e f g h) where
  validate (F8 ainv binv cinv dinv einv finv ginv hinv) =
    feither id (\ (aval,(bval,(cval,(dval,(eval, (fval, (gval, hval))))))) -> F8 aval bval cval dval eval fval gval hval)
    (propagate (validate ainv) 
     (propagate (validate binv)
      (propagate (validate cinv)
       (propagate (validate dinv) 
        (propagate (validate einv) 
	 (propagate (validate finv)
	  (propagate (validate ginv) (validate hinv))))))))
  isBound (F8 ainv binv cinv dinv einv finv ginv hinv) =
    isBound ainv && isBound binv && isBound cinv && isBound dinv && isBound einv && isBound finv && isBound ginv && isBound hinv
  ihNames (F8 ainv binv cinv dinv einv finv ginv hinv) =
    ihNames ainv ++ ihNames binv ++ ihNames cinv ++ ihNames dinv ++ ihNames einv ++ ihNames finv ++ ihNames ginv ++ ihNames hinv

-- |'FL' is required to pass an unknown number of handles of the same
-- type need to the callback function in a form submission. The
-- handles need to be collected in a list and then wrapped in the 'FL' data constructor
data FL a x = FL [a x]
deFL :: ([a x] -> r) -> (FL a x -> r)
deFL g (FL axs) = g axs

deValueFL g (FL axs) = g (map value axs)

instance InputHandle a => InputHandle (FL a) where
  validate (FL ainvs) =
    g (map validate ainvs)		 -- [Either [ValidationError] (h VALID)]
    where 
    g = foldr h (Right (FL []))
    h ev evs = feither id (\ (v, FL vs) -> FL (v : vs)) (propagate ev evs)
  isBound (FL ainvs) =
    all isBound ainvs
  ihNames (FL ainvs) =
    concatMap ihNames ainvs

-- |'FA' comes handy when you want to tag an input handle with some extra
-- information, which is not itsefl an input handle and which is not validated
-- by a form submission. The tag is the first argument and the handle is the
-- second argument of the data constructor.
data FA a b x = FA a (b x)
deFA :: (a -> b x -> r) -> (FA a b x -> r)
deFA g (FA a bx) = g a bx

deValueFA g (FA a bx) = g a (value bx)

instance InputHandle b => InputHandle (FA a b) where
  validate (FA a binv) =
    feither id (FA a) (validate binv)
  isBound (FA a binv) =
    isBound binv
  ihNames (FA a binv) =
    ihNames binv

-- |Create a submission button with attached action.
submit :: (CGIMonad cgi, InputHandle h)
	=> h INVALID		-- ^input field handles to be validated and passed to callback action 
	-> (h VALID -> cgi ())	-- ^callback maps valid input handles to a CGI action
	-> HTMLField cgi x y ()	-- ^returns a field so that attributes can be attached
submit = submitInternal False

-- |Create a continuation button that takes no parameters.
submit0 :: (CGIMonad cgi) => cgi () -> HTMLField cgi x y ()
submit0 cont = submit F0 (\F0 -> cont)

-- |Create a submission button whose attached action is fired whenever the form
-- is submitted without explicitly clicking any submit button. This can happen if
-- an input field has an attached onclick="submit()" action.
defaultSubmit :: (CGIMonad cgi, InputHandle h) =>
  h INVALID -> (h VALID -> cgi ()) -> HTMLField cgi x y ()
defaultSubmit = submitInternal True

-- |Create an ordinary link serving as a submission button.
submitLink :: (CGIMonad cgi, InputHandle h) =>
  h INVALID -> (h VALID -> cgi ()) -> H.HTMLCons x y cgi ()
submitLink = submitInternalLink False

-- |Create a continuation link.
submitLink0 :: (CGIMonad cgi) => cgi () -> H.HTMLCons x y cgi ()
submitLink0 cont = submitLink F0 (const cont)

defaultSubmitLink :: (CGIMonad cgi, InputHandle h) =>
  h INVALID -> (h VALID -> cgi ()) -> H.HTMLCons x y cgi ()
defaultSubmitLink = submitInternalLink True

-- |Abstract type of decisions trees. These trees provide structured validation.
newtype DTree cgi x y = DTree { unDTree :: HTMLField cgi x y () }

-- |Create a submission button whose validation proceeds according to a decision
-- tree. Trees are built using 'dtleaf' and 'dtnode'.
submitx :: DTree cgi x y -> HTMLField cgi x y ()
submitx = unDTree

-- |Create a leaf in a decision tree from a CGI action. 
dtleaf :: (CGIMonad cgi) => cgi () -> DTree cgi x y
dtleaf action = DTree $ submit0 action

-- |Create a node in a decision tree. Takes an invalid input field and a
-- continuation. Validates the input field and passes it to the continuation if
-- the validation was successful. The continuation can dispatch on the value of
-- the input field and produces a new decision tree.
dtnode :: (CGIMonad cgi, InputHandle h) =>
  h INVALID -> (h VALID -> DTree cgi x y) -> DTree cgi x y
dtnode hinv next =
  if isBound hinv then
  case validate hinv of
    Right hval ->
      next hval
    Left ss ->
      DTree $ internalSubmitField False (Left ss)
  else 
    DTree $ internalSubmitField False (Left [])

submitInternal isDefault hinv g =
  internalSubmitField isDefault (validator hinv g)

validator hinv g =
  either Left (Right . g) (validate hinv)

submitInternalLink isDefault hinv g =
  internalSubmitLink isDefault (validator hinv g)
    

instance HasValue RadioGroup where
  value rg = valueRadioGroup rg

instance InputHandle (RadioGroup a) where
  validate rg = validateRadioGroup rg
  isBound rg = radioBound rg
  ihNames rg = [radioName rg]

instance HasValue SelectionGroup where
  value sg = valueSelectionGroup sg

instance InputHandle (SelectionGroup a) where
  validate sg = validateSelectionGroup sg
  isBound sg = selectionBound sg
  ihNames sg = [selectionName sg]

-- |Attach a CGI action to the value returned by the input field. Activation
-- means that data is submitted as soon as it is entered.
activate :: (CGIMonad cgi, InputHandle (i a), HasValue i) =>
  (a -> cgi ()) -> HTMLField cgi x y (i a INVALID) -> HTMLField cgi x y (i a INVALID)
activate actionFun inputField attrs =
  do invalid_inf <- inputField (do attrs
				   onChange $ "WASHSubmit(this.name);")
     let r = validate invalid_inf
	 rv = either Left (Right . value) r
     when (isBound invalid_inf) $
       activateInternal actionFun (head $ ihNames invalid_inf) rv
     return invalid_inf
