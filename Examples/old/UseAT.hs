import WASH.CGI.CGI

import Control.Monad

main = 
  run page1

page1 =
  do at <- table_io $ return [["Ratio"], ["Complex"], ["Numeric"], ["Ix"], ["Array"], ["List"], ["Maybe"], ["Char"], ["Monad"], ["IO"], ["Directory"], ["System"], ["Time"], ["Locale"], ["CPUTime"], ["Random"]]
     standardQuery "Haskell Library Modules" $
       do sg <- selectionGroup
	  let makeRow row = tr (mapM (makeCol row) [0..(as_cols at -1)])
	      makeCol row col = td (getText at row col)
				   
	      makeRow' row = selectionDisplay sg at row dispRow
	      dispRow button texts = tr (do td button
					    sequence (Prelude.map td texts))
	  p $ table (mapM makeRow' [0..(as_rows at -1)])
	  submit sg page2 empty

page2 sg =
  let lib = unAR (value sg) in
  standardQuery "Selected Haskell Library Module" $
  do text "You selected "
     text (show lib)

page2a lib =
  standardQuery "Directly Selected Haskell Library Module" $
  do text "You selected "
     text (show lib)
  
