-- © 2001, 2002 Peter Thiemann
-- |Types of outputable data.
module WASH.CGI.CGITypes where

import WASH.CGI.HTMLWrapper (WithHTML)

newtype URL = URL { unURL :: String }

data FileReference =
     FileReference { fileReferenceName :: FilePath
     		   -- ^ valid local filename where this file can be accessed
     		   , fileReferenceContentType :: String
		   , fileReferenceExternalName :: String
		   }
     deriving (Show, Read)

-- |Assumes that file contains correctly formatted HTTP Response starting with
-- Content-Type. Used internally to implement frames.
data ResponseFileReference =
     ResponseFileReference FilePath

data Status = Status { statusCode :: Int		    -- ^ status code
		     , statusReason :: String		    -- ^ reason phrase
		     , statusContent :: Maybe (WithHTML () IO ())   -- ^ more explanation
		     }

newtype Location = Location URL				    -- ^ redirection

data FreeForm =
     FreeForm	{ ffName :: String			    -- ^ internal name
		, ffContentType :: String		    -- ^ MIME type
		, ffRawContents :: String		    -- ^ contents as octet stream
		}

data CGIOption
  = NoPort	-- ^ do not include port number in generated URLs
  | AutoPort	-- ^ include automatically generated port number in generated URLs (default)
  | Port Int	-- ^ use this port number in generated URLs

  | NoHttps     -- ^ do not attempt to detect Https
  | AutoHttps   -- ^ autodetect Https by checking for port number 443 and env var HTTPS (default)

  | FullURL     -- ^ generate full URL including scheme, host, and port
  | PartialURL  -- ^ generate absolute path URL, only (default)

  | SessionMode { unSessionMode :: SessionMode }
  deriving (Eq, Show)
type CGIOptions = [CGIOption]

data SessionMode
  = LogOnly	-- ^ generate log in hidden field, full server replay (default)
  | StateIDOnly	-- ^ generate state id, server threads without replay (only with WSP)
  | LogAndState -- ^ log and state id, server threads with replay as fallback (only with WSP)
  deriving (Eq, Show, Read, Bounded, Enum)

sessionNeedsLog :: SessionMode -> Bool
sessionNeedsLog LogOnly = True
sessionNeedsLog StateIDOnly = False
sessionNeedsLog LogAndState = True

sessionNeedsState :: SessionMode -> Bool
sessionNeedsState LogOnly = False
sessionNeedsState StateIDOnly = True
sessionNeedsState LogAndState = True
