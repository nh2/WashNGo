module WASH.CGI.Frames where

import WASH.Utility.Auxiliary
import qualified WASH.CGI.HTMLWrapper as H hiding (map)
import WASH.CGI.CookieIO
import WASH.CGI.CGIConfig
import WASH.CGI.CGIMonad
import WASH.CGI.CGIOutput
import WASH.CGI.CGITypes
import WASH.CGI.EventHandlers
import WASH.CGI.Fields
import WASH.CGI.Images
import WASH.CGI.RawCGIInternal hiding (CGIEnv (..))
import qualified WASH.Utility.URLCoding as URLCoding
import WASH.Utility.JavaScript


-- ======================================================================
-- frames

-- |Overall layout of a frame set: row-wise or column-wise.
data FrameLayout = ROWS | COLS
  deriving Show

-- |Division of space between elements of a frameset. See
-- <http://wp.netscape.com/assist/net_sites/frame_syntax.html>
data FrameSpacing = FrameAbsolute Int			    -- ^in pixels
		  | FrameRelative Int			    -- ^the @*@ format
		  | FramePercent  Int			    -- ^the @%@ format

instance Show FrameSpacing where
  showsPrec _ (FrameAbsolute n) = shows n
  showsPrec _ (FrameRelative n) = shows n . showChar '*'
  showsPrec _ (FramePercent  n) = shows n . showChar '%'
  showList [] = id
  showList [ffmt] = shows ffmt
  showList (ffmt:ffmts) = shows ffmt . showChar ',' . showList ffmts

-- |Abstract data type of frame set generators.
data FrameSet = FrameSet { unFrameSet :: H.WithHTML () IO () }

-- |Create a frameset, given a layout, its spacing, and its subframe(set)s.
makeFrameset :: (CGIMonad cgi) =>
        FrameLayout
	-> [(FrameSpacing, cgi FrameSet)]
	-> cgi FrameSet
makeFrameset layout subframes =
  do nested <- mapM snd subframes
     return $ FrameSet $
       H.frameset_S (foldr (( >> ) . unFrameSet) 
			   (H.attr_SD (show layout) (show (map fst subframes)))
			   nested)

-- |Create a single frame. Returns the assigned name of the frame.
makeFrame :: (CGIMonad cgi) =>
	H.WithHTML x IO ()		-- ^additional attributes to <frame>
	-> cgi ()			-- ^contents of the frame
	-> cgi FrameSet			-- ^returns HTML generator for the frame
makeFrame attrs subAction =
  do n <- incFrame
     -- unsafe_io (appendFile "/tmp/CGIFRAME" $ ("makeFrame #" ++ show n ++ "\n"))
     subAction
     baseUrl <- getUrl
     parm <- getParm
     let url = baseUrl ++ '?' : URLCoding.encode (frameFileName parm n)
	 name = ("FRAME"++show n)
     -- unsafe_io (appendFile "/tmp/CGIFRAME" $ ("makeFrame finished\n"))
     return $ FrameSet $
       H.frame_S (do attrs
		     H.attr_SD "SRC" url
		     H.attr_SD "NAME" name)

frameFileName parm frameno =
  "FRAME:" ++ show frameno ++ ":" ++ (URLCoding.encode $ show $ parm)

frameFullPath parm frameno = 
  frameDir ++ frameFileName parm frameno

-- |Required wrapper for pages with frames. Takes a title and a FrameSet
-- generator and displays the page.
framesetPage :: (CGIMonad cgi) => String -> cgi FrameSet -> cgi ()
framesetPage ttl framesetgen =
  do resetFrame
     FrameSet pagegen <- framesetgen
     let ma = H.htmlHeader ttl pagegen
     resetFrame
     wrapCGI $ \ cgistate ->
       do elem <- H.build_document ma
	  (nextaction (pageInfo cgistate) elem) (nextCGIState cgistate)

