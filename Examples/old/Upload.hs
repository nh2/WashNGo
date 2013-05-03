-- © 2001, 2002 Peter Thiemann
module Main where
import WASH.CGI.CGI hiding (head, map, span, div)

main = 
  run $
  standardQuery "Upload File" $
  do text "Enter file to upload "
     fileH <- checkedFileInputField refuseUnnamed empty
     submit fileH display (fieldVALUE "UPLOAD")

refuseUnnamed mf = 
  do FileReference {fileReferenceExternalName=frn} <- mf
     if null frn then fail "" else mf
  
display :: InputField FileReference VALID -> CGI ()
display fileH =
  let fileRef = value fileH in
  standardQuery "Upload Successful" $
  do p (text (show fileRef))
     p (do text "Check file contents "
	   submit0 (tell fileRef) (fieldVALUE "Show contents"))
