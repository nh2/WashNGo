module WASH.Mail.ContentDisposition where

import WASH.Mail.RFC2822
			  
data ContentDisposition =
    None
  | Inline     { parameters :: [ContentDispositionParm] }
  | Attachment { parameters :: [ContentDispositionParm] }

data ContentDispositionParm =
    FileNameParm String
  | CreationDateParm DateTime2822
  | ModificationDateParm DateTime2822
  | ReadDateParm DateTime2822
  | SizeParm Int

hasContentDisposition None = False
hasContentDisposition _ = True

toString (None) =
  ""
toString (Inline { parameters = cdps }) =
  "inline" ++ cdpsToString cdps
toString (Attachment { parameters = cdps }) =
  "attachment" ++ cdpsToString cdps

cdpsToString = concatMap cdpToString
cdpToString (FileNameParm file) =
  "; filename=\""++file++"\""
cdpToString (CreationDateParm dt) =
  "; creation-date=\""++shows dt "\""
cdpToString (ModificationDateParm dt) =
  "; modification-date=\""++shows dt "\""
cdpToString (ReadDateParm dt) =
  "; read-date=\""++shows dt "\""
cdpToString (SizeParm n) =
  "; size="++show n

