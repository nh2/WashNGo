-- © 2001, 2002 Peter Thiemann
-- this file is generated -- do not edit
module WASH.HTML.HTMLMonad98
  (module WASH.HTML.HTMLMonad98,
   Element,Attributes,Attribute,WithHTML,lift,get_attrs,empty,( ## ),HTMLCons,attr)
  where
import Prelude hiding (div,head,map,span)
import qualified WASH.HTML.HTMLMonad as HTMLMonad
-- fixed top level code
import WASH.HTML.HTMLMonad
	( Element, Attributes, Attribute
	, WithHTML, lift, get_attrs
	, empty, ( ## )
	, HTMLCons, attr, av, addMaker)
data DOCUMENT = DOCUMENT
instance AdmitChildHTML DOCUMENT
build_document :: (Monad m) => WithHTML DOCUMENT m a -> m Element
build_document = HTMLMonad.build_document
class AdmitChildCDATA e where
  text, rawtext, formattedtext :: Monad m => String -> WithHTML e m ()
  text = HTMLMonad.text
  rawtext = HTMLMonad.rawtext
  formattedtext = HTMLMonad.formattedtext
-- end fixed prologue
class AdmitAttrVERSION e where
  uaVERSION :: (Monad m) => String -> WithHTML e m ()
  uaVERSION str = attr "VERSION" str
  atVERSION :: (Monad m, AttrValueVERSION v) => v -> WithHTML e m ()
  atVERSION v = attr "VERSION" (av $ show v)
class AdmitAttrDIR e where
  uaDIR :: (Monad m) => String -> WithHTML e m ()
  uaDIR str = attr "DIR" str
  atDIR :: (Monad m, AttrValueDIR v) => v -> WithHTML e m ()
  atDIR v = attr "DIR" (av $ show v)
class AdmitAttrLANG e where
  uaLANG :: (Monad m) => String -> WithHTML e m ()
  uaLANG str = attr "LANG" str
  atLANG :: (Monad m, AttrValueLANG v) => v -> WithHTML e m ()
  atLANG v = attr "LANG" (av $ show v)
class AdmitAttrONKEYUP e where
  uaONKEYUP :: (Monad m) => String -> WithHTML e m ()
  uaONKEYUP str = attr "ONKEYUP" str
  atONKEYUP :: (Monad m, AttrValueONKEYUP v) => v -> WithHTML e m ()
  atONKEYUP v = attr "ONKEYUP" (av $ show v)
class AdmitAttrONKEYDOWN e where
  uaONKEYDOWN :: (Monad m) => String -> WithHTML e m ()
  uaONKEYDOWN str = attr "ONKEYDOWN" str
  atONKEYDOWN :: (Monad m, AttrValueONKEYDOWN v) => v -> WithHTML e m ()
  atONKEYDOWN v = attr "ONKEYDOWN" (av $ show v)
class AdmitAttrONKEYPRESS e where
  uaONKEYPRESS :: (Monad m) => String -> WithHTML e m ()
  uaONKEYPRESS str = attr "ONKEYPRESS" str
  atONKEYPRESS :: (Monad m, AttrValueONKEYPRESS v) => v -> WithHTML e m ()
  atONKEYPRESS v = attr "ONKEYPRESS" (av $ show v)
class AdmitAttrONMOUSEOUT e where
  uaONMOUSEOUT :: (Monad m) => String -> WithHTML e m ()
  uaONMOUSEOUT str = attr "ONMOUSEOUT" str
  atONMOUSEOUT :: (Monad m, AttrValueONMOUSEOUT v) => v -> WithHTML e m ()
  atONMOUSEOUT v = attr "ONMOUSEOUT" (av $ show v)
class AdmitAttrONMOUSEMOVE e where
  uaONMOUSEMOVE :: (Monad m) => String -> WithHTML e m ()
  uaONMOUSEMOVE str = attr "ONMOUSEMOVE" str
  atONMOUSEMOVE :: (Monad m, AttrValueONMOUSEMOVE v) => v -> WithHTML e m ()
  atONMOUSEMOVE v = attr "ONMOUSEMOVE" (av $ show v)
class AdmitAttrONMOUSEOVER e where
  uaONMOUSEOVER :: (Monad m) => String -> WithHTML e m ()
  uaONMOUSEOVER str = attr "ONMOUSEOVER" str
  atONMOUSEOVER :: (Monad m, AttrValueONMOUSEOVER v) => v -> WithHTML e m ()
  atONMOUSEOVER v = attr "ONMOUSEOVER" (av $ show v)
class AdmitAttrONMOUSEUP e where
  uaONMOUSEUP :: (Monad m) => String -> WithHTML e m ()
  uaONMOUSEUP str = attr "ONMOUSEUP" str
  atONMOUSEUP :: (Monad m, AttrValueONMOUSEUP v) => v -> WithHTML e m ()
  atONMOUSEUP v = attr "ONMOUSEUP" (av $ show v)
class AdmitAttrONMOUSEDOWN e where
  uaONMOUSEDOWN :: (Monad m) => String -> WithHTML e m ()
  uaONMOUSEDOWN str = attr "ONMOUSEDOWN" str
  atONMOUSEDOWN :: (Monad m, AttrValueONMOUSEDOWN v) => v -> WithHTML e m ()
  atONMOUSEDOWN v = attr "ONMOUSEDOWN" (av $ show v)
class AdmitAttrONDBLCLICK e where
  uaONDBLCLICK :: (Monad m) => String -> WithHTML e m ()
  uaONDBLCLICK str = attr "ONDBLCLICK" str
  atONDBLCLICK :: (Monad m, AttrValueONDBLCLICK v) => v -> WithHTML e m ()
  atONDBLCLICK v = attr "ONDBLCLICK" (av $ show v)
class AdmitAttrONCLICK e where
  uaONCLICK :: (Monad m) => String -> WithHTML e m ()
  uaONCLICK str = attr "ONCLICK" str
  atONCLICK :: (Monad m, AttrValueONCLICK v) => v -> WithHTML e m ()
  atONCLICK v = attr "ONCLICK" (av $ show v)
class AdmitAttrTITLE e where
  uaTITLE :: (Monad m) => String -> WithHTML e m ()
  uaTITLE str = attr "TITLE" str
  atTITLE :: (Monad m, AttrValueTITLE v) => v -> WithHTML e m ()
  atTITLE v = attr "TITLE" (av $ show v)
class AdmitAttrSTYLE e where
  uaSTYLE :: (Monad m) => String -> WithHTML e m ()
  uaSTYLE str = attr "STYLE" str
  atSTYLE :: (Monad m, AttrValueSTYLE v) => v -> WithHTML e m ()
  atSTYLE v = attr "STYLE" (av $ show v)
class AdmitAttrCLASS e where
  uaCLASS :: (Monad m) => String -> WithHTML e m ()
  uaCLASS str = attr "CLASS" str
  atCLASS :: (Monad m, AttrValueCLASS v) => v -> WithHTML e m ()
  atCLASS v = attr "CLASS" (av $ show v)
class AdmitAttrID e where
  uaID :: (Monad m) => String -> WithHTML e m ()
  uaID str = attr "ID" str
  atID :: (Monad m, AttrValueID v) => v -> WithHTML e m ()
  atID v = attr "ID" (av $ show v)
class AdmitAttrFOR e where
  uaFOR :: (Monad m) => String -> WithHTML e m ()
  uaFOR str = attr "FOR" str
  atFOR :: (Monad m, AttrValueFOR v) => v -> WithHTML e m ()
  atFOR v = attr "FOR" (av $ show v)
class AdmitAttrEVENT e where
  uaEVENT :: (Monad m) => String -> WithHTML e m ()
  uaEVENT str = attr "EVENT" str
  atEVENT :: (Monad m, AttrValueEVENT v) => v -> WithHTML e m ()
  atEVENT v = attr "EVENT" (av $ show v)
class AdmitAttrDEFER e where
  uaDEFER :: (Monad m) => String -> WithHTML e m ()
  uaDEFER str = attr "DEFER" str
  atDEFER :: (Monad m, AttrValueDEFER v) => v -> WithHTML e m ()
  atDEFER v = attr "DEFER" (av $ show v)
class AdmitAttrSRC e where
  uaSRC :: (Monad m) => String -> WithHTML e m ()
  uaSRC str = attr "SRC" str
  atSRC :: (Monad m, AttrValueSRC v) => v -> WithHTML e m ()
  atSRC v = attr "SRC" (av $ show v)
class AdmitAttrLANGUAGE e where
  uaLANGUAGE :: (Monad m) => String -> WithHTML e m ()
  uaLANGUAGE str = attr "LANGUAGE" str
  atLANGUAGE :: (Monad m, AttrValueLANGUAGE v) => v -> WithHTML e m ()
  atLANGUAGE v = attr "LANGUAGE" (av $ show v)
class AdmitAttrTYPE e where
  uaTYPE :: (Monad m) => String -> WithHTML e m ()
  uaTYPE str = attr "TYPE" str
  atTYPE :: (Monad m, AttrValueTYPE v) => v -> WithHTML e m ()
  atTYPE v = attr "TYPE" (av $ show v)
class AdmitAttrCHARSET e where
  uaCHARSET :: (Monad m) => String -> WithHTML e m ()
  uaCHARSET str = attr "CHARSET" str
  atCHARSET :: (Monad m, AttrValueCHARSET v) => v -> WithHTML e m ()
  atCHARSET v = attr "CHARSET" (av $ show v)
class AdmitAttrMEDIA e where
  uaMEDIA :: (Monad m) => String -> WithHTML e m ()
  uaMEDIA str = attr "MEDIA" str
  atMEDIA :: (Monad m, AttrValueMEDIA v) => v -> WithHTML e m ()
  atMEDIA v = attr "MEDIA" (av $ show v)
class AdmitAttrSCHEME e where
  uaSCHEME :: (Monad m) => String -> WithHTML e m ()
  uaSCHEME str = attr "SCHEME" str
  atSCHEME :: (Monad m, AttrValueSCHEME v) => v -> WithHTML e m ()
  atSCHEME v = attr "SCHEME" (av $ show v)
class AdmitAttrCONTENT e where
  uaCONTENT :: (Monad m) => String -> WithHTML e m ()
  uaCONTENT str = attr "CONTENT" str
  atCONTENT :: (Monad m, AttrValueCONTENT v) => v -> WithHTML e m ()
  atCONTENT v = attr "CONTENT" (av $ show v)
class AdmitAttrNAME e where
  uaNAME :: (Monad m) => String -> WithHTML e m ()
  uaNAME str = attr "NAME" str
  atNAME :: (Monad m, AttrValueNAME v) => v -> WithHTML e m ()
  atNAME v = attr "NAME" (av $ show v)
class AdmitAttrHTTP_EQUIV e where
  uaHTTP_EQUIV :: (Monad m) => String -> WithHTML e m ()
  uaHTTP_EQUIV str = attr "HTTP_EQUIV" str
  atHTTP_EQUIV :: (Monad m, AttrValueHTTP_EQUIV v) => v -> WithHTML e m ()
  atHTTP_EQUIV v = attr "HTTP_EQUIV" (av $ show v)
class AdmitAttrTARGET e where
  uaTARGET :: (Monad m) => String -> WithHTML e m ()
  uaTARGET str = attr "TARGET" str
  atTARGET :: (Monad m, AttrValueTARGET v) => v -> WithHTML e m ()
  atTARGET v = attr "TARGET" (av $ show v)
class AdmitAttrHREF e where
  uaHREF :: (Monad m) => String -> WithHTML e m ()
  uaHREF str = attr "HREF" str
  atHREF :: (Monad m, AttrValueHREF v) => v -> WithHTML e m ()
  atHREF v = attr "HREF" (av $ show v)
class AdmitAttrPROMPT e where
  uaPROMPT :: (Monad m) => String -> WithHTML e m ()
  uaPROMPT str = attr "PROMPT" str
  atPROMPT :: (Monad m, AttrValuePROMPT v) => v -> WithHTML e m ()
  atPROMPT v = attr "PROMPT" (av $ show v)
class AdmitAttrPROFILE e where
  uaPROFILE :: (Monad m) => String -> WithHTML e m ()
  uaPROFILE str = attr "PROFILE" str
  atPROFILE :: (Monad m, AttrValuePROFILE v) => v -> WithHTML e m ()
  atPROFILE v = attr "PROFILE" (av $ show v)
class AdmitAttrWIDTH e where
  uaWIDTH :: (Monad m) => String -> WithHTML e m ()
  uaWIDTH str = attr "WIDTH" str
  atWIDTH :: (Monad m, AttrValueWIDTH v) => v -> WithHTML e m ()
  atWIDTH v = attr "WIDTH" (av $ show v)
class AdmitAttrHEIGHT e where
  uaHEIGHT :: (Monad m) => String -> WithHTML e m ()
  uaHEIGHT str = attr "HEIGHT" str
  atHEIGHT :: (Monad m, AttrValueHEIGHT v) => v -> WithHTML e m ()
  atHEIGHT v = attr "HEIGHT" (av $ show v)
class AdmitAttrALIGN e where
  uaALIGN :: (Monad m) => String -> WithHTML e m ()
  uaALIGN str = attr "ALIGN" str
  atALIGN :: (Monad m, AttrValueALIGN v) => v -> WithHTML e m ()
  atALIGN v = attr "ALIGN" (av $ show v)
class AdmitAttrSCROLLING e where
  uaSCROLLING :: (Monad m) => String -> WithHTML e m ()
  uaSCROLLING str = attr "SCROLLING" str
  atSCROLLING :: (Monad m, AttrValueSCROLLING v) => v -> WithHTML e m ()
  atSCROLLING v = attr "SCROLLING" (av $ show v)
class AdmitAttrMARGINHEIGHT e where
  uaMARGINHEIGHT :: (Monad m) => String -> WithHTML e m ()
  uaMARGINHEIGHT str = attr "MARGINHEIGHT" str
  atMARGINHEIGHT :: (Monad m, AttrValueMARGINHEIGHT v) => v -> WithHTML e m ()
  atMARGINHEIGHT v = attr "MARGINHEIGHT" (av $ show v)
class AdmitAttrMARGINWIDTH e where
  uaMARGINWIDTH :: (Monad m) => String -> WithHTML e m ()
  uaMARGINWIDTH str = attr "MARGINWIDTH" str
  atMARGINWIDTH :: (Monad m, AttrValueMARGINWIDTH v) => v -> WithHTML e m ()
  atMARGINWIDTH v = attr "MARGINWIDTH" (av $ show v)
class AdmitAttrFRAMEBORDER e where
  uaFRAMEBORDER :: (Monad m) => String -> WithHTML e m ()
  uaFRAMEBORDER str = attr "FRAMEBORDER" str
  atFRAMEBORDER :: (Monad m, AttrValueFRAMEBORDER v) => v -> WithHTML e m ()
  atFRAMEBORDER v = attr "FRAMEBORDER" (av $ show v)
class AdmitAttrLONGDESC e where
  uaLONGDESC :: (Monad m) => String -> WithHTML e m ()
  uaLONGDESC str = attr "LONGDESC" str
  atLONGDESC :: (Monad m, AttrValueLONGDESC v) => v -> WithHTML e m ()
  atLONGDESC v = attr "LONGDESC" (av $ show v)
class AdmitAttrNORESIZE e where
  uaNORESIZE :: (Monad m) => String -> WithHTML e m ()
  uaNORESIZE str = attr "NORESIZE" str
  atNORESIZE :: (Monad m, AttrValueNORESIZE v) => v -> WithHTML e m ()
  atNORESIZE v = attr "NORESIZE" (av $ show v)
class AdmitAttrONUNLOAD e where
  uaONUNLOAD :: (Monad m) => String -> WithHTML e m ()
  uaONUNLOAD str = attr "ONUNLOAD" str
  atONUNLOAD :: (Monad m, AttrValueONUNLOAD v) => v -> WithHTML e m ()
  atONUNLOAD v = attr "ONUNLOAD" (av $ show v)
class AdmitAttrONLOAD e where
  uaONLOAD :: (Monad m) => String -> WithHTML e m ()
  uaONLOAD str = attr "ONLOAD" str
  atONLOAD :: (Monad m, AttrValueONLOAD v) => v -> WithHTML e m ()
  atONLOAD v = attr "ONLOAD" (av $ show v)
class AdmitAttrCOLS e where
  uaCOLS :: (Monad m) => String -> WithHTML e m ()
  uaCOLS str = attr "COLS" str
  atCOLS :: (Monad m, AttrValueCOLS v) => v -> WithHTML e m ()
  atCOLS v = attr "COLS" (av $ show v)
class AdmitAttrROWS e where
  uaROWS :: (Monad m) => String -> WithHTML e m ()
  uaROWS str = attr "ROWS" str
  atROWS :: (Monad m, AttrValueROWS v) => v -> WithHTML e m ()
  atROWS v = attr "ROWS" (av $ show v)
class AdmitAttrBGCOLOR e where
  uaBGCOLOR :: (Monad m) => String -> WithHTML e m ()
  uaBGCOLOR str = attr "BGCOLOR" str
  atBGCOLOR :: (Monad m, AttrValueBGCOLOR v) => v -> WithHTML e m ()
  atBGCOLOR v = attr "BGCOLOR" (av $ show v)
class AdmitAttrNOWRAP e where
  uaNOWRAP :: (Monad m) => String -> WithHTML e m ()
  uaNOWRAP str = attr "NOWRAP" str
  atNOWRAP :: (Monad m, AttrValueNOWRAP v) => v -> WithHTML e m ()
  atNOWRAP v = attr "NOWRAP" (av $ show v)
class AdmitAttrVALIGN e where
  uaVALIGN :: (Monad m) => String -> WithHTML e m ()
  uaVALIGN str = attr "VALIGN" str
  atVALIGN :: (Monad m, AttrValueVALIGN v) => v -> WithHTML e m ()
  atVALIGN v = attr "VALIGN" (av $ show v)
class AdmitAttrCHAROFF e where
  uaCHAROFF :: (Monad m) => String -> WithHTML e m ()
  uaCHAROFF str = attr "CHAROFF" str
  atCHAROFF :: (Monad m, AttrValueCHAROFF v) => v -> WithHTML e m ()
  atCHAROFF v = attr "CHAROFF" (av $ show v)
class AdmitAttrCHAR e where
  uaCHAR :: (Monad m) => String -> WithHTML e m ()
  uaCHAR str = attr "CHAR" str
  atCHAR :: (Monad m, AttrValueCHAR v) => v -> WithHTML e m ()
  atCHAR v = attr "CHAR" (av $ show v)
class AdmitAttrCOLSPAN e where
  uaCOLSPAN :: (Monad m) => String -> WithHTML e m ()
  uaCOLSPAN str = attr "COLSPAN" str
  atCOLSPAN :: (Monad m, AttrValueCOLSPAN v) => v -> WithHTML e m ()
  atCOLSPAN v = attr "COLSPAN" (av $ show v)
class AdmitAttrROWSPAN e where
  uaROWSPAN :: (Monad m) => String -> WithHTML e m ()
  uaROWSPAN str = attr "ROWSPAN" str
  atROWSPAN :: (Monad m, AttrValueROWSPAN v) => v -> WithHTML e m ()
  atROWSPAN v = attr "ROWSPAN" (av $ show v)
class AdmitAttrSCOPE e where
  uaSCOPE :: (Monad m) => String -> WithHTML e m ()
  uaSCOPE str = attr "SCOPE" str
  atSCOPE :: (Monad m, AttrValueSCOPE v) => v -> WithHTML e m ()
  atSCOPE v = attr "SCOPE" (av $ show v)
class AdmitAttrHEADERS e where
  uaHEADERS :: (Monad m) => String -> WithHTML e m ()
  uaHEADERS str = attr "HEADERS" str
  atHEADERS :: (Monad m, AttrValueHEADERS v) => v -> WithHTML e m ()
  atHEADERS v = attr "HEADERS" (av $ show v)
class AdmitAttrAXIS e where
  uaAXIS :: (Monad m) => String -> WithHTML e m ()
  uaAXIS str = attr "AXIS" str
  atAXIS :: (Monad m, AttrValueAXIS v) => v -> WithHTML e m ()
  atAXIS v = attr "AXIS" (av $ show v)
class AdmitAttrABBR e where
  uaABBR :: (Monad m) => String -> WithHTML e m ()
  uaABBR str = attr "ABBR" str
  atABBR :: (Monad m, AttrValueABBR v) => v -> WithHTML e m ()
  atABBR v = attr "ABBR" (av $ show v)
class AdmitAttrSPAN e where
  uaSPAN :: (Monad m) => String -> WithHTML e m ()
  uaSPAN str = attr "SPAN" str
  atSPAN :: (Monad m, AttrValueSPAN v) => v -> WithHTML e m ()
  atSPAN v = attr "SPAN" (av $ show v)
class AdmitAttrDATAPAGESIZE e where
  uaDATAPAGESIZE :: (Monad m) => String -> WithHTML e m ()
  uaDATAPAGESIZE str = attr "DATAPAGESIZE" str
  atDATAPAGESIZE :: (Monad m, AttrValueDATAPAGESIZE v) => v -> WithHTML e m ()
  atDATAPAGESIZE v = attr "DATAPAGESIZE" (av $ show v)
class AdmitAttrCELLPADDING e where
  uaCELLPADDING :: (Monad m) => String -> WithHTML e m ()
  uaCELLPADDING str = attr "CELLPADDING" str
  atCELLPADDING :: (Monad m, AttrValueCELLPADDING v) => v -> WithHTML e m ()
  atCELLPADDING v = attr "CELLPADDING" (av $ show v)
class AdmitAttrCELLSPACING e where
  uaCELLSPACING :: (Monad m) => String -> WithHTML e m ()
  uaCELLSPACING str = attr "CELLSPACING" str
  atCELLSPACING :: (Monad m, AttrValueCELLSPACING v) => v -> WithHTML e m ()
  atCELLSPACING v = attr "CELLSPACING" (av $ show v)
class AdmitAttrRULES e where
  uaRULES :: (Monad m) => String -> WithHTML e m ()
  uaRULES str = attr "RULES" str
  atRULES :: (Monad m, AttrValueRULES v) => v -> WithHTML e m ()
  atRULES v = attr "RULES" (av $ show v)
class AdmitAttrFRAME e where
  uaFRAME :: (Monad m) => String -> WithHTML e m ()
  uaFRAME str = attr "FRAME" str
  atFRAME :: (Monad m, AttrValueFRAME v) => v -> WithHTML e m ()
  atFRAME v = attr "FRAME" (av $ show v)
class AdmitAttrBORDER e where
  uaBORDER :: (Monad m) => String -> WithHTML e m ()
  uaBORDER str = attr "BORDER" str
  atBORDER :: (Monad m, AttrValueBORDER v) => v -> WithHTML e m ()
  atBORDER v = attr "BORDER" (av $ show v)
class AdmitAttrSUMMARY e where
  uaSUMMARY :: (Monad m) => String -> WithHTML e m ()
  uaSUMMARY str = attr "SUMMARY" str
  atSUMMARY :: (Monad m, AttrValueSUMMARY v) => v -> WithHTML e m ()
  atSUMMARY v = attr "SUMMARY" (av $ show v)
class AdmitAttrONBLUR e where
  uaONBLUR :: (Monad m) => String -> WithHTML e m ()
  uaONBLUR str = attr "ONBLUR" str
  atONBLUR :: (Monad m, AttrValueONBLUR v) => v -> WithHTML e m ()
  atONBLUR v = attr "ONBLUR" (av $ show v)
class AdmitAttrONFOCUS e where
  uaONFOCUS :: (Monad m) => String -> WithHTML e m ()
  uaONFOCUS str = attr "ONFOCUS" str
  atONFOCUS :: (Monad m, AttrValueONFOCUS v) => v -> WithHTML e m ()
  atONFOCUS v = attr "ONFOCUS" (av $ show v)
class AdmitAttrACCESSKEY e where
  uaACCESSKEY :: (Monad m) => String -> WithHTML e m ()
  uaACCESSKEY str = attr "ACCESSKEY" str
  atACCESSKEY :: (Monad m, AttrValueACCESSKEY v) => v -> WithHTML e m ()
  atACCESSKEY v = attr "ACCESSKEY" (av $ show v)
class AdmitAttrTABINDEX e where
  uaTABINDEX :: (Monad m) => String -> WithHTML e m ()
  uaTABINDEX str = attr "TABINDEX" str
  atTABINDEX :: (Monad m, AttrValueTABINDEX v) => v -> WithHTML e m ()
  atTABINDEX v = attr "TABINDEX" (av $ show v)
class AdmitAttrDISABLED e where
  uaDISABLED :: (Monad m) => String -> WithHTML e m ()
  uaDISABLED str = attr "DISABLED" str
  atDISABLED :: (Monad m, AttrValueDISABLED v) => v -> WithHTML e m ()
  atDISABLED v = attr "DISABLED" (av $ show v)
class AdmitAttrVALUE e where
  uaVALUE :: (Monad m) => String -> WithHTML e m ()
  uaVALUE str = attr "VALUE" str
  atVALUE :: (Monad m, AttrValueVALUE v) => v -> WithHTML e m ()
  atVALUE v = attr "VALUE" (av $ show v)
class AdmitAttrONCHANGE e where
  uaONCHANGE :: (Monad m) => String -> WithHTML e m ()
  uaONCHANGE str = attr "ONCHANGE" str
  atONCHANGE :: (Monad m, AttrValueONCHANGE v) => v -> WithHTML e m ()
  atONCHANGE v = attr "ONCHANGE" (av $ show v)
class AdmitAttrONSELECT e where
  uaONSELECT :: (Monad m) => String -> WithHTML e m ()
  uaONSELECT str = attr "ONSELECT" str
  atONSELECT :: (Monad m, AttrValueONSELECT v) => v -> WithHTML e m ()
  atONSELECT v = attr "ONSELECT" (av $ show v)
class AdmitAttrREADONLY e where
  uaREADONLY :: (Monad m) => String -> WithHTML e m ()
  uaREADONLY str = attr "READONLY" str
  atREADONLY :: (Monad m, AttrValueREADONLY v) => v -> WithHTML e m ()
  atREADONLY v = attr "READONLY" (av $ show v)
class AdmitAttrLABEL e where
  uaLABEL :: (Monad m) => String -> WithHTML e m ()
  uaLABEL str = attr "LABEL" str
  atLABEL :: (Monad m, AttrValueLABEL v) => v -> WithHTML e m ()
  atLABEL v = attr "LABEL" (av $ show v)
class AdmitAttrSELECTED e where
  uaSELECTED :: (Monad m) => String -> WithHTML e m ()
  uaSELECTED str = attr "SELECTED" str
  atSELECTED :: (Monad m, AttrValueSELECTED v) => v -> WithHTML e m ()
  atSELECTED v = attr "SELECTED" (av $ show v)
class AdmitAttrMULTIPLE e where
  uaMULTIPLE :: (Monad m) => String -> WithHTML e m ()
  uaMULTIPLE str = attr "MULTIPLE" str
  atMULTIPLE :: (Monad m, AttrValueMULTIPLE v) => v -> WithHTML e m ()
  atMULTIPLE v = attr "MULTIPLE" (av $ show v)
class AdmitAttrSIZE e where
  uaSIZE :: (Monad m) => String -> WithHTML e m ()
  uaSIZE str = attr "SIZE" str
  atSIZE :: (Monad m, AttrValueSIZE v) => v -> WithHTML e m ()
  atSIZE v = attr "SIZE" (av $ show v)
class AdmitAttrACCEPT e where
  uaACCEPT :: (Monad m) => String -> WithHTML e m ()
  uaACCEPT str = attr "ACCEPT" str
  atACCEPT :: (Monad m, AttrValueACCEPT v) => v -> WithHTML e m ()
  atACCEPT v = attr "ACCEPT" (av $ show v)
class AdmitAttrISMAP e where
  uaISMAP :: (Monad m) => String -> WithHTML e m ()
  uaISMAP str = attr "ISMAP" str
  atISMAP :: (Monad m, AttrValueISMAP v) => v -> WithHTML e m ()
  atISMAP v = attr "ISMAP" (av $ show v)
class AdmitAttrUSEMAP e where
  uaUSEMAP :: (Monad m) => String -> WithHTML e m ()
  uaUSEMAP str = attr "USEMAP" str
  atUSEMAP :: (Monad m, AttrValueUSEMAP v) => v -> WithHTML e m ()
  atUSEMAP v = attr "USEMAP" (av $ show v)
class AdmitAttrALT e where
  uaALT :: (Monad m) => String -> WithHTML e m ()
  uaALT str = attr "ALT" str
  atALT :: (Monad m, AttrValueALT v) => v -> WithHTML e m ()
  atALT v = attr "ALT" (av $ show v)
class AdmitAttrMAXLENGTH e where
  uaMAXLENGTH :: (Monad m) => String -> WithHTML e m ()
  uaMAXLENGTH str = attr "MAXLENGTH" str
  atMAXLENGTH :: (Monad m, AttrValueMAXLENGTH v) => v -> WithHTML e m ()
  atMAXLENGTH v = attr "MAXLENGTH" (av $ show v)
class AdmitAttrCHECKED e where
  uaCHECKED :: (Monad m) => String -> WithHTML e m ()
  uaCHECKED str = attr "CHECKED" str
  atCHECKED :: (Monad m, AttrValueCHECKED v) => v -> WithHTML e m ()
  atCHECKED v = attr "CHECKED" (av $ show v)
class AdmitAttrACCEPT_CHARSET e where
  uaACCEPT_CHARSET :: (Monad m) => String -> WithHTML e m ()
  uaACCEPT_CHARSET str = attr "ACCEPT_CHARSET" str
  atACCEPT_CHARSET :: (Monad m, AttrValueACCEPT_CHARSET v) => v -> WithHTML e m ()
  atACCEPT_CHARSET v = attr "ACCEPT_CHARSET" (av $ show v)
class AdmitAttrONRESET e where
  uaONRESET :: (Monad m) => String -> WithHTML e m ()
  uaONRESET str = attr "ONRESET" str
  atONRESET :: (Monad m, AttrValueONRESET v) => v -> WithHTML e m ()
  atONRESET v = attr "ONRESET" (av $ show v)
class AdmitAttrONSUBMIT e where
  uaONSUBMIT :: (Monad m) => String -> WithHTML e m ()
  uaONSUBMIT str = attr "ONSUBMIT" str
  atONSUBMIT :: (Monad m, AttrValueONSUBMIT v) => v -> WithHTML e m ()
  atONSUBMIT v = attr "ONSUBMIT" (av $ show v)
class AdmitAttrENCTYPE e where
  uaENCTYPE :: (Monad m) => String -> WithHTML e m ()
  uaENCTYPE str = attr "ENCTYPE" str
  atENCTYPE :: (Monad m, AttrValueENCTYPE v) => v -> WithHTML e m ()
  atENCTYPE v = attr "ENCTYPE" (av $ show v)
class AdmitAttrMETHOD e where
  uaMETHOD :: (Monad m) => String -> WithHTML e m ()
  uaMETHOD str = attr "METHOD" str
  atMETHOD :: (Monad m, AttrValueMETHOD v) => v -> WithHTML e m ()
  atMETHOD v = attr "METHOD" (av $ show v)
class AdmitAttrACTION e where
  uaACTION :: (Monad m) => String -> WithHTML e m ()
  uaACTION str = attr "ACTION" str
  atACTION :: (Monad m, AttrValueACTION v) => v -> WithHTML e m ()
  atACTION v = attr "ACTION" (av $ show v)
class AdmitAttrCOMPACT e where
  uaCOMPACT :: (Monad m) => String -> WithHTML e m ()
  uaCOMPACT str = attr "COMPACT" str
  atCOMPACT :: (Monad m, AttrValueCOMPACT v) => v -> WithHTML e m ()
  atCOMPACT v = attr "COMPACT" (av $ show v)
class AdmitAttrSTART e where
  uaSTART :: (Monad m) => String -> WithHTML e m ()
  uaSTART str = attr "START" str
  atSTART :: (Monad m, AttrValueSTART v) => v -> WithHTML e m ()
  atSTART v = attr "START" (av $ show v)
class AdmitAttrDATETIME e where
  uaDATETIME :: (Monad m) => String -> WithHTML e m ()
  uaDATETIME str = attr "DATETIME" str
  atDATETIME :: (Monad m, AttrValueDATETIME v) => v -> WithHTML e m ()
  atDATETIME v = attr "DATETIME" (av $ show v)
class AdmitAttrCITE e where
  uaCITE :: (Monad m) => String -> WithHTML e m ()
  uaCITE str = attr "CITE" str
  atCITE :: (Monad m, AttrValueCITE v) => v -> WithHTML e m ()
  atCITE v = attr "CITE" (av $ show v)
class AdmitAttrNOSHADE e where
  uaNOSHADE :: (Monad m) => String -> WithHTML e m ()
  uaNOSHADE str = attr "NOSHADE" str
  atNOSHADE :: (Monad m, AttrValueNOSHADE v) => v -> WithHTML e m ()
  atNOSHADE v = attr "NOSHADE" (av $ show v)
class AdmitAttrVSPACE e where
  uaVSPACE :: (Monad m) => String -> WithHTML e m ()
  uaVSPACE str = attr "VSPACE" str
  atVSPACE :: (Monad m, AttrValueVSPACE v) => v -> WithHTML e m ()
  atVSPACE v = attr "VSPACE" (av $ show v)
class AdmitAttrHSPACE e where
  uaHSPACE :: (Monad m) => String -> WithHTML e m ()
  uaHSPACE str = attr "HSPACE" str
  atHSPACE :: (Monad m, AttrValueHSPACE v) => v -> WithHTML e m ()
  atHSPACE v = attr "HSPACE" (av $ show v)
class AdmitAttrOBJECT e where
  uaOBJECT :: (Monad m) => String -> WithHTML e m ()
  uaOBJECT str = attr "OBJECT" str
  atOBJECT :: (Monad m, AttrValueOBJECT v) => v -> WithHTML e m ()
  atOBJECT v = attr "OBJECT" (av $ show v)
class AdmitAttrCODE e where
  uaCODE :: (Monad m) => String -> WithHTML e m ()
  uaCODE str = attr "CODE" str
  atCODE :: (Monad m, AttrValueCODE v) => v -> WithHTML e m ()
  atCODE v = attr "CODE" (av $ show v)
class AdmitAttrARCHIVE e where
  uaARCHIVE :: (Monad m) => String -> WithHTML e m ()
  uaARCHIVE str = attr "ARCHIVE" str
  atARCHIVE :: (Monad m, AttrValueARCHIVE v) => v -> WithHTML e m ()
  atARCHIVE v = attr "ARCHIVE" (av $ show v)
class AdmitAttrCODEBASE e where
  uaCODEBASE :: (Monad m) => String -> WithHTML e m ()
  uaCODEBASE str = attr "CODEBASE" str
  atCODEBASE :: (Monad m, AttrValueCODEBASE v) => v -> WithHTML e m ()
  atCODEBASE v = attr "CODEBASE" (av $ show v)
class AdmitAttrVALUETYPE e where
  uaVALUETYPE :: (Monad m) => String -> WithHTML e m ()
  uaVALUETYPE str = attr "VALUETYPE" str
  atVALUETYPE :: (Monad m, AttrValueVALUETYPE v) => v -> WithHTML e m ()
  atVALUETYPE v = attr "VALUETYPE" (av $ show v)
class AdmitAttrSTANDBY e where
  uaSTANDBY :: (Monad m) => String -> WithHTML e m ()
  uaSTANDBY str = attr "STANDBY" str
  atSTANDBY :: (Monad m, AttrValueSTANDBY v) => v -> WithHTML e m ()
  atSTANDBY v = attr "STANDBY" (av $ show v)
class AdmitAttrCODETYPE e where
  uaCODETYPE :: (Monad m) => String -> WithHTML e m ()
  uaCODETYPE str = attr "CODETYPE" str
  atCODETYPE :: (Monad m, AttrValueCODETYPE v) => v -> WithHTML e m ()
  atCODETYPE v = attr "CODETYPE" (av $ show v)
class AdmitAttrDATA e where
  uaDATA :: (Monad m) => String -> WithHTML e m ()
  uaDATA str = attr "DATA" str
  atDATA :: (Monad m, AttrValueDATA v) => v -> WithHTML e m ()
  atDATA v = attr "DATA" (av $ show v)
class AdmitAttrCLASSID e where
  uaCLASSID :: (Monad m) => String -> WithHTML e m ()
  uaCLASSID str = attr "CLASSID" str
  atCLASSID :: (Monad m, AttrValueCLASSID v) => v -> WithHTML e m ()
  atCLASSID v = attr "CLASSID" (av $ show v)
class AdmitAttrDECLARE e where
  uaDECLARE :: (Monad m) => String -> WithHTML e m ()
  uaDECLARE str = attr "DECLARE" str
  atDECLARE :: (Monad m, AttrValueDECLARE v) => v -> WithHTML e m ()
  atDECLARE v = attr "DECLARE" (av $ show v)
class AdmitAttrREV e where
  uaREV :: (Monad m) => String -> WithHTML e m ()
  uaREV str = attr "REV" str
  atREV :: (Monad m, AttrValueREV v) => v -> WithHTML e m ()
  atREV v = attr "REV" (av $ show v)
class AdmitAttrREL e where
  uaREL :: (Monad m) => String -> WithHTML e m ()
  uaREL str = attr "REL" str
  atREL :: (Monad m, AttrValueREL v) => v -> WithHTML e m ()
  atREL v = attr "REL" (av $ show v)
class AdmitAttrHREFLANG e where
  uaHREFLANG :: (Monad m) => String -> WithHTML e m ()
  uaHREFLANG str = attr "HREFLANG" str
  atHREFLANG :: (Monad m, AttrValueHREFLANG v) => v -> WithHTML e m ()
  atHREFLANG v = attr "HREFLANG" (av $ show v)
class AdmitAttrNOHREF e where
  uaNOHREF :: (Monad m) => String -> WithHTML e m ()
  uaNOHREF str = attr "NOHREF" str
  atNOHREF :: (Monad m, AttrValueNOHREF v) => v -> WithHTML e m ()
  atNOHREF v = attr "NOHREF" (av $ show v)
class AdmitAttrCOORDS e where
  uaCOORDS :: (Monad m) => String -> WithHTML e m ()
  uaCOORDS str = attr "COORDS" str
  atCOORDS :: (Monad m, AttrValueCOORDS v) => v -> WithHTML e m ()
  atCOORDS v = attr "COORDS" (av $ show v)
class AdmitAttrSHAPE e where
  uaSHAPE :: (Monad m) => String -> WithHTML e m ()
  uaSHAPE str = attr "SHAPE" str
  atSHAPE :: (Monad m, AttrValueSHAPE v) => v -> WithHTML e m ()
  atSHAPE v = attr "SHAPE" (av $ show v)
class AdmitAttrALINK e where
  uaALINK :: (Monad m) => String -> WithHTML e m ()
  uaALINK str = attr "ALINK" str
  atALINK :: (Monad m, AttrValueALINK v) => v -> WithHTML e m ()
  atALINK v = attr "ALINK" (av $ show v)
class AdmitAttrVLINK e where
  uaVLINK :: (Monad m) => String -> WithHTML e m ()
  uaVLINK str = attr "VLINK" str
  atVLINK :: (Monad m, AttrValueVLINK v) => v -> WithHTML e m ()
  atVLINK v = attr "VLINK" (av $ show v)
class AdmitAttrLINK e where
  uaLINK :: (Monad m) => String -> WithHTML e m ()
  uaLINK str = attr "LINK" str
  atLINK :: (Monad m, AttrValueLINK v) => v -> WithHTML e m ()
  atLINK v = attr "LINK" (av $ show v)
class AdmitAttrTEXT e where
  uaTEXT :: (Monad m) => String -> WithHTML e m ()
  uaTEXT str = attr "TEXT" str
  atTEXT :: (Monad m, AttrValueTEXT v) => v -> WithHTML e m ()
  atTEXT v = attr "TEXT" (av $ show v)
class AdmitAttrBACKGROUND e where
  uaBACKGROUND :: (Monad m) => String -> WithHTML e m ()
  uaBACKGROUND str = attr "BACKGROUND" str
  atBACKGROUND :: (Monad m, AttrValueBACKGROUND v) => v -> WithHTML e m ()
  atBACKGROUND v = attr "BACKGROUND" (av $ show v)
class AdmitAttrCLEAR e where
  uaCLEAR :: (Monad m) => String -> WithHTML e m ()
  uaCLEAR str = attr "CLEAR" str
  atCLEAR :: (Monad m, AttrValueCLEAR v) => v -> WithHTML e m ()
  atCLEAR v = attr "CLEAR" (av $ show v)
class AdmitAttrFACE e where
  uaFACE :: (Monad m) => String -> WithHTML e m ()
  uaFACE str = attr "FACE" str
  atFACE :: (Monad m, AttrValueFACE v) => v -> WithHTML e m ()
  atFACE v = attr "FACE" (av $ show v)
class AdmitAttrCOLOR e where
  uaCOLOR :: (Monad m) => String -> WithHTML e m ()
  uaCOLOR str = attr "COLOR" str
  atCOLOR :: (Monad m, AttrValueCOLOR v) => v -> WithHTML e m ()
  atCOLOR v = attr "COLOR" (av $ show v)
class Show v => AttrValueABBR v
class Show v => AttrValueACCEPT v
class Show v => AttrValueACCEPT_CHARSET v
class Show v => AttrValueACCESSKEY v
class Show v => AttrValueACTION v
class Show v => AttrValueALIGN v
class Show v => AttrValueALINK v
class Show v => AttrValueALT v
class Show v => AttrValueARCHIVE v
class Show v => AttrValueAXIS v
class Show v => AttrValueBACKGROUND v
class Show v => AttrValueBGCOLOR v
class Show v => AttrValueBORDER v
class Show v => AttrValueCELLPADDING v
class Show v => AttrValueCELLSPACING v
class Show v => AttrValueCHAR v
class Show v => AttrValueCHAROFF v
class Show v => AttrValueCHARSET v
class Show v => AttrValueCHECKED v
class Show v => AttrValueCITE v
class Show v => AttrValueCLASS v
class Show v => AttrValueCLASSID v
class Show v => AttrValueCLEAR v
class Show v => AttrValueCODE v
class Show v => AttrValueCODEBASE v
class Show v => AttrValueCODETYPE v
class Show v => AttrValueCOLOR v
class Show v => AttrValueCOLS v
class Show v => AttrValueCOLSPAN v
class Show v => AttrValueCOMPACT v
class Show v => AttrValueCONTENT v
class Show v => AttrValueCOORDS v
class Show v => AttrValueDATA v
class Show v => AttrValueDATAPAGESIZE v
class Show v => AttrValueDATETIME v
class Show v => AttrValueDECLARE v
class Show v => AttrValueDEFER v
class Show v => AttrValueDIR v
class Show v => AttrValueDISABLED v
class Show v => AttrValueENCTYPE v
class Show v => AttrValueEVENT v
class Show v => AttrValueFACE v
class Show v => AttrValueFOR v
class Show v => AttrValueFRAME v
class Show v => AttrValueFRAMEBORDER v
class Show v => AttrValueHEADERS v
class Show v => AttrValueHEIGHT v
class Show v => AttrValueHREF v
class Show v => AttrValueHREFLANG v
class Show v => AttrValueHSPACE v
class Show v => AttrValueHTTP_EQUIV v
class Show v => AttrValueID v
class Show v => AttrValueISMAP v
class Show v => AttrValueLABEL v
class Show v => AttrValueLANG v
class Show v => AttrValueLANGUAGE v
class Show v => AttrValueLINK v
class Show v => AttrValueLONGDESC v
class Show v => AttrValueMARGINHEIGHT v
class Show v => AttrValueMARGINWIDTH v
class Show v => AttrValueMAXLENGTH v
class Show v => AttrValueMEDIA v
class Show v => AttrValueMETHOD v
class Show v => AttrValueMULTIPLE v
class Show v => AttrValueNAME v
class Show v => AttrValueNOHREF v
class Show v => AttrValueNORESIZE v
class Show v => AttrValueNOSHADE v
class Show v => AttrValueNOWRAP v
class Show v => AttrValueOBJECT v
class Show v => AttrValueONBLUR v
class Show v => AttrValueONCHANGE v
class Show v => AttrValueONCLICK v
class Show v => AttrValueONDBLCLICK v
class Show v => AttrValueONFOCUS v
class Show v => AttrValueONKEYDOWN v
class Show v => AttrValueONKEYPRESS v
class Show v => AttrValueONKEYUP v
class Show v => AttrValueONLOAD v
class Show v => AttrValueONMOUSEDOWN v
class Show v => AttrValueONMOUSEMOVE v
class Show v => AttrValueONMOUSEOUT v
class Show v => AttrValueONMOUSEOVER v
class Show v => AttrValueONMOUSEUP v
class Show v => AttrValueONRESET v
class Show v => AttrValueONSELECT v
class Show v => AttrValueONSUBMIT v
class Show v => AttrValueONUNLOAD v
class Show v => AttrValuePROFILE v
class Show v => AttrValuePROMPT v
class Show v => AttrValueREADONLY v
class Show v => AttrValueREL v
class Show v => AttrValueREV v
class Show v => AttrValueROWS v
class Show v => AttrValueROWSPAN v
class Show v => AttrValueRULES v
class Show v => AttrValueSCHEME v
class Show v => AttrValueSCOPE v
class Show v => AttrValueSCROLLING v
class Show v => AttrValueSELECTED v
class Show v => AttrValueSHAPE v
class Show v => AttrValueSIZE v
class Show v => AttrValueSPAN v
class Show v => AttrValueSRC v
class Show v => AttrValueSTANDBY v
class Show v => AttrValueSTART v
class Show v => AttrValueSTYLE v
class Show v => AttrValueSUMMARY v
class Show v => AttrValueTABINDEX v
class Show v => AttrValueTARGET v
class Show v => AttrValueTEXT v
class Show v => AttrValueTITLE v
class Show v => AttrValueTYPE v
class Show v => AttrValueUSEMAP v
class Show v => AttrValueVALIGN v
class Show v => AttrValueVALUE v
class Show v => AttrValueVALUETYPE v
class Show v => AttrValueVERSION v
class Show v => AttrValueVLINK v
class Show v => AttrValueVSPACE v
class Show v => AttrValueWIDTH v
class AdmitChildA e where
  a :: (Monad m) => WithHTML A m a -> WithHTML e m a
  a = HTMLMonad.a
class AdmitChildABBR e where
  abbr :: (Monad m) => WithHTML ABBR m a -> WithHTML e m a
  abbr = HTMLMonad.abbr
class AdmitChildACRONYM e where
  acronym :: (Monad m) => WithHTML ACRONYM m a -> WithHTML e m a
  acronym = HTMLMonad.acronym
class AdmitChildADDRESS e where
  address :: (Monad m) => WithHTML ADDRESS m a -> WithHTML e m a
  address = HTMLMonad.address
class AdmitChildAPPLET e where
  applet :: (Monad m) => WithHTML APPLET m a -> WithHTML e m a
  applet = HTMLMonad.applet
class AdmitChildAREA e where
  area :: (Monad m) => WithHTML AREA m a -> WithHTML e m a
  area = HTMLMonad.area
class AdmitChildB e where
  b :: (Monad m) => WithHTML B m a -> WithHTML e m a
  b = HTMLMonad.b
class AdmitChildBASE e where
  base :: (Monad m) => WithHTML BASE m a -> WithHTML e m a
  base = HTMLMonad.base
class AdmitChildBASEFONT e where
  basefont :: (Monad m) => WithHTML BASEFONT m a -> WithHTML e m a
  basefont = HTMLMonad.basefont
class AdmitChildBDO e where
  bdo :: (Monad m) => WithHTML BDO m a -> WithHTML e m a
  bdo = HTMLMonad.bdo
class AdmitChildBIG e where
  big :: (Monad m) => WithHTML BIG m a -> WithHTML e m a
  big = HTMLMonad.big
class AdmitChildBLOCKQUOTE e where
  blockquote :: (Monad m) => WithHTML BLOCKQUOTE m a -> WithHTML e m a
  blockquote = HTMLMonad.blockquote
class AdmitChildBODY e where
  body :: (Monad m) => WithHTML BODY m a -> WithHTML e m a
  body = HTMLMonad.body
class AdmitChildBR e where
  br :: (Monad m) => WithHTML BR m a -> WithHTML e m a
  br = HTMLMonad.br
class AdmitChildBUTTON e where
  button :: (Monad m) => WithHTML BUTTON m a -> WithHTML e m a
  button = HTMLMonad.button
class AdmitChildCAPTION e where
  caption :: (Monad m) => WithHTML CAPTION m a -> WithHTML e m a
  caption = HTMLMonad.caption
class AdmitChildCENTER e where
  center :: (Monad m) => WithHTML CENTER m a -> WithHTML e m a
  center = HTMLMonad.center
class AdmitChildCITE e where
  cite :: (Monad m) => WithHTML CITE m a -> WithHTML e m a
  cite = HTMLMonad.cite
class AdmitChildCODE e where
  code :: (Monad m) => WithHTML CODE m a -> WithHTML e m a
  code = HTMLMonad.code
class AdmitChildCOL e where
  col :: (Monad m) => WithHTML COL m a -> WithHTML e m a
  col = HTMLMonad.col
class AdmitChildCOLGROUP e where
  colgroup :: (Monad m) => WithHTML COLGROUP m a -> WithHTML e m a
  colgroup = HTMLMonad.colgroup
class AdmitChildDD e where
  dd :: (Monad m) => WithHTML DD m a -> WithHTML e m a
  dd = HTMLMonad.dd
class AdmitChildDEL e where
  del :: (Monad m) => WithHTML DEL m a -> WithHTML e m a
  del = HTMLMonad.del
class AdmitChildDFN e where
  dfn :: (Monad m) => WithHTML DFN m a -> WithHTML e m a
  dfn = HTMLMonad.dfn
class AdmitChildDIR e where
  dir :: (Monad m) => WithHTML DIR m a -> WithHTML e m a
  dir = HTMLMonad.dir
class AdmitChildDIV e where
  div :: (Monad m) => WithHTML DIV m a -> WithHTML e m a
  div = HTMLMonad.div
class AdmitChildDL e where
  dl :: (Monad m) => WithHTML DL m a -> WithHTML e m a
  dl = HTMLMonad.dl
class AdmitChildDT e where
  dt :: (Monad m) => WithHTML DT m a -> WithHTML e m a
  dt = HTMLMonad.dt
class AdmitChildEM e where
  em :: (Monad m) => WithHTML EM m a -> WithHTML e m a
  em = HTMLMonad.em
class AdmitChildFIELDSET e where
  fieldset :: (Monad m) => WithHTML FIELDSET m a -> WithHTML e m a
  fieldset = HTMLMonad.fieldset
class AdmitChildFONT e where
  font :: (Monad m) => WithHTML FONT m a -> WithHTML e m a
  font = HTMLMonad.font
class AdmitChildFORM e where
  form :: (Monad m) => WithHTML FORM m a -> WithHTML e m a
  form = HTMLMonad.form
class AdmitChildFRAME e where
  frame :: (Monad m) => WithHTML FRAME m a -> WithHTML e m a
  frame = HTMLMonad.frame
class AdmitChildFRAMESET e where
  frameset :: (Monad m) => WithHTML FRAMESET m a -> WithHTML e m a
  frameset = HTMLMonad.frameset
class AdmitChildH1 e where
  h1 :: (Monad m) => WithHTML H1 m a -> WithHTML e m a
  h1 = HTMLMonad.h1
class AdmitChildH2 e where
  h2 :: (Monad m) => WithHTML H2 m a -> WithHTML e m a
  h2 = HTMLMonad.h2
class AdmitChildH3 e where
  h3 :: (Monad m) => WithHTML H3 m a -> WithHTML e m a
  h3 = HTMLMonad.h3
class AdmitChildH4 e where
  h4 :: (Monad m) => WithHTML H4 m a -> WithHTML e m a
  h4 = HTMLMonad.h4
class AdmitChildH5 e where
  h5 :: (Monad m) => WithHTML H5 m a -> WithHTML e m a
  h5 = HTMLMonad.h5
class AdmitChildH6 e where
  h6 :: (Monad m) => WithHTML H6 m a -> WithHTML e m a
  h6 = HTMLMonad.h6
class AdmitChildHEAD e where
  head :: (Monad m) => WithHTML HEAD m a -> WithHTML e m a
  head = HTMLMonad.head
class AdmitChildHR e where
  hr :: (Monad m) => WithHTML HR m a -> WithHTML e m a
  hr = HTMLMonad.hr
class AdmitChildHTML e where
  html :: (Monad m) => WithHTML HTML m a -> WithHTML e m a
  html = HTMLMonad.html
class AdmitChildI e where
  i :: (Monad m) => WithHTML I m a -> WithHTML e m a
  i = HTMLMonad.i
class AdmitChildIFRAME e where
  iframe :: (Monad m) => WithHTML IFRAME m a -> WithHTML e m a
  iframe = HTMLMonad.iframe
class AdmitChildIMG e where
  img :: (Monad m) => WithHTML IMG m a -> WithHTML e m a
  img = HTMLMonad.img
class AdmitChildINPUT e where
  input :: (Monad m) => WithHTML INPUT m a -> WithHTML e m a
  input = HTMLMonad.input
class AdmitChildINS e where
  ins :: (Monad m) => WithHTML INS m a -> WithHTML e m a
  ins = HTMLMonad.ins
class AdmitChildISINDEX e where
  isindex :: (Monad m) => WithHTML ISINDEX m a -> WithHTML e m a
  isindex = HTMLMonad.isindex
class AdmitChildKBD e where
  kbd :: (Monad m) => WithHTML KBD m a -> WithHTML e m a
  kbd = HTMLMonad.kbd
class AdmitChildLABEL e where
  label :: (Monad m) => WithHTML LABEL m a -> WithHTML e m a
  label = HTMLMonad.label
class AdmitChildLEGEND e where
  legend :: (Monad m) => WithHTML LEGEND m a -> WithHTML e m a
  legend = HTMLMonad.legend
class AdmitChildLI e where
  li :: (Monad m) => WithHTML LI m a -> WithHTML e m a
  li = HTMLMonad.li
class AdmitChildLINK e where
  link :: (Monad m) => WithHTML LINK m a -> WithHTML e m a
  link = HTMLMonad.link
class AdmitChildMAP e where
  map :: (Monad m) => WithHTML MAP m a -> WithHTML e m a
  map = HTMLMonad.map
class AdmitChildMENU e where
  menu :: (Monad m) => WithHTML MENU m a -> WithHTML e m a
  menu = HTMLMonad.menu
class AdmitChildMETA e where
  meta :: (Monad m) => WithHTML META m a -> WithHTML e m a
  meta = HTMLMonad.meta
class AdmitChildNOFRAMES e where
  noframes :: (Monad m) => WithHTML NOFRAMES m a -> WithHTML e m a
  noframes = HTMLMonad.noframes
class AdmitChildNOSCRIPT e where
  noscript :: (Monad m) => WithHTML NOSCRIPT m a -> WithHTML e m a
  noscript = HTMLMonad.noscript
class AdmitChildOBJECT e where
  object :: (Monad m) => WithHTML OBJECT m a -> WithHTML e m a
  object = HTMLMonad.object
class AdmitChildOL e where
  ol :: (Monad m) => WithHTML OL m a -> WithHTML e m a
  ol = HTMLMonad.ol
class AdmitChildOPTGROUP e where
  optgroup :: (Monad m) => WithHTML OPTGROUP m a -> WithHTML e m a
  optgroup = HTMLMonad.optgroup
class AdmitChildOPTION e where
  option :: (Monad m) => WithHTML OPTION m a -> WithHTML e m a
  option = HTMLMonad.option
class AdmitChildP e where
  p :: (Monad m) => WithHTML P m a -> WithHTML e m a
  p = HTMLMonad.p
class AdmitChildPARAM e where
  param :: (Monad m) => WithHTML PARAM m a -> WithHTML e m a
  param = HTMLMonad.param
class AdmitChildPRE e where
  pre :: (Monad m) => WithHTML PRE m a -> WithHTML e m a
  pre = HTMLMonad.pre
class AdmitChildQ e where
  q :: (Monad m) => WithHTML Q m a -> WithHTML e m a
  q = HTMLMonad.q
class AdmitChildS e where
  s :: (Monad m) => WithHTML S m a -> WithHTML e m a
  s = HTMLMonad.s
class AdmitChildSAMP e where
  samp :: (Monad m) => WithHTML SAMP m a -> WithHTML e m a
  samp = HTMLMonad.samp
class AdmitChildSCRIPT e where
  script :: (Monad m) => WithHTML SCRIPT m a -> WithHTML e m a
  script = HTMLMonad.script
class AdmitChildSELECT e where
  select :: (Monad m) => WithHTML SELECT m a -> WithHTML e m a
  select = HTMLMonad.select
class AdmitChildSMALL e where
  small :: (Monad m) => WithHTML SMALL m a -> WithHTML e m a
  small = HTMLMonad.small
class AdmitChildSPAN e where
  span :: (Monad m) => WithHTML SPAN m a -> WithHTML e m a
  span = HTMLMonad.span
class AdmitChildSTRIKE e where
  strike :: (Monad m) => WithHTML STRIKE m a -> WithHTML e m a
  strike = HTMLMonad.strike
class AdmitChildSTRONG e where
  strong :: (Monad m) => WithHTML STRONG m a -> WithHTML e m a
  strong = HTMLMonad.strong
class AdmitChildSTYLE e where
  style :: (Monad m) => WithHTML STYLE m a -> WithHTML e m a
  style = HTMLMonad.style
class AdmitChildSUB e where
  sub :: (Monad m) => WithHTML SUB m a -> WithHTML e m a
  sub = HTMLMonad.sub
class AdmitChildSUP e where
  sup :: (Monad m) => WithHTML SUP m a -> WithHTML e m a
  sup = HTMLMonad.sup
class AdmitChildTABLE e where
  table :: (Monad m) => WithHTML TABLE m a -> WithHTML e m a
  table = HTMLMonad.table
class AdmitChildTBODY e where
  tbody :: (Monad m) => WithHTML TBODY m a -> WithHTML e m a
  tbody = HTMLMonad.tbody
class AdmitChildTD e where
  td :: (Monad m) => WithHTML TD m a -> WithHTML e m a
  td = HTMLMonad.td
class AdmitChildTEXTAREA e where
  textarea :: (Monad m) => WithHTML TEXTAREA m a -> WithHTML e m a
  textarea = HTMLMonad.textarea
class AdmitChildTFOOT e where
  tfoot :: (Monad m) => WithHTML TFOOT m a -> WithHTML e m a
  tfoot = HTMLMonad.tfoot
class AdmitChildTH e where
  th :: (Monad m) => WithHTML TH m a -> WithHTML e m a
  th = HTMLMonad.th
class AdmitChildTHEAD e where
  thead :: (Monad m) => WithHTML THEAD m a -> WithHTML e m a
  thead = HTMLMonad.thead
class AdmitChildTITLE e where
  title :: (Monad m) => WithHTML TITLE m a -> WithHTML e m a
  title = HTMLMonad.title
class AdmitChildTR e where
  tr :: (Monad m) => WithHTML TR m a -> WithHTML e m a
  tr = HTMLMonad.tr
class AdmitChildTT e where
  tt :: (Monad m) => WithHTML TT m a -> WithHTML e m a
  tt = HTMLMonad.tt
class AdmitChildU e where
  u :: (Monad m) => WithHTML U m a -> WithHTML e m a
  u = HTMLMonad.u
class AdmitChildUL e where
  ul :: (Monad m) => WithHTML UL m a -> WithHTML e m a
  ul = HTMLMonad.ul
class AdmitChildVAR e where
  var :: (Monad m) => WithHTML VAR m a -> WithHTML e m a
  var = HTMLMonad.var
data A = A
instance Show A where show A = "A"
data ABBR = ABBR
instance Show ABBR where show ABBR = "ABBR"
data ACRONYM = ACRONYM
instance Show ACRONYM where show ACRONYM = "ACRONYM"
data ADDRESS = ADDRESS
instance Show ADDRESS where show ADDRESS = "ADDRESS"
data APPLET = APPLET
instance Show APPLET where show APPLET = "APPLET"
data AREA = AREA
instance Show AREA where show AREA = "AREA"
data B = B
instance Show B where show B = "B"
data BASE = BASE
instance Show BASE where show BASE = "BASE"
data BASEFONT = BASEFONT
instance Show BASEFONT where show BASEFONT = "BASEFONT"
data BDO = BDO
instance Show BDO where show BDO = "BDO"
data BIG = BIG
instance Show BIG where show BIG = "BIG"
data BLOCKQUOTE = BLOCKQUOTE
instance Show BLOCKQUOTE where show BLOCKQUOTE = "BLOCKQUOTE"
data BODY = BODY
instance Show BODY where show BODY = "BODY"
data BR = BR
instance Show BR where show BR = "BR"
data BUTTON = BUTTON
instance Show BUTTON where show BUTTON = "BUTTON"
data CAPTION = CAPTION
instance Show CAPTION where show CAPTION = "CAPTION"
data CENTER = CENTER
instance Show CENTER where show CENTER = "CENTER"
data CITE = CITE
instance Show CITE where show CITE = "CITE"
data CODE = CODE
instance Show CODE where show CODE = "CODE"
data COL = COL
instance Show COL where show COL = "COL"
data COLGROUP = COLGROUP
instance Show COLGROUP where show COLGROUP = "COLGROUP"
data DD = DD
instance Show DD where show DD = "DD"
data DEL = DEL
instance Show DEL where show DEL = "DEL"
data DFN = DFN
instance Show DFN where show DFN = "DFN"
data DIR = DIR
instance Show DIR where show DIR = "DIR"
data DIV = DIV
instance Show DIV where show DIV = "DIV"
data DL = DL
instance Show DL where show DL = "DL"
data DT = DT
instance Show DT where show DT = "DT"
data EM = EM
instance Show EM where show EM = "EM"
data FIELDSET = FIELDSET
instance Show FIELDSET where show FIELDSET = "FIELDSET"
data FONT = FONT
instance Show FONT where show FONT = "FONT"
data FORM = FORM
instance Show FORM where show FORM = "FORM"
data FRAME = FRAME
instance Show FRAME where show FRAME = "FRAME"
data FRAMESET = FRAMESET
instance Show FRAMESET where show FRAMESET = "FRAMESET"
data H1 = H1
instance Show H1 where show H1 = "H1"
data H2 = H2
instance Show H2 where show H2 = "H2"
data H3 = H3
instance Show H3 where show H3 = "H3"
data H4 = H4
instance Show H4 where show H4 = "H4"
data H5 = H5
instance Show H5 where show H5 = "H5"
data H6 = H6
instance Show H6 where show H6 = "H6"
data HEAD = HEAD
instance Show HEAD where show HEAD = "HEAD"
data HR = HR
instance Show HR where show HR = "HR"
data HTML = HTML
instance Show HTML where show HTML = "HTML"
data I = I
instance Show I where show I = "I"
data IFRAME = IFRAME
instance Show IFRAME where show IFRAME = "IFRAME"
data IMG = IMG
instance Show IMG where show IMG = "IMG"
data INPUT = INPUT
instance Show INPUT where show INPUT = "INPUT"
data INS = INS
instance Show INS where show INS = "INS"
data ISINDEX = ISINDEX
instance Show ISINDEX where show ISINDEX = "ISINDEX"
data KBD = KBD
instance Show KBD where show KBD = "KBD"
data LABEL = LABEL
instance Show LABEL where show LABEL = "LABEL"
data LEGEND = LEGEND
instance Show LEGEND where show LEGEND = "LEGEND"
data LI = LI
instance Show LI where show LI = "LI"
data LINK = LINK
instance Show LINK where show LINK = "LINK"
data MAP = MAP
instance Show MAP where show MAP = "MAP"
data MENU = MENU
instance Show MENU where show MENU = "MENU"
data META = META
instance Show META where show META = "META"
data NOFRAMES = NOFRAMES
instance Show NOFRAMES where show NOFRAMES = "NOFRAMES"
data NOSCRIPT = NOSCRIPT
instance Show NOSCRIPT where show NOSCRIPT = "NOSCRIPT"
data OBJECT = OBJECT
instance Show OBJECT where show OBJECT = "OBJECT"
data OL = OL
instance Show OL where show OL = "OL"
data OPTGROUP = OPTGROUP
instance Show OPTGROUP where show OPTGROUP = "OPTGROUP"
data OPTION = OPTION
instance Show OPTION where show OPTION = "OPTION"
data P = P
instance Show P where show P = "P"
data PARAM = PARAM
instance Show PARAM where show PARAM = "PARAM"
data PRE = PRE
instance Show PRE where show PRE = "PRE"
data Q = Q
instance Show Q where show Q = "Q"
data S = S
instance Show S where show S = "S"
data SAMP = SAMP
instance Show SAMP where show SAMP = "SAMP"
data SCRIPT = SCRIPT
instance Show SCRIPT where show SCRIPT = "SCRIPT"
data SELECT = SELECT
instance Show SELECT where show SELECT = "SELECT"
data SMALL = SMALL
instance Show SMALL where show SMALL = "SMALL"
data SPAN = SPAN
instance Show SPAN where show SPAN = "SPAN"
data STRIKE = STRIKE
instance Show STRIKE where show STRIKE = "STRIKE"
data STRONG = STRONG
instance Show STRONG where show STRONG = "STRONG"
data STYLE = STYLE
instance Show STYLE where show STYLE = "STYLE"
data SUB = SUB
instance Show SUB where show SUB = "SUB"
data SUP = SUP
instance Show SUP where show SUP = "SUP"
data TABLE = TABLE
instance Show TABLE where show TABLE = "TABLE"
data TBODY = TBODY
instance Show TBODY where show TBODY = "TBODY"
data TD = TD
instance Show TD where show TD = "TD"
data TEXTAREA = TEXTAREA
instance Show TEXTAREA where show TEXTAREA = "TEXTAREA"
data TFOOT = TFOOT
instance Show TFOOT where show TFOOT = "TFOOT"
data TH = TH
instance Show TH where show TH = "TH"
data THEAD = THEAD
instance Show THEAD where show THEAD = "THEAD"
data TITLE = TITLE
instance Show TITLE where show TITLE = "TITLE"
data TR = TR
instance Show TR where show TR = "TR"
data TT = TT
instance Show TT where show TT = "TT"
data U = U
instance Show U where show U = "U"
data UL = UL
instance Show UL where show UL = "UL"
data VAR = VAR
instance Show VAR where show VAR = "VAR"

instance AdmitChildHEAD HTML
instance AdmitChildFRAMESET HTML

instance AdmitChildP NOSCRIPT
instance AdmitChildH1 NOSCRIPT
instance AdmitChildH2 NOSCRIPT
instance AdmitChildH3 NOSCRIPT
instance AdmitChildH4 NOSCRIPT
instance AdmitChildH5 NOSCRIPT
instance AdmitChildH6 NOSCRIPT
instance AdmitChildUL NOSCRIPT
instance AdmitChildOL NOSCRIPT
instance AdmitChildDIR NOSCRIPT
instance AdmitChildMENU NOSCRIPT
instance AdmitChildPRE NOSCRIPT
instance AdmitChildDL NOSCRIPT
instance AdmitChildDIV NOSCRIPT
instance AdmitChildCENTER NOSCRIPT
instance AdmitChildNOSCRIPT NOSCRIPT
instance AdmitChildNOFRAMES NOSCRIPT
instance AdmitChildBLOCKQUOTE NOSCRIPT
instance AdmitChildFORM NOSCRIPT
instance AdmitChildISINDEX NOSCRIPT
instance AdmitChildHR NOSCRIPT
instance AdmitChildTABLE NOSCRIPT
instance AdmitChildFIELDSET NOSCRIPT
instance AdmitChildADDRESS NOSCRIPT
instance AdmitChildCDATA NOSCRIPT
instance AdmitChildTT NOSCRIPT
instance AdmitChildI NOSCRIPT
instance AdmitChildB NOSCRIPT
instance AdmitChildU NOSCRIPT
instance AdmitChildS NOSCRIPT
instance AdmitChildSTRIKE NOSCRIPT
instance AdmitChildBIG NOSCRIPT
instance AdmitChildSMALL NOSCRIPT
instance AdmitChildEM NOSCRIPT
instance AdmitChildSTRONG NOSCRIPT
instance AdmitChildDFN NOSCRIPT
instance AdmitChildCODE NOSCRIPT
instance AdmitChildSAMP NOSCRIPT
instance AdmitChildKBD NOSCRIPT
instance AdmitChildVAR NOSCRIPT
instance AdmitChildCITE NOSCRIPT
instance AdmitChildABBR NOSCRIPT
instance AdmitChildACRONYM NOSCRIPT
instance AdmitChildA NOSCRIPT
instance AdmitChildIMG NOSCRIPT
instance AdmitChildAPPLET NOSCRIPT
instance AdmitChildOBJECT NOSCRIPT
instance AdmitChildFONT NOSCRIPT
instance AdmitChildBASEFONT NOSCRIPT
instance AdmitChildBR NOSCRIPT
instance AdmitChildSCRIPT NOSCRIPT
instance AdmitChildMAP NOSCRIPT
instance AdmitChildQ NOSCRIPT
instance AdmitChildSUB NOSCRIPT
instance AdmitChildSUP NOSCRIPT
instance AdmitChildSPAN NOSCRIPT
instance AdmitChildBDO NOSCRIPT
instance AdmitChildIFRAME NOSCRIPT
instance AdmitChildINPUT NOSCRIPT
instance AdmitChildSELECT NOSCRIPT
instance AdmitChildTEXTAREA NOSCRIPT
instance AdmitChildLABEL NOSCRIPT
instance AdmitChildBUTTON NOSCRIPT

instance AdmitChildCDATA SCRIPT

instance AdmitChildCDATA STYLE




instance AdmitChildCDATA TITLE

instance AdmitChildTITLE HEAD
instance AdmitChildISINDEX HEAD
instance AdmitChildBASE HEAD
instance AdmitChildSCRIPT HEAD
instance AdmitChildSTYLE HEAD
instance AdmitChildMETA HEAD
instance AdmitChildLINK HEAD
instance AdmitChildOBJECT HEAD

instance AdmitChildBODY NOFRAMES

instance AdmitChildP IFRAME
instance AdmitChildH1 IFRAME
instance AdmitChildH2 IFRAME
instance AdmitChildH3 IFRAME
instance AdmitChildH4 IFRAME
instance AdmitChildH5 IFRAME
instance AdmitChildH6 IFRAME
instance AdmitChildUL IFRAME
instance AdmitChildOL IFRAME
instance AdmitChildDIR IFRAME
instance AdmitChildMENU IFRAME
instance AdmitChildPRE IFRAME
instance AdmitChildDL IFRAME
instance AdmitChildDIV IFRAME
instance AdmitChildCENTER IFRAME
instance AdmitChildNOSCRIPT IFRAME
instance AdmitChildNOFRAMES IFRAME
instance AdmitChildBLOCKQUOTE IFRAME
instance AdmitChildFORM IFRAME
instance AdmitChildISINDEX IFRAME
instance AdmitChildHR IFRAME
instance AdmitChildTABLE IFRAME
instance AdmitChildFIELDSET IFRAME
instance AdmitChildADDRESS IFRAME
instance AdmitChildCDATA IFRAME
instance AdmitChildTT IFRAME
instance AdmitChildI IFRAME
instance AdmitChildB IFRAME
instance AdmitChildU IFRAME
instance AdmitChildS IFRAME
instance AdmitChildSTRIKE IFRAME
instance AdmitChildBIG IFRAME
instance AdmitChildSMALL IFRAME
instance AdmitChildEM IFRAME
instance AdmitChildSTRONG IFRAME
instance AdmitChildDFN IFRAME
instance AdmitChildCODE IFRAME
instance AdmitChildSAMP IFRAME
instance AdmitChildKBD IFRAME
instance AdmitChildVAR IFRAME
instance AdmitChildCITE IFRAME
instance AdmitChildABBR IFRAME
instance AdmitChildACRONYM IFRAME
instance AdmitChildA IFRAME
instance AdmitChildIMG IFRAME
instance AdmitChildAPPLET IFRAME
instance AdmitChildOBJECT IFRAME
instance AdmitChildFONT IFRAME
instance AdmitChildBASEFONT IFRAME
instance AdmitChildBR IFRAME
instance AdmitChildSCRIPT IFRAME
instance AdmitChildMAP IFRAME
instance AdmitChildQ IFRAME
instance AdmitChildSUB IFRAME
instance AdmitChildSUP IFRAME
instance AdmitChildSPAN IFRAME
instance AdmitChildBDO IFRAME
instance AdmitChildIFRAME IFRAME
instance AdmitChildINPUT IFRAME
instance AdmitChildSELECT IFRAME
instance AdmitChildTEXTAREA IFRAME
instance AdmitChildLABEL IFRAME
instance AdmitChildBUTTON IFRAME


instance AdmitChildFRAMESET FRAMESET
instance AdmitChildFRAME FRAMESET
instance AdmitChildNOFRAMES FRAMESET

instance AdmitChildP TH
instance AdmitChildH1 TH
instance AdmitChildH2 TH
instance AdmitChildH3 TH
instance AdmitChildH4 TH
instance AdmitChildH5 TH
instance AdmitChildH6 TH
instance AdmitChildUL TH
instance AdmitChildOL TH
instance AdmitChildDIR TH
instance AdmitChildMENU TH
instance AdmitChildPRE TH
instance AdmitChildDL TH
instance AdmitChildDIV TH
instance AdmitChildCENTER TH
instance AdmitChildNOSCRIPT TH
instance AdmitChildNOFRAMES TH
instance AdmitChildBLOCKQUOTE TH
instance AdmitChildFORM TH
instance AdmitChildISINDEX TH
instance AdmitChildHR TH
instance AdmitChildTABLE TH
instance AdmitChildFIELDSET TH
instance AdmitChildADDRESS TH
instance AdmitChildCDATA TH
instance AdmitChildTT TH
instance AdmitChildI TH
instance AdmitChildB TH
instance AdmitChildU TH
instance AdmitChildS TH
instance AdmitChildSTRIKE TH
instance AdmitChildBIG TH
instance AdmitChildSMALL TH
instance AdmitChildEM TH
instance AdmitChildSTRONG TH
instance AdmitChildDFN TH
instance AdmitChildCODE TH
instance AdmitChildSAMP TH
instance AdmitChildKBD TH
instance AdmitChildVAR TH
instance AdmitChildCITE TH
instance AdmitChildABBR TH
instance AdmitChildACRONYM TH
instance AdmitChildA TH
instance AdmitChildIMG TH
instance AdmitChildAPPLET TH
instance AdmitChildOBJECT TH
instance AdmitChildFONT TH
instance AdmitChildBASEFONT TH
instance AdmitChildBR TH
instance AdmitChildSCRIPT TH
instance AdmitChildMAP TH
instance AdmitChildQ TH
instance AdmitChildSUB TH
instance AdmitChildSUP TH
instance AdmitChildSPAN TH
instance AdmitChildBDO TH
instance AdmitChildIFRAME TH
instance AdmitChildINPUT TH
instance AdmitChildSELECT TH
instance AdmitChildTEXTAREA TH
instance AdmitChildLABEL TH
instance AdmitChildBUTTON TH

instance AdmitChildP TD
instance AdmitChildH1 TD
instance AdmitChildH2 TD
instance AdmitChildH3 TD
instance AdmitChildH4 TD
instance AdmitChildH5 TD
instance AdmitChildH6 TD
instance AdmitChildUL TD
instance AdmitChildOL TD
instance AdmitChildDIR TD
instance AdmitChildMENU TD
instance AdmitChildPRE TD
instance AdmitChildDL TD
instance AdmitChildDIV TD
instance AdmitChildCENTER TD
instance AdmitChildNOSCRIPT TD
instance AdmitChildNOFRAMES TD
instance AdmitChildBLOCKQUOTE TD
instance AdmitChildFORM TD
instance AdmitChildISINDEX TD
instance AdmitChildHR TD
instance AdmitChildTABLE TD
instance AdmitChildFIELDSET TD
instance AdmitChildADDRESS TD
instance AdmitChildCDATA TD
instance AdmitChildTT TD
instance AdmitChildI TD
instance AdmitChildB TD
instance AdmitChildU TD
instance AdmitChildS TD
instance AdmitChildSTRIKE TD
instance AdmitChildBIG TD
instance AdmitChildSMALL TD
instance AdmitChildEM TD
instance AdmitChildSTRONG TD
instance AdmitChildDFN TD
instance AdmitChildCODE TD
instance AdmitChildSAMP TD
instance AdmitChildKBD TD
instance AdmitChildVAR TD
instance AdmitChildCITE TD
instance AdmitChildABBR TD
instance AdmitChildACRONYM TD
instance AdmitChildA TD
instance AdmitChildIMG TD
instance AdmitChildAPPLET TD
instance AdmitChildOBJECT TD
instance AdmitChildFONT TD
instance AdmitChildBASEFONT TD
instance AdmitChildBR TD
instance AdmitChildSCRIPT TD
instance AdmitChildMAP TD
instance AdmitChildQ TD
instance AdmitChildSUB TD
instance AdmitChildSUP TD
instance AdmitChildSPAN TD
instance AdmitChildBDO TD
instance AdmitChildIFRAME TD
instance AdmitChildINPUT TD
instance AdmitChildSELECT TD
instance AdmitChildTEXTAREA TD
instance AdmitChildLABEL TD
instance AdmitChildBUTTON TD

instance AdmitChildTH TR
instance AdmitChildTD TR


instance AdmitChildCOL COLGROUP

instance AdmitChildTR TBODY

instance AdmitChildTR TFOOT

instance AdmitChildTR THEAD

instance AdmitChildCDATA CAPTION
instance AdmitChildTT CAPTION
instance AdmitChildI CAPTION
instance AdmitChildB CAPTION
instance AdmitChildU CAPTION
instance AdmitChildS CAPTION
instance AdmitChildSTRIKE CAPTION
instance AdmitChildBIG CAPTION
instance AdmitChildSMALL CAPTION
instance AdmitChildEM CAPTION
instance AdmitChildSTRONG CAPTION
instance AdmitChildDFN CAPTION
instance AdmitChildCODE CAPTION
instance AdmitChildSAMP CAPTION
instance AdmitChildKBD CAPTION
instance AdmitChildVAR CAPTION
instance AdmitChildCITE CAPTION
instance AdmitChildABBR CAPTION
instance AdmitChildACRONYM CAPTION
instance AdmitChildA CAPTION
instance AdmitChildIMG CAPTION
instance AdmitChildAPPLET CAPTION
instance AdmitChildOBJECT CAPTION
instance AdmitChildFONT CAPTION
instance AdmitChildBASEFONT CAPTION
instance AdmitChildBR CAPTION
instance AdmitChildSCRIPT CAPTION
instance AdmitChildMAP CAPTION
instance AdmitChildQ CAPTION
instance AdmitChildSUB CAPTION
instance AdmitChildSUP CAPTION
instance AdmitChildSPAN CAPTION
instance AdmitChildBDO CAPTION
instance AdmitChildIFRAME CAPTION
instance AdmitChildINPUT CAPTION
instance AdmitChildSELECT CAPTION
instance AdmitChildTEXTAREA CAPTION
instance AdmitChildLABEL CAPTION
instance AdmitChildBUTTON CAPTION

instance AdmitChildCAPTION TABLE
instance AdmitChildCOL TABLE
instance AdmitChildCOLGROUP TABLE
instance AdmitChildTHEAD TABLE
instance AdmitChildTFOOT TABLE
instance AdmitChildTBODY TABLE

instance AdmitChildP BUTTON
instance AdmitChildH1 BUTTON
instance AdmitChildH2 BUTTON
instance AdmitChildH3 BUTTON
instance AdmitChildH4 BUTTON
instance AdmitChildH5 BUTTON
instance AdmitChildH6 BUTTON
instance AdmitChildUL BUTTON
instance AdmitChildOL BUTTON
instance AdmitChildDIR BUTTON
instance AdmitChildMENU BUTTON
instance AdmitChildPRE BUTTON
instance AdmitChildDL BUTTON
instance AdmitChildDIV BUTTON
instance AdmitChildCENTER BUTTON
instance AdmitChildNOSCRIPT BUTTON
instance AdmitChildNOFRAMES BUTTON
instance AdmitChildBLOCKQUOTE BUTTON
instance AdmitChildHR BUTTON
instance AdmitChildTABLE BUTTON
instance AdmitChildADDRESS BUTTON
instance AdmitChildCDATA BUTTON
instance AdmitChildTT BUTTON
instance AdmitChildI BUTTON
instance AdmitChildB BUTTON
instance AdmitChildU BUTTON
instance AdmitChildS BUTTON
instance AdmitChildSTRIKE BUTTON
instance AdmitChildBIG BUTTON
instance AdmitChildSMALL BUTTON
instance AdmitChildEM BUTTON
instance AdmitChildSTRONG BUTTON
instance AdmitChildDFN BUTTON
instance AdmitChildCODE BUTTON
instance AdmitChildSAMP BUTTON
instance AdmitChildKBD BUTTON
instance AdmitChildVAR BUTTON
instance AdmitChildCITE BUTTON
instance AdmitChildABBR BUTTON
instance AdmitChildACRONYM BUTTON
instance AdmitChildIMG BUTTON
instance AdmitChildAPPLET BUTTON
instance AdmitChildOBJECT BUTTON
instance AdmitChildFONT BUTTON
instance AdmitChildBASEFONT BUTTON
instance AdmitChildBR BUTTON
instance AdmitChildSCRIPT BUTTON
instance AdmitChildMAP BUTTON
instance AdmitChildQ BUTTON
instance AdmitChildSUB BUTTON
instance AdmitChildSUP BUTTON
instance AdmitChildSPAN BUTTON
instance AdmitChildBDO BUTTON

instance AdmitChildCDATA LEGEND
instance AdmitChildTT LEGEND
instance AdmitChildI LEGEND
instance AdmitChildB LEGEND
instance AdmitChildU LEGEND
instance AdmitChildS LEGEND
instance AdmitChildSTRIKE LEGEND
instance AdmitChildBIG LEGEND
instance AdmitChildSMALL LEGEND
instance AdmitChildEM LEGEND
instance AdmitChildSTRONG LEGEND
instance AdmitChildDFN LEGEND
instance AdmitChildCODE LEGEND
instance AdmitChildSAMP LEGEND
instance AdmitChildKBD LEGEND
instance AdmitChildVAR LEGEND
instance AdmitChildCITE LEGEND
instance AdmitChildABBR LEGEND
instance AdmitChildACRONYM LEGEND
instance AdmitChildA LEGEND
instance AdmitChildIMG LEGEND
instance AdmitChildAPPLET LEGEND
instance AdmitChildOBJECT LEGEND
instance AdmitChildFONT LEGEND
instance AdmitChildBASEFONT LEGEND
instance AdmitChildBR LEGEND
instance AdmitChildSCRIPT LEGEND
instance AdmitChildMAP LEGEND
instance AdmitChildQ LEGEND
instance AdmitChildSUB LEGEND
instance AdmitChildSUP LEGEND
instance AdmitChildSPAN LEGEND
instance AdmitChildBDO LEGEND
instance AdmitChildIFRAME LEGEND
instance AdmitChildINPUT LEGEND
instance AdmitChildSELECT LEGEND
instance AdmitChildTEXTAREA LEGEND
instance AdmitChildLABEL LEGEND
instance AdmitChildBUTTON LEGEND

instance AdmitChildCDATA FIELDSET
instance AdmitChildLEGEND FIELDSET
instance AdmitChildP FIELDSET
instance AdmitChildH1 FIELDSET
instance AdmitChildH2 FIELDSET
instance AdmitChildH3 FIELDSET
instance AdmitChildH4 FIELDSET
instance AdmitChildH5 FIELDSET
instance AdmitChildH6 FIELDSET
instance AdmitChildUL FIELDSET
instance AdmitChildOL FIELDSET
instance AdmitChildDIR FIELDSET
instance AdmitChildMENU FIELDSET
instance AdmitChildPRE FIELDSET
instance AdmitChildDL FIELDSET
instance AdmitChildDIV FIELDSET
instance AdmitChildCENTER FIELDSET
instance AdmitChildNOSCRIPT FIELDSET
instance AdmitChildNOFRAMES FIELDSET
instance AdmitChildBLOCKQUOTE FIELDSET
instance AdmitChildFORM FIELDSET
instance AdmitChildISINDEX FIELDSET
instance AdmitChildHR FIELDSET
instance AdmitChildTABLE FIELDSET
instance AdmitChildFIELDSET FIELDSET
instance AdmitChildADDRESS FIELDSET
instance AdmitChildTT FIELDSET
instance AdmitChildI FIELDSET
instance AdmitChildB FIELDSET
instance AdmitChildU FIELDSET
instance AdmitChildS FIELDSET
instance AdmitChildSTRIKE FIELDSET
instance AdmitChildBIG FIELDSET
instance AdmitChildSMALL FIELDSET
instance AdmitChildEM FIELDSET
instance AdmitChildSTRONG FIELDSET
instance AdmitChildDFN FIELDSET
instance AdmitChildCODE FIELDSET
instance AdmitChildSAMP FIELDSET
instance AdmitChildKBD FIELDSET
instance AdmitChildVAR FIELDSET
instance AdmitChildCITE FIELDSET
instance AdmitChildABBR FIELDSET
instance AdmitChildACRONYM FIELDSET
instance AdmitChildA FIELDSET
instance AdmitChildIMG FIELDSET
instance AdmitChildAPPLET FIELDSET
instance AdmitChildOBJECT FIELDSET
instance AdmitChildFONT FIELDSET
instance AdmitChildBASEFONT FIELDSET
instance AdmitChildBR FIELDSET
instance AdmitChildSCRIPT FIELDSET
instance AdmitChildMAP FIELDSET
instance AdmitChildQ FIELDSET
instance AdmitChildSUB FIELDSET
instance AdmitChildSUP FIELDSET
instance AdmitChildSPAN FIELDSET
instance AdmitChildBDO FIELDSET
instance AdmitChildIFRAME FIELDSET
instance AdmitChildINPUT FIELDSET
instance AdmitChildSELECT FIELDSET
instance AdmitChildTEXTAREA FIELDSET
instance AdmitChildLABEL FIELDSET
instance AdmitChildBUTTON FIELDSET

instance AdmitChildCDATA TEXTAREA

instance AdmitChildCDATA OPTION

instance AdmitChildOPTION OPTGROUP

instance AdmitChildOPTGROUP SELECT
instance AdmitChildOPTION SELECT


instance AdmitChildCDATA LABEL
instance AdmitChildTT LABEL
instance AdmitChildI LABEL
instance AdmitChildB LABEL
instance AdmitChildU LABEL
instance AdmitChildS LABEL
instance AdmitChildSTRIKE LABEL
instance AdmitChildBIG LABEL
instance AdmitChildSMALL LABEL
instance AdmitChildEM LABEL
instance AdmitChildSTRONG LABEL
instance AdmitChildDFN LABEL
instance AdmitChildCODE LABEL
instance AdmitChildSAMP LABEL
instance AdmitChildKBD LABEL
instance AdmitChildVAR LABEL
instance AdmitChildCITE LABEL
instance AdmitChildABBR LABEL
instance AdmitChildACRONYM LABEL
instance AdmitChildA LABEL
instance AdmitChildIMG LABEL
instance AdmitChildAPPLET LABEL
instance AdmitChildOBJECT LABEL
instance AdmitChildFONT LABEL
instance AdmitChildBASEFONT LABEL
instance AdmitChildBR LABEL
instance AdmitChildSCRIPT LABEL
instance AdmitChildMAP LABEL
instance AdmitChildQ LABEL
instance AdmitChildSUB LABEL
instance AdmitChildSUP LABEL
instance AdmitChildSPAN LABEL
instance AdmitChildBDO LABEL
instance AdmitChildIFRAME LABEL
instance AdmitChildINPUT LABEL
instance AdmitChildSELECT LABEL
instance AdmitChildTEXTAREA LABEL
instance AdmitChildBUTTON LABEL

instance AdmitChildP FORM
instance AdmitChildH1 FORM
instance AdmitChildH2 FORM
instance AdmitChildH3 FORM
instance AdmitChildH4 FORM
instance AdmitChildH5 FORM
instance AdmitChildH6 FORM
instance AdmitChildUL FORM
instance AdmitChildOL FORM
instance AdmitChildDIR FORM
instance AdmitChildMENU FORM
instance AdmitChildPRE FORM
instance AdmitChildDL FORM
instance AdmitChildDIV FORM
instance AdmitChildCENTER FORM
instance AdmitChildNOSCRIPT FORM
instance AdmitChildNOFRAMES FORM
instance AdmitChildBLOCKQUOTE FORM
instance AdmitChildISINDEX FORM
instance AdmitChildHR FORM
instance AdmitChildTABLE FORM
instance AdmitChildFIELDSET FORM
instance AdmitChildADDRESS FORM
instance AdmitChildCDATA FORM
instance AdmitChildTT FORM
instance AdmitChildI FORM
instance AdmitChildB FORM
instance AdmitChildU FORM
instance AdmitChildS FORM
instance AdmitChildSTRIKE FORM
instance AdmitChildBIG FORM
instance AdmitChildSMALL FORM
instance AdmitChildEM FORM
instance AdmitChildSTRONG FORM
instance AdmitChildDFN FORM
instance AdmitChildCODE FORM
instance AdmitChildSAMP FORM
instance AdmitChildKBD FORM
instance AdmitChildVAR FORM
instance AdmitChildCITE FORM
instance AdmitChildABBR FORM
instance AdmitChildACRONYM FORM
instance AdmitChildA FORM
instance AdmitChildIMG FORM
instance AdmitChildAPPLET FORM
instance AdmitChildOBJECT FORM
instance AdmitChildFONT FORM
instance AdmitChildBASEFONT FORM
instance AdmitChildBR FORM
instance AdmitChildSCRIPT FORM
instance AdmitChildMAP FORM
instance AdmitChildQ FORM
instance AdmitChildSUB FORM
instance AdmitChildSUP FORM
instance AdmitChildSPAN FORM
instance AdmitChildBDO FORM
instance AdmitChildIFRAME FORM
instance AdmitChildINPUT FORM
instance AdmitChildSELECT FORM
instance AdmitChildTEXTAREA FORM
instance AdmitChildLABEL FORM
instance AdmitChildBUTTON FORM

instance AdmitChildP LI
instance AdmitChildH1 LI
instance AdmitChildH2 LI
instance AdmitChildH3 LI
instance AdmitChildH4 LI
instance AdmitChildH5 LI
instance AdmitChildH6 LI
instance AdmitChildUL LI
instance AdmitChildOL LI
instance AdmitChildDIR LI
instance AdmitChildMENU LI
instance AdmitChildPRE LI
instance AdmitChildDL LI
instance AdmitChildDIV LI
instance AdmitChildCENTER LI
instance AdmitChildNOSCRIPT LI
instance AdmitChildNOFRAMES LI
instance AdmitChildBLOCKQUOTE LI
instance AdmitChildFORM LI
instance AdmitChildISINDEX LI
instance AdmitChildHR LI
instance AdmitChildTABLE LI
instance AdmitChildFIELDSET LI
instance AdmitChildADDRESS LI
instance AdmitChildCDATA LI
instance AdmitChildTT LI
instance AdmitChildI LI
instance AdmitChildB LI
instance AdmitChildU LI
instance AdmitChildS LI
instance AdmitChildSTRIKE LI
instance AdmitChildBIG LI
instance AdmitChildSMALL LI
instance AdmitChildEM LI
instance AdmitChildSTRONG LI
instance AdmitChildDFN LI
instance AdmitChildCODE LI
instance AdmitChildSAMP LI
instance AdmitChildKBD LI
instance AdmitChildVAR LI
instance AdmitChildCITE LI
instance AdmitChildABBR LI
instance AdmitChildACRONYM LI
instance AdmitChildA LI
instance AdmitChildIMG LI
instance AdmitChildAPPLET LI
instance AdmitChildOBJECT LI
instance AdmitChildFONT LI
instance AdmitChildBASEFONT LI
instance AdmitChildBR LI
instance AdmitChildSCRIPT LI
instance AdmitChildMAP LI
instance AdmitChildQ LI
instance AdmitChildSUB LI
instance AdmitChildSUP LI
instance AdmitChildSPAN LI
instance AdmitChildBDO LI
instance AdmitChildIFRAME LI
instance AdmitChildINPUT LI
instance AdmitChildSELECT LI
instance AdmitChildTEXTAREA LI
instance AdmitChildLABEL LI
instance AdmitChildBUTTON LI

instance AdmitChildLI DIR

instance AdmitChildLI MENU

instance AdmitChildLI UL

instance AdmitChildLI OL

instance AdmitChildP DD
instance AdmitChildH1 DD
instance AdmitChildH2 DD
instance AdmitChildH3 DD
instance AdmitChildH4 DD
instance AdmitChildH5 DD
instance AdmitChildH6 DD
instance AdmitChildUL DD
instance AdmitChildOL DD
instance AdmitChildDIR DD
instance AdmitChildMENU DD
instance AdmitChildPRE DD
instance AdmitChildDL DD
instance AdmitChildDIV DD
instance AdmitChildCENTER DD
instance AdmitChildNOSCRIPT DD
instance AdmitChildNOFRAMES DD
instance AdmitChildBLOCKQUOTE DD
instance AdmitChildFORM DD
instance AdmitChildISINDEX DD
instance AdmitChildHR DD
instance AdmitChildTABLE DD
instance AdmitChildFIELDSET DD
instance AdmitChildADDRESS DD
instance AdmitChildCDATA DD
instance AdmitChildTT DD
instance AdmitChildI DD
instance AdmitChildB DD
instance AdmitChildU DD
instance AdmitChildS DD
instance AdmitChildSTRIKE DD
instance AdmitChildBIG DD
instance AdmitChildSMALL DD
instance AdmitChildEM DD
instance AdmitChildSTRONG DD
instance AdmitChildDFN DD
instance AdmitChildCODE DD
instance AdmitChildSAMP DD
instance AdmitChildKBD DD
instance AdmitChildVAR DD
instance AdmitChildCITE DD
instance AdmitChildABBR DD
instance AdmitChildACRONYM DD
instance AdmitChildA DD
instance AdmitChildIMG DD
instance AdmitChildAPPLET DD
instance AdmitChildOBJECT DD
instance AdmitChildFONT DD
instance AdmitChildBASEFONT DD
instance AdmitChildBR DD
instance AdmitChildSCRIPT DD
instance AdmitChildMAP DD
instance AdmitChildQ DD
instance AdmitChildSUB DD
instance AdmitChildSUP DD
instance AdmitChildSPAN DD
instance AdmitChildBDO DD
instance AdmitChildIFRAME DD
instance AdmitChildINPUT DD
instance AdmitChildSELECT DD
instance AdmitChildTEXTAREA DD
instance AdmitChildLABEL DD
instance AdmitChildBUTTON DD

instance AdmitChildCDATA DT
instance AdmitChildTT DT
instance AdmitChildI DT
instance AdmitChildB DT
instance AdmitChildU DT
instance AdmitChildS DT
instance AdmitChildSTRIKE DT
instance AdmitChildBIG DT
instance AdmitChildSMALL DT
instance AdmitChildEM DT
instance AdmitChildSTRONG DT
instance AdmitChildDFN DT
instance AdmitChildCODE DT
instance AdmitChildSAMP DT
instance AdmitChildKBD DT
instance AdmitChildVAR DT
instance AdmitChildCITE DT
instance AdmitChildABBR DT
instance AdmitChildACRONYM DT
instance AdmitChildA DT
instance AdmitChildIMG DT
instance AdmitChildAPPLET DT
instance AdmitChildOBJECT DT
instance AdmitChildFONT DT
instance AdmitChildBASEFONT DT
instance AdmitChildBR DT
instance AdmitChildSCRIPT DT
instance AdmitChildMAP DT
instance AdmitChildQ DT
instance AdmitChildSUB DT
instance AdmitChildSUP DT
instance AdmitChildSPAN DT
instance AdmitChildBDO DT
instance AdmitChildIFRAME DT
instance AdmitChildINPUT DT
instance AdmitChildSELECT DT
instance AdmitChildTEXTAREA DT
instance AdmitChildLABEL DT
instance AdmitChildBUTTON DT

instance AdmitChildDT DL
instance AdmitChildDD DL

instance AdmitChildP INS
instance AdmitChildH1 INS
instance AdmitChildH2 INS
instance AdmitChildH3 INS
instance AdmitChildH4 INS
instance AdmitChildH5 INS
instance AdmitChildH6 INS
instance AdmitChildUL INS
instance AdmitChildOL INS
instance AdmitChildDIR INS
instance AdmitChildMENU INS
instance AdmitChildPRE INS
instance AdmitChildDL INS
instance AdmitChildDIV INS
instance AdmitChildCENTER INS
instance AdmitChildNOSCRIPT INS
instance AdmitChildNOFRAMES INS
instance AdmitChildBLOCKQUOTE INS
instance AdmitChildFORM INS
instance AdmitChildISINDEX INS
instance AdmitChildHR INS
instance AdmitChildTABLE INS
instance AdmitChildFIELDSET INS
instance AdmitChildADDRESS INS
instance AdmitChildCDATA INS
instance AdmitChildTT INS
instance AdmitChildI INS
instance AdmitChildB INS
instance AdmitChildU INS
instance AdmitChildS INS
instance AdmitChildSTRIKE INS
instance AdmitChildBIG INS
instance AdmitChildSMALL INS
instance AdmitChildEM INS
instance AdmitChildSTRONG INS
instance AdmitChildDFN INS
instance AdmitChildCODE INS
instance AdmitChildSAMP INS
instance AdmitChildKBD INS
instance AdmitChildVAR INS
instance AdmitChildCITE INS
instance AdmitChildABBR INS
instance AdmitChildACRONYM INS
instance AdmitChildA INS
instance AdmitChildIMG INS
instance AdmitChildAPPLET INS
instance AdmitChildOBJECT INS
instance AdmitChildFONT INS
instance AdmitChildBASEFONT INS
instance AdmitChildBR INS
instance AdmitChildSCRIPT INS
instance AdmitChildMAP INS
instance AdmitChildQ INS
instance AdmitChildSUB INS
instance AdmitChildSUP INS
instance AdmitChildSPAN INS
instance AdmitChildBDO INS
instance AdmitChildIFRAME INS
instance AdmitChildINPUT INS
instance AdmitChildSELECT INS
instance AdmitChildTEXTAREA INS
instance AdmitChildLABEL INS
instance AdmitChildBUTTON INS

instance AdmitChildP DEL
instance AdmitChildH1 DEL
instance AdmitChildH2 DEL
instance AdmitChildH3 DEL
instance AdmitChildH4 DEL
instance AdmitChildH5 DEL
instance AdmitChildH6 DEL
instance AdmitChildUL DEL
instance AdmitChildOL DEL
instance AdmitChildDIR DEL
instance AdmitChildMENU DEL
instance AdmitChildPRE DEL
instance AdmitChildDL DEL
instance AdmitChildDIV DEL
instance AdmitChildCENTER DEL
instance AdmitChildNOSCRIPT DEL
instance AdmitChildNOFRAMES DEL
instance AdmitChildBLOCKQUOTE DEL
instance AdmitChildFORM DEL
instance AdmitChildISINDEX DEL
instance AdmitChildHR DEL
instance AdmitChildTABLE DEL
instance AdmitChildFIELDSET DEL
instance AdmitChildADDRESS DEL
instance AdmitChildCDATA DEL
instance AdmitChildTT DEL
instance AdmitChildI DEL
instance AdmitChildB DEL
instance AdmitChildU DEL
instance AdmitChildS DEL
instance AdmitChildSTRIKE DEL
instance AdmitChildBIG DEL
instance AdmitChildSMALL DEL
instance AdmitChildEM DEL
instance AdmitChildSTRONG DEL
instance AdmitChildDFN DEL
instance AdmitChildCODE DEL
instance AdmitChildSAMP DEL
instance AdmitChildKBD DEL
instance AdmitChildVAR DEL
instance AdmitChildCITE DEL
instance AdmitChildABBR DEL
instance AdmitChildACRONYM DEL
instance AdmitChildA DEL
instance AdmitChildIMG DEL
instance AdmitChildAPPLET DEL
instance AdmitChildOBJECT DEL
instance AdmitChildFONT DEL
instance AdmitChildBASEFONT DEL
instance AdmitChildBR DEL
instance AdmitChildSCRIPT DEL
instance AdmitChildMAP DEL
instance AdmitChildQ DEL
instance AdmitChildSUB DEL
instance AdmitChildSUP DEL
instance AdmitChildSPAN DEL
instance AdmitChildBDO DEL
instance AdmitChildIFRAME DEL
instance AdmitChildINPUT DEL
instance AdmitChildSELECT DEL
instance AdmitChildTEXTAREA DEL
instance AdmitChildLABEL DEL
instance AdmitChildBUTTON DEL

instance AdmitChildP BLOCKQUOTE
instance AdmitChildH1 BLOCKQUOTE
instance AdmitChildH2 BLOCKQUOTE
instance AdmitChildH3 BLOCKQUOTE
instance AdmitChildH4 BLOCKQUOTE
instance AdmitChildH5 BLOCKQUOTE
instance AdmitChildH6 BLOCKQUOTE
instance AdmitChildUL BLOCKQUOTE
instance AdmitChildOL BLOCKQUOTE
instance AdmitChildDIR BLOCKQUOTE
instance AdmitChildMENU BLOCKQUOTE
instance AdmitChildPRE BLOCKQUOTE
instance AdmitChildDL BLOCKQUOTE
instance AdmitChildDIV BLOCKQUOTE
instance AdmitChildCENTER BLOCKQUOTE
instance AdmitChildNOSCRIPT BLOCKQUOTE
instance AdmitChildNOFRAMES BLOCKQUOTE
instance AdmitChildBLOCKQUOTE BLOCKQUOTE
instance AdmitChildFORM BLOCKQUOTE
instance AdmitChildISINDEX BLOCKQUOTE
instance AdmitChildHR BLOCKQUOTE
instance AdmitChildTABLE BLOCKQUOTE
instance AdmitChildFIELDSET BLOCKQUOTE
instance AdmitChildADDRESS BLOCKQUOTE
instance AdmitChildCDATA BLOCKQUOTE
instance AdmitChildTT BLOCKQUOTE
instance AdmitChildI BLOCKQUOTE
instance AdmitChildB BLOCKQUOTE
instance AdmitChildU BLOCKQUOTE
instance AdmitChildS BLOCKQUOTE
instance AdmitChildSTRIKE BLOCKQUOTE
instance AdmitChildBIG BLOCKQUOTE
instance AdmitChildSMALL BLOCKQUOTE
instance AdmitChildEM BLOCKQUOTE
instance AdmitChildSTRONG BLOCKQUOTE
instance AdmitChildDFN BLOCKQUOTE
instance AdmitChildCODE BLOCKQUOTE
instance AdmitChildSAMP BLOCKQUOTE
instance AdmitChildKBD BLOCKQUOTE
instance AdmitChildVAR BLOCKQUOTE
instance AdmitChildCITE BLOCKQUOTE
instance AdmitChildABBR BLOCKQUOTE
instance AdmitChildACRONYM BLOCKQUOTE
instance AdmitChildA BLOCKQUOTE
instance AdmitChildIMG BLOCKQUOTE
instance AdmitChildAPPLET BLOCKQUOTE
instance AdmitChildOBJECT BLOCKQUOTE
instance AdmitChildFONT BLOCKQUOTE
instance AdmitChildBASEFONT BLOCKQUOTE
instance AdmitChildBR BLOCKQUOTE
instance AdmitChildSCRIPT BLOCKQUOTE
instance AdmitChildMAP BLOCKQUOTE
instance AdmitChildQ BLOCKQUOTE
instance AdmitChildSUB BLOCKQUOTE
instance AdmitChildSUP BLOCKQUOTE
instance AdmitChildSPAN BLOCKQUOTE
instance AdmitChildBDO BLOCKQUOTE
instance AdmitChildIFRAME BLOCKQUOTE
instance AdmitChildINPUT BLOCKQUOTE
instance AdmitChildSELECT BLOCKQUOTE
instance AdmitChildTEXTAREA BLOCKQUOTE
instance AdmitChildLABEL BLOCKQUOTE
instance AdmitChildBUTTON BLOCKQUOTE

instance AdmitChildCDATA Q
instance AdmitChildTT Q
instance AdmitChildI Q
instance AdmitChildB Q
instance AdmitChildU Q
instance AdmitChildS Q
instance AdmitChildSTRIKE Q
instance AdmitChildBIG Q
instance AdmitChildSMALL Q
instance AdmitChildEM Q
instance AdmitChildSTRONG Q
instance AdmitChildDFN Q
instance AdmitChildCODE Q
instance AdmitChildSAMP Q
instance AdmitChildKBD Q
instance AdmitChildVAR Q
instance AdmitChildCITE Q
instance AdmitChildABBR Q
instance AdmitChildACRONYM Q
instance AdmitChildA Q
instance AdmitChildIMG Q
instance AdmitChildAPPLET Q
instance AdmitChildOBJECT Q
instance AdmitChildFONT Q
instance AdmitChildBASEFONT Q
instance AdmitChildBR Q
instance AdmitChildSCRIPT Q
instance AdmitChildMAP Q
instance AdmitChildQ Q
instance AdmitChildSUB Q
instance AdmitChildSUP Q
instance AdmitChildSPAN Q
instance AdmitChildBDO Q
instance AdmitChildIFRAME Q
instance AdmitChildINPUT Q
instance AdmitChildSELECT Q
instance AdmitChildTEXTAREA Q
instance AdmitChildLABEL Q
instance AdmitChildBUTTON Q

instance AdmitChildCDATA PRE
instance AdmitChildTT PRE
instance AdmitChildI PRE
instance AdmitChildB PRE
instance AdmitChildU PRE
instance AdmitChildS PRE
instance AdmitChildSTRIKE PRE
instance AdmitChildEM PRE
instance AdmitChildSTRONG PRE
instance AdmitChildDFN PRE
instance AdmitChildCODE PRE
instance AdmitChildSAMP PRE
instance AdmitChildKBD PRE
instance AdmitChildVAR PRE
instance AdmitChildCITE PRE
instance AdmitChildABBR PRE
instance AdmitChildACRONYM PRE
instance AdmitChildA PRE
instance AdmitChildBR PRE
instance AdmitChildSCRIPT PRE
instance AdmitChildMAP PRE
instance AdmitChildQ PRE
instance AdmitChildSPAN PRE
instance AdmitChildBDO PRE
instance AdmitChildIFRAME PRE
instance AdmitChildINPUT PRE
instance AdmitChildSELECT PRE
instance AdmitChildTEXTAREA PRE
instance AdmitChildLABEL PRE
instance AdmitChildBUTTON PRE

instance AdmitChildCDATA H1
instance AdmitChildTT H1
instance AdmitChildI H1
instance AdmitChildB H1
instance AdmitChildU H1
instance AdmitChildS H1
instance AdmitChildSTRIKE H1
instance AdmitChildBIG H1
instance AdmitChildSMALL H1
instance AdmitChildEM H1
instance AdmitChildSTRONG H1
instance AdmitChildDFN H1
instance AdmitChildCODE H1
instance AdmitChildSAMP H1
instance AdmitChildKBD H1
instance AdmitChildVAR H1
instance AdmitChildCITE H1
instance AdmitChildABBR H1
instance AdmitChildACRONYM H1
instance AdmitChildA H1
instance AdmitChildIMG H1
instance AdmitChildAPPLET H1
instance AdmitChildOBJECT H1
instance AdmitChildFONT H1
instance AdmitChildBASEFONT H1
instance AdmitChildBR H1
instance AdmitChildSCRIPT H1
instance AdmitChildMAP H1
instance AdmitChildQ H1
instance AdmitChildSUB H1
instance AdmitChildSUP H1
instance AdmitChildSPAN H1
instance AdmitChildBDO H1
instance AdmitChildIFRAME H1
instance AdmitChildINPUT H1
instance AdmitChildSELECT H1
instance AdmitChildTEXTAREA H1
instance AdmitChildLABEL H1
instance AdmitChildBUTTON H1

instance AdmitChildCDATA H2
instance AdmitChildTT H2
instance AdmitChildI H2
instance AdmitChildB H2
instance AdmitChildU H2
instance AdmitChildS H2
instance AdmitChildSTRIKE H2
instance AdmitChildBIG H2
instance AdmitChildSMALL H2
instance AdmitChildEM H2
instance AdmitChildSTRONG H2
instance AdmitChildDFN H2
instance AdmitChildCODE H2
instance AdmitChildSAMP H2
instance AdmitChildKBD H2
instance AdmitChildVAR H2
instance AdmitChildCITE H2
instance AdmitChildABBR H2
instance AdmitChildACRONYM H2
instance AdmitChildA H2
instance AdmitChildIMG H2
instance AdmitChildAPPLET H2
instance AdmitChildOBJECT H2
instance AdmitChildFONT H2
instance AdmitChildBASEFONT H2
instance AdmitChildBR H2
instance AdmitChildSCRIPT H2
instance AdmitChildMAP H2
instance AdmitChildQ H2
instance AdmitChildSUB H2
instance AdmitChildSUP H2
instance AdmitChildSPAN H2
instance AdmitChildBDO H2
instance AdmitChildIFRAME H2
instance AdmitChildINPUT H2
instance AdmitChildSELECT H2
instance AdmitChildTEXTAREA H2
instance AdmitChildLABEL H2
instance AdmitChildBUTTON H2

instance AdmitChildCDATA H3
instance AdmitChildTT H3
instance AdmitChildI H3
instance AdmitChildB H3
instance AdmitChildU H3
instance AdmitChildS H3
instance AdmitChildSTRIKE H3
instance AdmitChildBIG H3
instance AdmitChildSMALL H3
instance AdmitChildEM H3
instance AdmitChildSTRONG H3
instance AdmitChildDFN H3
instance AdmitChildCODE H3
instance AdmitChildSAMP H3
instance AdmitChildKBD H3
instance AdmitChildVAR H3
instance AdmitChildCITE H3
instance AdmitChildABBR H3
instance AdmitChildACRONYM H3
instance AdmitChildA H3
instance AdmitChildIMG H3
instance AdmitChildAPPLET H3
instance AdmitChildOBJECT H3
instance AdmitChildFONT H3
instance AdmitChildBASEFONT H3
instance AdmitChildBR H3
instance AdmitChildSCRIPT H3
instance AdmitChildMAP H3
instance AdmitChildQ H3
instance AdmitChildSUB H3
instance AdmitChildSUP H3
instance AdmitChildSPAN H3
instance AdmitChildBDO H3
instance AdmitChildIFRAME H3
instance AdmitChildINPUT H3
instance AdmitChildSELECT H3
instance AdmitChildTEXTAREA H3
instance AdmitChildLABEL H3
instance AdmitChildBUTTON H3

instance AdmitChildCDATA H4
instance AdmitChildTT H4
instance AdmitChildI H4
instance AdmitChildB H4
instance AdmitChildU H4
instance AdmitChildS H4
instance AdmitChildSTRIKE H4
instance AdmitChildBIG H4
instance AdmitChildSMALL H4
instance AdmitChildEM H4
instance AdmitChildSTRONG H4
instance AdmitChildDFN H4
instance AdmitChildCODE H4
instance AdmitChildSAMP H4
instance AdmitChildKBD H4
instance AdmitChildVAR H4
instance AdmitChildCITE H4
instance AdmitChildABBR H4
instance AdmitChildACRONYM H4
instance AdmitChildA H4
instance AdmitChildIMG H4
instance AdmitChildAPPLET H4
instance AdmitChildOBJECT H4
instance AdmitChildFONT H4
instance AdmitChildBASEFONT H4
instance AdmitChildBR H4
instance AdmitChildSCRIPT H4
instance AdmitChildMAP H4
instance AdmitChildQ H4
instance AdmitChildSUB H4
instance AdmitChildSUP H4
instance AdmitChildSPAN H4
instance AdmitChildBDO H4
instance AdmitChildIFRAME H4
instance AdmitChildINPUT H4
instance AdmitChildSELECT H4
instance AdmitChildTEXTAREA H4
instance AdmitChildLABEL H4
instance AdmitChildBUTTON H4

instance AdmitChildCDATA H5
instance AdmitChildTT H5
instance AdmitChildI H5
instance AdmitChildB H5
instance AdmitChildU H5
instance AdmitChildS H5
instance AdmitChildSTRIKE H5
instance AdmitChildBIG H5
instance AdmitChildSMALL H5
instance AdmitChildEM H5
instance AdmitChildSTRONG H5
instance AdmitChildDFN H5
instance AdmitChildCODE H5
instance AdmitChildSAMP H5
instance AdmitChildKBD H5
instance AdmitChildVAR H5
instance AdmitChildCITE H5
instance AdmitChildABBR H5
instance AdmitChildACRONYM H5
instance AdmitChildA H5
instance AdmitChildIMG H5
instance AdmitChildAPPLET H5
instance AdmitChildOBJECT H5
instance AdmitChildFONT H5
instance AdmitChildBASEFONT H5
instance AdmitChildBR H5
instance AdmitChildSCRIPT H5
instance AdmitChildMAP H5
instance AdmitChildQ H5
instance AdmitChildSUB H5
instance AdmitChildSUP H5
instance AdmitChildSPAN H5
instance AdmitChildBDO H5
instance AdmitChildIFRAME H5
instance AdmitChildINPUT H5
instance AdmitChildSELECT H5
instance AdmitChildTEXTAREA H5
instance AdmitChildLABEL H5
instance AdmitChildBUTTON H5

instance AdmitChildCDATA H6
instance AdmitChildTT H6
instance AdmitChildI H6
instance AdmitChildB H6
instance AdmitChildU H6
instance AdmitChildS H6
instance AdmitChildSTRIKE H6
instance AdmitChildBIG H6
instance AdmitChildSMALL H6
instance AdmitChildEM H6
instance AdmitChildSTRONG H6
instance AdmitChildDFN H6
instance AdmitChildCODE H6
instance AdmitChildSAMP H6
instance AdmitChildKBD H6
instance AdmitChildVAR H6
instance AdmitChildCITE H6
instance AdmitChildABBR H6
instance AdmitChildACRONYM H6
instance AdmitChildA H6
instance AdmitChildIMG H6
instance AdmitChildAPPLET H6
instance AdmitChildOBJECT H6
instance AdmitChildFONT H6
instance AdmitChildBASEFONT H6
instance AdmitChildBR H6
instance AdmitChildSCRIPT H6
instance AdmitChildMAP H6
instance AdmitChildQ H6
instance AdmitChildSUB H6
instance AdmitChildSUP H6
instance AdmitChildSPAN H6
instance AdmitChildBDO H6
instance AdmitChildIFRAME H6
instance AdmitChildINPUT H6
instance AdmitChildSELECT H6
instance AdmitChildTEXTAREA H6
instance AdmitChildLABEL H6
instance AdmitChildBUTTON H6

instance AdmitChildCDATA P
instance AdmitChildTT P
instance AdmitChildI P
instance AdmitChildB P
instance AdmitChildU P
instance AdmitChildS P
instance AdmitChildSTRIKE P
instance AdmitChildBIG P
instance AdmitChildSMALL P
instance AdmitChildEM P
instance AdmitChildSTRONG P
instance AdmitChildDFN P
instance AdmitChildCODE P
instance AdmitChildSAMP P
instance AdmitChildKBD P
instance AdmitChildVAR P
instance AdmitChildCITE P
instance AdmitChildABBR P
instance AdmitChildACRONYM P
instance AdmitChildA P
instance AdmitChildIMG P
instance AdmitChildAPPLET P
instance AdmitChildOBJECT P
instance AdmitChildFONT P
instance AdmitChildBASEFONT P
instance AdmitChildBR P
instance AdmitChildSCRIPT P
instance AdmitChildMAP P
instance AdmitChildQ P
instance AdmitChildSUB P
instance AdmitChildSUP P
instance AdmitChildSPAN P
instance AdmitChildBDO P
instance AdmitChildIFRAME P
instance AdmitChildINPUT P
instance AdmitChildSELECT P
instance AdmitChildTEXTAREA P
instance AdmitChildLABEL P
instance AdmitChildBUTTON P


instance AdmitChildPARAM APPLET
instance AdmitChildP APPLET
instance AdmitChildH1 APPLET
instance AdmitChildH2 APPLET
instance AdmitChildH3 APPLET
instance AdmitChildH4 APPLET
instance AdmitChildH5 APPLET
instance AdmitChildH6 APPLET
instance AdmitChildUL APPLET
instance AdmitChildOL APPLET
instance AdmitChildDIR APPLET
instance AdmitChildMENU APPLET
instance AdmitChildPRE APPLET
instance AdmitChildDL APPLET
instance AdmitChildDIV APPLET
instance AdmitChildCENTER APPLET
instance AdmitChildNOSCRIPT APPLET
instance AdmitChildNOFRAMES APPLET
instance AdmitChildBLOCKQUOTE APPLET
instance AdmitChildFORM APPLET
instance AdmitChildISINDEX APPLET
instance AdmitChildHR APPLET
instance AdmitChildTABLE APPLET
instance AdmitChildFIELDSET APPLET
instance AdmitChildADDRESS APPLET
instance AdmitChildCDATA APPLET
instance AdmitChildTT APPLET
instance AdmitChildI APPLET
instance AdmitChildB APPLET
instance AdmitChildU APPLET
instance AdmitChildS APPLET
instance AdmitChildSTRIKE APPLET
instance AdmitChildBIG APPLET
instance AdmitChildSMALL APPLET
instance AdmitChildEM APPLET
instance AdmitChildSTRONG APPLET
instance AdmitChildDFN APPLET
instance AdmitChildCODE APPLET
instance AdmitChildSAMP APPLET
instance AdmitChildKBD APPLET
instance AdmitChildVAR APPLET
instance AdmitChildCITE APPLET
instance AdmitChildABBR APPLET
instance AdmitChildACRONYM APPLET
instance AdmitChildA APPLET
instance AdmitChildIMG APPLET
instance AdmitChildAPPLET APPLET
instance AdmitChildOBJECT APPLET
instance AdmitChildFONT APPLET
instance AdmitChildBASEFONT APPLET
instance AdmitChildBR APPLET
instance AdmitChildSCRIPT APPLET
instance AdmitChildMAP APPLET
instance AdmitChildQ APPLET
instance AdmitChildSUB APPLET
instance AdmitChildSUP APPLET
instance AdmitChildSPAN APPLET
instance AdmitChildBDO APPLET
instance AdmitChildIFRAME APPLET
instance AdmitChildINPUT APPLET
instance AdmitChildSELECT APPLET
instance AdmitChildTEXTAREA APPLET
instance AdmitChildLABEL APPLET
instance AdmitChildBUTTON APPLET


instance AdmitChildPARAM OBJECT
instance AdmitChildP OBJECT
instance AdmitChildH1 OBJECT
instance AdmitChildH2 OBJECT
instance AdmitChildH3 OBJECT
instance AdmitChildH4 OBJECT
instance AdmitChildH5 OBJECT
instance AdmitChildH6 OBJECT
instance AdmitChildUL OBJECT
instance AdmitChildOL OBJECT
instance AdmitChildDIR OBJECT
instance AdmitChildMENU OBJECT
instance AdmitChildPRE OBJECT
instance AdmitChildDL OBJECT
instance AdmitChildDIV OBJECT
instance AdmitChildCENTER OBJECT
instance AdmitChildNOSCRIPT OBJECT
instance AdmitChildNOFRAMES OBJECT
instance AdmitChildBLOCKQUOTE OBJECT
instance AdmitChildFORM OBJECT
instance AdmitChildISINDEX OBJECT
instance AdmitChildHR OBJECT
instance AdmitChildTABLE OBJECT
instance AdmitChildFIELDSET OBJECT
instance AdmitChildADDRESS OBJECT
instance AdmitChildCDATA OBJECT
instance AdmitChildTT OBJECT
instance AdmitChildI OBJECT
instance AdmitChildB OBJECT
instance AdmitChildU OBJECT
instance AdmitChildS OBJECT
instance AdmitChildSTRIKE OBJECT
instance AdmitChildBIG OBJECT
instance AdmitChildSMALL OBJECT
instance AdmitChildEM OBJECT
instance AdmitChildSTRONG OBJECT
instance AdmitChildDFN OBJECT
instance AdmitChildCODE OBJECT
instance AdmitChildSAMP OBJECT
instance AdmitChildKBD OBJECT
instance AdmitChildVAR OBJECT
instance AdmitChildCITE OBJECT
instance AdmitChildABBR OBJECT
instance AdmitChildACRONYM OBJECT
instance AdmitChildA OBJECT
instance AdmitChildIMG OBJECT
instance AdmitChildAPPLET OBJECT
instance AdmitChildOBJECT OBJECT
instance AdmitChildFONT OBJECT
instance AdmitChildBASEFONT OBJECT
instance AdmitChildBR OBJECT
instance AdmitChildSCRIPT OBJECT
instance AdmitChildMAP OBJECT
instance AdmitChildQ OBJECT
instance AdmitChildSUB OBJECT
instance AdmitChildSUP OBJECT
instance AdmitChildSPAN OBJECT
instance AdmitChildBDO OBJECT
instance AdmitChildIFRAME OBJECT
instance AdmitChildINPUT OBJECT
instance AdmitChildSELECT OBJECT
instance AdmitChildTEXTAREA OBJECT
instance AdmitChildLABEL OBJECT
instance AdmitChildBUTTON OBJECT




instance AdmitChildP MAP
instance AdmitChildH1 MAP
instance AdmitChildH2 MAP
instance AdmitChildH3 MAP
instance AdmitChildH4 MAP
instance AdmitChildH5 MAP
instance AdmitChildH6 MAP
instance AdmitChildUL MAP
instance AdmitChildOL MAP
instance AdmitChildDIR MAP
instance AdmitChildMENU MAP
instance AdmitChildPRE MAP
instance AdmitChildDL MAP
instance AdmitChildDIV MAP
instance AdmitChildCENTER MAP
instance AdmitChildNOSCRIPT MAP
instance AdmitChildNOFRAMES MAP
instance AdmitChildBLOCKQUOTE MAP
instance AdmitChildFORM MAP
instance AdmitChildISINDEX MAP
instance AdmitChildHR MAP
instance AdmitChildTABLE MAP
instance AdmitChildFIELDSET MAP
instance AdmitChildADDRESS MAP
instance AdmitChildAREA MAP

instance AdmitChildCDATA A
instance AdmitChildTT A
instance AdmitChildI A
instance AdmitChildB A
instance AdmitChildU A
instance AdmitChildS A
instance AdmitChildSTRIKE A
instance AdmitChildBIG A
instance AdmitChildSMALL A
instance AdmitChildEM A
instance AdmitChildSTRONG A
instance AdmitChildDFN A
instance AdmitChildCODE A
instance AdmitChildSAMP A
instance AdmitChildKBD A
instance AdmitChildVAR A
instance AdmitChildCITE A
instance AdmitChildABBR A
instance AdmitChildACRONYM A
instance AdmitChildIMG A
instance AdmitChildAPPLET A
instance AdmitChildOBJECT A
instance AdmitChildFONT A
instance AdmitChildBASEFONT A
instance AdmitChildBR A
instance AdmitChildSCRIPT A
instance AdmitChildMAP A
instance AdmitChildQ A
instance AdmitChildSUB A
instance AdmitChildSUP A
instance AdmitChildSPAN A
instance AdmitChildBDO A
instance AdmitChildIFRAME A
instance AdmitChildINPUT A
instance AdmitChildSELECT A
instance AdmitChildTEXTAREA A
instance AdmitChildLABEL A
instance AdmitChildBUTTON A

instance AdmitChildP CENTER
instance AdmitChildH1 CENTER
instance AdmitChildH2 CENTER
instance AdmitChildH3 CENTER
instance AdmitChildH4 CENTER
instance AdmitChildH5 CENTER
instance AdmitChildH6 CENTER
instance AdmitChildUL CENTER
instance AdmitChildOL CENTER
instance AdmitChildDIR CENTER
instance AdmitChildMENU CENTER
instance AdmitChildPRE CENTER
instance AdmitChildDL CENTER
instance AdmitChildDIV CENTER
instance AdmitChildCENTER CENTER
instance AdmitChildNOSCRIPT CENTER
instance AdmitChildNOFRAMES CENTER
instance AdmitChildBLOCKQUOTE CENTER
instance AdmitChildFORM CENTER
instance AdmitChildISINDEX CENTER
instance AdmitChildHR CENTER
instance AdmitChildTABLE CENTER
instance AdmitChildFIELDSET CENTER
instance AdmitChildADDRESS CENTER
instance AdmitChildCDATA CENTER
instance AdmitChildTT CENTER
instance AdmitChildI CENTER
instance AdmitChildB CENTER
instance AdmitChildU CENTER
instance AdmitChildS CENTER
instance AdmitChildSTRIKE CENTER
instance AdmitChildBIG CENTER
instance AdmitChildSMALL CENTER
instance AdmitChildEM CENTER
instance AdmitChildSTRONG CENTER
instance AdmitChildDFN CENTER
instance AdmitChildCODE CENTER
instance AdmitChildSAMP CENTER
instance AdmitChildKBD CENTER
instance AdmitChildVAR CENTER
instance AdmitChildCITE CENTER
instance AdmitChildABBR CENTER
instance AdmitChildACRONYM CENTER
instance AdmitChildA CENTER
instance AdmitChildIMG CENTER
instance AdmitChildAPPLET CENTER
instance AdmitChildOBJECT CENTER
instance AdmitChildFONT CENTER
instance AdmitChildBASEFONT CENTER
instance AdmitChildBR CENTER
instance AdmitChildSCRIPT CENTER
instance AdmitChildMAP CENTER
instance AdmitChildQ CENTER
instance AdmitChildSUB CENTER
instance AdmitChildSUP CENTER
instance AdmitChildSPAN CENTER
instance AdmitChildBDO CENTER
instance AdmitChildIFRAME CENTER
instance AdmitChildINPUT CENTER
instance AdmitChildSELECT CENTER
instance AdmitChildTEXTAREA CENTER
instance AdmitChildLABEL CENTER
instance AdmitChildBUTTON CENTER

instance AdmitChildP DIV
instance AdmitChildH1 DIV
instance AdmitChildH2 DIV
instance AdmitChildH3 DIV
instance AdmitChildH4 DIV
instance AdmitChildH5 DIV
instance AdmitChildH6 DIV
instance AdmitChildUL DIV
instance AdmitChildOL DIV
instance AdmitChildDIR DIV
instance AdmitChildMENU DIV
instance AdmitChildPRE DIV
instance AdmitChildDL DIV
instance AdmitChildDIV DIV
instance AdmitChildCENTER DIV
instance AdmitChildNOSCRIPT DIV
instance AdmitChildNOFRAMES DIV
instance AdmitChildBLOCKQUOTE DIV
instance AdmitChildFORM DIV
instance AdmitChildISINDEX DIV
instance AdmitChildHR DIV
instance AdmitChildTABLE DIV
instance AdmitChildFIELDSET DIV
instance AdmitChildADDRESS DIV
instance AdmitChildCDATA DIV
instance AdmitChildTT DIV
instance AdmitChildI DIV
instance AdmitChildB DIV
instance AdmitChildU DIV
instance AdmitChildS DIV
instance AdmitChildSTRIKE DIV
instance AdmitChildBIG DIV
instance AdmitChildSMALL DIV
instance AdmitChildEM DIV
instance AdmitChildSTRONG DIV
instance AdmitChildDFN DIV
instance AdmitChildCODE DIV
instance AdmitChildSAMP DIV
instance AdmitChildKBD DIV
instance AdmitChildVAR DIV
instance AdmitChildCITE DIV
instance AdmitChildABBR DIV
instance AdmitChildACRONYM DIV
instance AdmitChildA DIV
instance AdmitChildIMG DIV
instance AdmitChildAPPLET DIV
instance AdmitChildOBJECT DIV
instance AdmitChildFONT DIV
instance AdmitChildBASEFONT DIV
instance AdmitChildBR DIV
instance AdmitChildSCRIPT DIV
instance AdmitChildMAP DIV
instance AdmitChildQ DIV
instance AdmitChildSUB DIV
instance AdmitChildSUP DIV
instance AdmitChildSPAN DIV
instance AdmitChildBDO DIV
instance AdmitChildIFRAME DIV
instance AdmitChildINPUT DIV
instance AdmitChildSELECT DIV
instance AdmitChildTEXTAREA DIV
instance AdmitChildLABEL DIV
instance AdmitChildBUTTON DIV

instance AdmitChildCDATA ADDRESS
instance AdmitChildTT ADDRESS
instance AdmitChildI ADDRESS
instance AdmitChildB ADDRESS
instance AdmitChildU ADDRESS
instance AdmitChildS ADDRESS
instance AdmitChildSTRIKE ADDRESS
instance AdmitChildBIG ADDRESS
instance AdmitChildSMALL ADDRESS
instance AdmitChildEM ADDRESS
instance AdmitChildSTRONG ADDRESS
instance AdmitChildDFN ADDRESS
instance AdmitChildCODE ADDRESS
instance AdmitChildSAMP ADDRESS
instance AdmitChildKBD ADDRESS
instance AdmitChildVAR ADDRESS
instance AdmitChildCITE ADDRESS
instance AdmitChildABBR ADDRESS
instance AdmitChildACRONYM ADDRESS
instance AdmitChildA ADDRESS
instance AdmitChildIMG ADDRESS
instance AdmitChildAPPLET ADDRESS
instance AdmitChildOBJECT ADDRESS
instance AdmitChildFONT ADDRESS
instance AdmitChildBASEFONT ADDRESS
instance AdmitChildBR ADDRESS
instance AdmitChildSCRIPT ADDRESS
instance AdmitChildMAP ADDRESS
instance AdmitChildQ ADDRESS
instance AdmitChildSUB ADDRESS
instance AdmitChildSUP ADDRESS
instance AdmitChildSPAN ADDRESS
instance AdmitChildBDO ADDRESS
instance AdmitChildIFRAME ADDRESS
instance AdmitChildINPUT ADDRESS
instance AdmitChildSELECT ADDRESS
instance AdmitChildTEXTAREA ADDRESS
instance AdmitChildLABEL ADDRESS
instance AdmitChildBUTTON ADDRESS
instance AdmitChildP ADDRESS

instance AdmitChildP BODY
instance AdmitChildH1 BODY
instance AdmitChildH2 BODY
instance AdmitChildH3 BODY
instance AdmitChildH4 BODY
instance AdmitChildH5 BODY
instance AdmitChildH6 BODY
instance AdmitChildUL BODY
instance AdmitChildOL BODY
instance AdmitChildDIR BODY
instance AdmitChildMENU BODY
instance AdmitChildPRE BODY
instance AdmitChildDL BODY
instance AdmitChildDIV BODY
instance AdmitChildCENTER BODY
instance AdmitChildNOSCRIPT BODY
instance AdmitChildNOFRAMES BODY
instance AdmitChildBLOCKQUOTE BODY
instance AdmitChildFORM BODY
instance AdmitChildISINDEX BODY
instance AdmitChildHR BODY
instance AdmitChildTABLE BODY
instance AdmitChildFIELDSET BODY
instance AdmitChildADDRESS BODY
instance AdmitChildCDATA BODY
instance AdmitChildTT BODY
instance AdmitChildI BODY
instance AdmitChildB BODY
instance AdmitChildU BODY
instance AdmitChildS BODY
instance AdmitChildSTRIKE BODY
instance AdmitChildBIG BODY
instance AdmitChildSMALL BODY
instance AdmitChildEM BODY
instance AdmitChildSTRONG BODY
instance AdmitChildDFN BODY
instance AdmitChildCODE BODY
instance AdmitChildSAMP BODY
instance AdmitChildKBD BODY
instance AdmitChildVAR BODY
instance AdmitChildCITE BODY
instance AdmitChildABBR BODY
instance AdmitChildACRONYM BODY
instance AdmitChildA BODY
instance AdmitChildIMG BODY
instance AdmitChildAPPLET BODY
instance AdmitChildOBJECT BODY
instance AdmitChildFONT BODY
instance AdmitChildBASEFONT BODY
instance AdmitChildBR BODY
instance AdmitChildSCRIPT BODY
instance AdmitChildMAP BODY
instance AdmitChildQ BODY
instance AdmitChildSUB BODY
instance AdmitChildSUP BODY
instance AdmitChildSPAN BODY
instance AdmitChildBDO BODY
instance AdmitChildIFRAME BODY
instance AdmitChildINPUT BODY
instance AdmitChildSELECT BODY
instance AdmitChildTEXTAREA BODY
instance AdmitChildLABEL BODY
instance AdmitChildBUTTON BODY
instance AdmitChildINS BODY
instance AdmitChildDEL BODY


instance AdmitChildCDATA FONT
instance AdmitChildTT FONT
instance AdmitChildI FONT
instance AdmitChildB FONT
instance AdmitChildU FONT
instance AdmitChildS FONT
instance AdmitChildSTRIKE FONT
instance AdmitChildBIG FONT
instance AdmitChildSMALL FONT
instance AdmitChildEM FONT
instance AdmitChildSTRONG FONT
instance AdmitChildDFN FONT
instance AdmitChildCODE FONT
instance AdmitChildSAMP FONT
instance AdmitChildKBD FONT
instance AdmitChildVAR FONT
instance AdmitChildCITE FONT
instance AdmitChildABBR FONT
instance AdmitChildACRONYM FONT
instance AdmitChildA FONT
instance AdmitChildIMG FONT
instance AdmitChildAPPLET FONT
instance AdmitChildOBJECT FONT
instance AdmitChildFONT FONT
instance AdmitChildBASEFONT FONT
instance AdmitChildBR FONT
instance AdmitChildSCRIPT FONT
instance AdmitChildMAP FONT
instance AdmitChildQ FONT
instance AdmitChildSUB FONT
instance AdmitChildSUP FONT
instance AdmitChildSPAN FONT
instance AdmitChildBDO FONT
instance AdmitChildIFRAME FONT
instance AdmitChildINPUT FONT
instance AdmitChildSELECT FONT
instance AdmitChildTEXTAREA FONT
instance AdmitChildLABEL FONT
instance AdmitChildBUTTON FONT


instance AdmitChildCDATA BDO
instance AdmitChildTT BDO
instance AdmitChildI BDO
instance AdmitChildB BDO
instance AdmitChildU BDO
instance AdmitChildS BDO
instance AdmitChildSTRIKE BDO
instance AdmitChildBIG BDO
instance AdmitChildSMALL BDO
instance AdmitChildEM BDO
instance AdmitChildSTRONG BDO
instance AdmitChildDFN BDO
instance AdmitChildCODE BDO
instance AdmitChildSAMP BDO
instance AdmitChildKBD BDO
instance AdmitChildVAR BDO
instance AdmitChildCITE BDO
instance AdmitChildABBR BDO
instance AdmitChildACRONYM BDO
instance AdmitChildA BDO
instance AdmitChildIMG BDO
instance AdmitChildAPPLET BDO
instance AdmitChildOBJECT BDO
instance AdmitChildFONT BDO
instance AdmitChildBASEFONT BDO
instance AdmitChildBR BDO
instance AdmitChildSCRIPT BDO
instance AdmitChildMAP BDO
instance AdmitChildQ BDO
instance AdmitChildSUB BDO
instance AdmitChildSUP BDO
instance AdmitChildSPAN BDO
instance AdmitChildBDO BDO
instance AdmitChildIFRAME BDO
instance AdmitChildINPUT BDO
instance AdmitChildSELECT BDO
instance AdmitChildTEXTAREA BDO
instance AdmitChildLABEL BDO
instance AdmitChildBUTTON BDO

instance AdmitChildCDATA SPAN
instance AdmitChildTT SPAN
instance AdmitChildI SPAN
instance AdmitChildB SPAN
instance AdmitChildU SPAN
instance AdmitChildS SPAN
instance AdmitChildSTRIKE SPAN
instance AdmitChildBIG SPAN
instance AdmitChildSMALL SPAN
instance AdmitChildEM SPAN
instance AdmitChildSTRONG SPAN
instance AdmitChildDFN SPAN
instance AdmitChildCODE SPAN
instance AdmitChildSAMP SPAN
instance AdmitChildKBD SPAN
instance AdmitChildVAR SPAN
instance AdmitChildCITE SPAN
instance AdmitChildABBR SPAN
instance AdmitChildACRONYM SPAN
instance AdmitChildA SPAN
instance AdmitChildIMG SPAN
instance AdmitChildAPPLET SPAN
instance AdmitChildOBJECT SPAN
instance AdmitChildFONT SPAN
instance AdmitChildBASEFONT SPAN
instance AdmitChildBR SPAN
instance AdmitChildSCRIPT SPAN
instance AdmitChildMAP SPAN
instance AdmitChildQ SPAN
instance AdmitChildSUB SPAN
instance AdmitChildSUP SPAN
instance AdmitChildSPAN SPAN
instance AdmitChildBDO SPAN
instance AdmitChildIFRAME SPAN
instance AdmitChildINPUT SPAN
instance AdmitChildSELECT SPAN
instance AdmitChildTEXTAREA SPAN
instance AdmitChildLABEL SPAN
instance AdmitChildBUTTON SPAN

instance AdmitChildCDATA SUB
instance AdmitChildTT SUB
instance AdmitChildI SUB
instance AdmitChildB SUB
instance AdmitChildU SUB
instance AdmitChildS SUB
instance AdmitChildSTRIKE SUB
instance AdmitChildBIG SUB
instance AdmitChildSMALL SUB
instance AdmitChildEM SUB
instance AdmitChildSTRONG SUB
instance AdmitChildDFN SUB
instance AdmitChildCODE SUB
instance AdmitChildSAMP SUB
instance AdmitChildKBD SUB
instance AdmitChildVAR SUB
instance AdmitChildCITE SUB
instance AdmitChildABBR SUB
instance AdmitChildACRONYM SUB
instance AdmitChildA SUB
instance AdmitChildIMG SUB
instance AdmitChildAPPLET SUB
instance AdmitChildOBJECT SUB
instance AdmitChildFONT SUB
instance AdmitChildBASEFONT SUB
instance AdmitChildBR SUB
instance AdmitChildSCRIPT SUB
instance AdmitChildMAP SUB
instance AdmitChildQ SUB
instance AdmitChildSUB SUB
instance AdmitChildSUP SUB
instance AdmitChildSPAN SUB
instance AdmitChildBDO SUB
instance AdmitChildIFRAME SUB
instance AdmitChildINPUT SUB
instance AdmitChildSELECT SUB
instance AdmitChildTEXTAREA SUB
instance AdmitChildLABEL SUB
instance AdmitChildBUTTON SUB

instance AdmitChildCDATA SUP
instance AdmitChildTT SUP
instance AdmitChildI SUP
instance AdmitChildB SUP
instance AdmitChildU SUP
instance AdmitChildS SUP
instance AdmitChildSTRIKE SUP
instance AdmitChildBIG SUP
instance AdmitChildSMALL SUP
instance AdmitChildEM SUP
instance AdmitChildSTRONG SUP
instance AdmitChildDFN SUP
instance AdmitChildCODE SUP
instance AdmitChildSAMP SUP
instance AdmitChildKBD SUP
instance AdmitChildVAR SUP
instance AdmitChildCITE SUP
instance AdmitChildABBR SUP
instance AdmitChildACRONYM SUP
instance AdmitChildA SUP
instance AdmitChildIMG SUP
instance AdmitChildAPPLET SUP
instance AdmitChildOBJECT SUP
instance AdmitChildFONT SUP
instance AdmitChildBASEFONT SUP
instance AdmitChildBR SUP
instance AdmitChildSCRIPT SUP
instance AdmitChildMAP SUP
instance AdmitChildQ SUP
instance AdmitChildSUB SUP
instance AdmitChildSUP SUP
instance AdmitChildSPAN SUP
instance AdmitChildBDO SUP
instance AdmitChildIFRAME SUP
instance AdmitChildINPUT SUP
instance AdmitChildSELECT SUP
instance AdmitChildTEXTAREA SUP
instance AdmitChildLABEL SUP
instance AdmitChildBUTTON SUP

instance AdmitChildCDATA TT
instance AdmitChildTT TT
instance AdmitChildI TT
instance AdmitChildB TT
instance AdmitChildU TT
instance AdmitChildS TT
instance AdmitChildSTRIKE TT
instance AdmitChildBIG TT
instance AdmitChildSMALL TT
instance AdmitChildEM TT
instance AdmitChildSTRONG TT
instance AdmitChildDFN TT
instance AdmitChildCODE TT
instance AdmitChildSAMP TT
instance AdmitChildKBD TT
instance AdmitChildVAR TT
instance AdmitChildCITE TT
instance AdmitChildABBR TT
instance AdmitChildACRONYM TT
instance AdmitChildA TT
instance AdmitChildIMG TT
instance AdmitChildAPPLET TT
instance AdmitChildOBJECT TT
instance AdmitChildFONT TT
instance AdmitChildBASEFONT TT
instance AdmitChildBR TT
instance AdmitChildSCRIPT TT
instance AdmitChildMAP TT
instance AdmitChildQ TT
instance AdmitChildSUB TT
instance AdmitChildSUP TT
instance AdmitChildSPAN TT
instance AdmitChildBDO TT
instance AdmitChildIFRAME TT
instance AdmitChildINPUT TT
instance AdmitChildSELECT TT
instance AdmitChildTEXTAREA TT
instance AdmitChildLABEL TT
instance AdmitChildBUTTON TT

instance AdmitChildCDATA I
instance AdmitChildTT I
instance AdmitChildI I
instance AdmitChildB I
instance AdmitChildU I
instance AdmitChildS I
instance AdmitChildSTRIKE I
instance AdmitChildBIG I
instance AdmitChildSMALL I
instance AdmitChildEM I
instance AdmitChildSTRONG I
instance AdmitChildDFN I
instance AdmitChildCODE I
instance AdmitChildSAMP I
instance AdmitChildKBD I
instance AdmitChildVAR I
instance AdmitChildCITE I
instance AdmitChildABBR I
instance AdmitChildACRONYM I
instance AdmitChildA I
instance AdmitChildIMG I
instance AdmitChildAPPLET I
instance AdmitChildOBJECT I
instance AdmitChildFONT I
instance AdmitChildBASEFONT I
instance AdmitChildBR I
instance AdmitChildSCRIPT I
instance AdmitChildMAP I
instance AdmitChildQ I
instance AdmitChildSUB I
instance AdmitChildSUP I
instance AdmitChildSPAN I
instance AdmitChildBDO I
instance AdmitChildIFRAME I
instance AdmitChildINPUT I
instance AdmitChildSELECT I
instance AdmitChildTEXTAREA I
instance AdmitChildLABEL I
instance AdmitChildBUTTON I

instance AdmitChildCDATA B
instance AdmitChildTT B
instance AdmitChildI B
instance AdmitChildB B
instance AdmitChildU B
instance AdmitChildS B
instance AdmitChildSTRIKE B
instance AdmitChildBIG B
instance AdmitChildSMALL B
instance AdmitChildEM B
instance AdmitChildSTRONG B
instance AdmitChildDFN B
instance AdmitChildCODE B
instance AdmitChildSAMP B
instance AdmitChildKBD B
instance AdmitChildVAR B
instance AdmitChildCITE B
instance AdmitChildABBR B
instance AdmitChildACRONYM B
instance AdmitChildA B
instance AdmitChildIMG B
instance AdmitChildAPPLET B
instance AdmitChildOBJECT B
instance AdmitChildFONT B
instance AdmitChildBASEFONT B
instance AdmitChildBR B
instance AdmitChildSCRIPT B
instance AdmitChildMAP B
instance AdmitChildQ B
instance AdmitChildSUB B
instance AdmitChildSUP B
instance AdmitChildSPAN B
instance AdmitChildBDO B
instance AdmitChildIFRAME B
instance AdmitChildINPUT B
instance AdmitChildSELECT B
instance AdmitChildTEXTAREA B
instance AdmitChildLABEL B
instance AdmitChildBUTTON B

instance AdmitChildCDATA U
instance AdmitChildTT U
instance AdmitChildI U
instance AdmitChildB U
instance AdmitChildU U
instance AdmitChildS U
instance AdmitChildSTRIKE U
instance AdmitChildBIG U
instance AdmitChildSMALL U
instance AdmitChildEM U
instance AdmitChildSTRONG U
instance AdmitChildDFN U
instance AdmitChildCODE U
instance AdmitChildSAMP U
instance AdmitChildKBD U
instance AdmitChildVAR U
instance AdmitChildCITE U
instance AdmitChildABBR U
instance AdmitChildACRONYM U
instance AdmitChildA U
instance AdmitChildIMG U
instance AdmitChildAPPLET U
instance AdmitChildOBJECT U
instance AdmitChildFONT U
instance AdmitChildBASEFONT U
instance AdmitChildBR U
instance AdmitChildSCRIPT U
instance AdmitChildMAP U
instance AdmitChildQ U
instance AdmitChildSUB U
instance AdmitChildSUP U
instance AdmitChildSPAN U
instance AdmitChildBDO U
instance AdmitChildIFRAME U
instance AdmitChildINPUT U
instance AdmitChildSELECT U
instance AdmitChildTEXTAREA U
instance AdmitChildLABEL U
instance AdmitChildBUTTON U

instance AdmitChildCDATA S
instance AdmitChildTT S
instance AdmitChildI S
instance AdmitChildB S
instance AdmitChildU S
instance AdmitChildS S
instance AdmitChildSTRIKE S
instance AdmitChildBIG S
instance AdmitChildSMALL S
instance AdmitChildEM S
instance AdmitChildSTRONG S
instance AdmitChildDFN S
instance AdmitChildCODE S
instance AdmitChildSAMP S
instance AdmitChildKBD S
instance AdmitChildVAR S
instance AdmitChildCITE S
instance AdmitChildABBR S
instance AdmitChildACRONYM S
instance AdmitChildA S
instance AdmitChildIMG S
instance AdmitChildAPPLET S
instance AdmitChildOBJECT S
instance AdmitChildFONT S
instance AdmitChildBASEFONT S
instance AdmitChildBR S
instance AdmitChildSCRIPT S
instance AdmitChildMAP S
instance AdmitChildQ S
instance AdmitChildSUB S
instance AdmitChildSUP S
instance AdmitChildSPAN S
instance AdmitChildBDO S
instance AdmitChildIFRAME S
instance AdmitChildINPUT S
instance AdmitChildSELECT S
instance AdmitChildTEXTAREA S
instance AdmitChildLABEL S
instance AdmitChildBUTTON S

instance AdmitChildCDATA STRIKE
instance AdmitChildTT STRIKE
instance AdmitChildI STRIKE
instance AdmitChildB STRIKE
instance AdmitChildU STRIKE
instance AdmitChildS STRIKE
instance AdmitChildSTRIKE STRIKE
instance AdmitChildBIG STRIKE
instance AdmitChildSMALL STRIKE
instance AdmitChildEM STRIKE
instance AdmitChildSTRONG STRIKE
instance AdmitChildDFN STRIKE
instance AdmitChildCODE STRIKE
instance AdmitChildSAMP STRIKE
instance AdmitChildKBD STRIKE
instance AdmitChildVAR STRIKE
instance AdmitChildCITE STRIKE
instance AdmitChildABBR STRIKE
instance AdmitChildACRONYM STRIKE
instance AdmitChildA STRIKE
instance AdmitChildIMG STRIKE
instance AdmitChildAPPLET STRIKE
instance AdmitChildOBJECT STRIKE
instance AdmitChildFONT STRIKE
instance AdmitChildBASEFONT STRIKE
instance AdmitChildBR STRIKE
instance AdmitChildSCRIPT STRIKE
instance AdmitChildMAP STRIKE
instance AdmitChildQ STRIKE
instance AdmitChildSUB STRIKE
instance AdmitChildSUP STRIKE
instance AdmitChildSPAN STRIKE
instance AdmitChildBDO STRIKE
instance AdmitChildIFRAME STRIKE
instance AdmitChildINPUT STRIKE
instance AdmitChildSELECT STRIKE
instance AdmitChildTEXTAREA STRIKE
instance AdmitChildLABEL STRIKE
instance AdmitChildBUTTON STRIKE

instance AdmitChildCDATA BIG
instance AdmitChildTT BIG
instance AdmitChildI BIG
instance AdmitChildB BIG
instance AdmitChildU BIG
instance AdmitChildS BIG
instance AdmitChildSTRIKE BIG
instance AdmitChildBIG BIG
instance AdmitChildSMALL BIG
instance AdmitChildEM BIG
instance AdmitChildSTRONG BIG
instance AdmitChildDFN BIG
instance AdmitChildCODE BIG
instance AdmitChildSAMP BIG
instance AdmitChildKBD BIG
instance AdmitChildVAR BIG
instance AdmitChildCITE BIG
instance AdmitChildABBR BIG
instance AdmitChildACRONYM BIG
instance AdmitChildA BIG
instance AdmitChildIMG BIG
instance AdmitChildAPPLET BIG
instance AdmitChildOBJECT BIG
instance AdmitChildFONT BIG
instance AdmitChildBASEFONT BIG
instance AdmitChildBR BIG
instance AdmitChildSCRIPT BIG
instance AdmitChildMAP BIG
instance AdmitChildQ BIG
instance AdmitChildSUB BIG
instance AdmitChildSUP BIG
instance AdmitChildSPAN BIG
instance AdmitChildBDO BIG
instance AdmitChildIFRAME BIG
instance AdmitChildINPUT BIG
instance AdmitChildSELECT BIG
instance AdmitChildTEXTAREA BIG
instance AdmitChildLABEL BIG
instance AdmitChildBUTTON BIG

instance AdmitChildCDATA SMALL
instance AdmitChildTT SMALL
instance AdmitChildI SMALL
instance AdmitChildB SMALL
instance AdmitChildU SMALL
instance AdmitChildS SMALL
instance AdmitChildSTRIKE SMALL
instance AdmitChildBIG SMALL
instance AdmitChildSMALL SMALL
instance AdmitChildEM SMALL
instance AdmitChildSTRONG SMALL
instance AdmitChildDFN SMALL
instance AdmitChildCODE SMALL
instance AdmitChildSAMP SMALL
instance AdmitChildKBD SMALL
instance AdmitChildVAR SMALL
instance AdmitChildCITE SMALL
instance AdmitChildABBR SMALL
instance AdmitChildACRONYM SMALL
instance AdmitChildA SMALL
instance AdmitChildIMG SMALL
instance AdmitChildAPPLET SMALL
instance AdmitChildOBJECT SMALL
instance AdmitChildFONT SMALL
instance AdmitChildBASEFONT SMALL
instance AdmitChildBR SMALL
instance AdmitChildSCRIPT SMALL
instance AdmitChildMAP SMALL
instance AdmitChildQ SMALL
instance AdmitChildSUB SMALL
instance AdmitChildSUP SMALL
instance AdmitChildSPAN SMALL
instance AdmitChildBDO SMALL
instance AdmitChildIFRAME SMALL
instance AdmitChildINPUT SMALL
instance AdmitChildSELECT SMALL
instance AdmitChildTEXTAREA SMALL
instance AdmitChildLABEL SMALL
instance AdmitChildBUTTON SMALL

instance AdmitChildCDATA EM
instance AdmitChildTT EM
instance AdmitChildI EM
instance AdmitChildB EM
instance AdmitChildU EM
instance AdmitChildS EM
instance AdmitChildSTRIKE EM
instance AdmitChildBIG EM
instance AdmitChildSMALL EM
instance AdmitChildEM EM
instance AdmitChildSTRONG EM
instance AdmitChildDFN EM
instance AdmitChildCODE EM
instance AdmitChildSAMP EM
instance AdmitChildKBD EM
instance AdmitChildVAR EM
instance AdmitChildCITE EM
instance AdmitChildABBR EM
instance AdmitChildACRONYM EM
instance AdmitChildA EM
instance AdmitChildIMG EM
instance AdmitChildAPPLET EM
instance AdmitChildOBJECT EM
instance AdmitChildFONT EM
instance AdmitChildBASEFONT EM
instance AdmitChildBR EM
instance AdmitChildSCRIPT EM
instance AdmitChildMAP EM
instance AdmitChildQ EM
instance AdmitChildSUB EM
instance AdmitChildSUP EM
instance AdmitChildSPAN EM
instance AdmitChildBDO EM
instance AdmitChildIFRAME EM
instance AdmitChildINPUT EM
instance AdmitChildSELECT EM
instance AdmitChildTEXTAREA EM
instance AdmitChildLABEL EM
instance AdmitChildBUTTON EM

instance AdmitChildCDATA STRONG
instance AdmitChildTT STRONG
instance AdmitChildI STRONG
instance AdmitChildB STRONG
instance AdmitChildU STRONG
instance AdmitChildS STRONG
instance AdmitChildSTRIKE STRONG
instance AdmitChildBIG STRONG
instance AdmitChildSMALL STRONG
instance AdmitChildEM STRONG
instance AdmitChildSTRONG STRONG
instance AdmitChildDFN STRONG
instance AdmitChildCODE STRONG
instance AdmitChildSAMP STRONG
instance AdmitChildKBD STRONG
instance AdmitChildVAR STRONG
instance AdmitChildCITE STRONG
instance AdmitChildABBR STRONG
instance AdmitChildACRONYM STRONG
instance AdmitChildA STRONG
instance AdmitChildIMG STRONG
instance AdmitChildAPPLET STRONG
instance AdmitChildOBJECT STRONG
instance AdmitChildFONT STRONG
instance AdmitChildBASEFONT STRONG
instance AdmitChildBR STRONG
instance AdmitChildSCRIPT STRONG
instance AdmitChildMAP STRONG
instance AdmitChildQ STRONG
instance AdmitChildSUB STRONG
instance AdmitChildSUP STRONG
instance AdmitChildSPAN STRONG
instance AdmitChildBDO STRONG
instance AdmitChildIFRAME STRONG
instance AdmitChildINPUT STRONG
instance AdmitChildSELECT STRONG
instance AdmitChildTEXTAREA STRONG
instance AdmitChildLABEL STRONG
instance AdmitChildBUTTON STRONG

instance AdmitChildCDATA DFN
instance AdmitChildTT DFN
instance AdmitChildI DFN
instance AdmitChildB DFN
instance AdmitChildU DFN
instance AdmitChildS DFN
instance AdmitChildSTRIKE DFN
instance AdmitChildBIG DFN
instance AdmitChildSMALL DFN
instance AdmitChildEM DFN
instance AdmitChildSTRONG DFN
instance AdmitChildDFN DFN
instance AdmitChildCODE DFN
instance AdmitChildSAMP DFN
instance AdmitChildKBD DFN
instance AdmitChildVAR DFN
instance AdmitChildCITE DFN
instance AdmitChildABBR DFN
instance AdmitChildACRONYM DFN
instance AdmitChildA DFN
instance AdmitChildIMG DFN
instance AdmitChildAPPLET DFN
instance AdmitChildOBJECT DFN
instance AdmitChildFONT DFN
instance AdmitChildBASEFONT DFN
instance AdmitChildBR DFN
instance AdmitChildSCRIPT DFN
instance AdmitChildMAP DFN
instance AdmitChildQ DFN
instance AdmitChildSUB DFN
instance AdmitChildSUP DFN
instance AdmitChildSPAN DFN
instance AdmitChildBDO DFN
instance AdmitChildIFRAME DFN
instance AdmitChildINPUT DFN
instance AdmitChildSELECT DFN
instance AdmitChildTEXTAREA DFN
instance AdmitChildLABEL DFN
instance AdmitChildBUTTON DFN

instance AdmitChildCDATA CODE
instance AdmitChildTT CODE
instance AdmitChildI CODE
instance AdmitChildB CODE
instance AdmitChildU CODE
instance AdmitChildS CODE
instance AdmitChildSTRIKE CODE
instance AdmitChildBIG CODE
instance AdmitChildSMALL CODE
instance AdmitChildEM CODE
instance AdmitChildSTRONG CODE
instance AdmitChildDFN CODE
instance AdmitChildCODE CODE
instance AdmitChildSAMP CODE
instance AdmitChildKBD CODE
instance AdmitChildVAR CODE
instance AdmitChildCITE CODE
instance AdmitChildABBR CODE
instance AdmitChildACRONYM CODE
instance AdmitChildA CODE
instance AdmitChildIMG CODE
instance AdmitChildAPPLET CODE
instance AdmitChildOBJECT CODE
instance AdmitChildFONT CODE
instance AdmitChildBASEFONT CODE
instance AdmitChildBR CODE
instance AdmitChildSCRIPT CODE
instance AdmitChildMAP CODE
instance AdmitChildQ CODE
instance AdmitChildSUB CODE
instance AdmitChildSUP CODE
instance AdmitChildSPAN CODE
instance AdmitChildBDO CODE
instance AdmitChildIFRAME CODE
instance AdmitChildINPUT CODE
instance AdmitChildSELECT CODE
instance AdmitChildTEXTAREA CODE
instance AdmitChildLABEL CODE
instance AdmitChildBUTTON CODE

instance AdmitChildCDATA SAMP
instance AdmitChildTT SAMP
instance AdmitChildI SAMP
instance AdmitChildB SAMP
instance AdmitChildU SAMP
instance AdmitChildS SAMP
instance AdmitChildSTRIKE SAMP
instance AdmitChildBIG SAMP
instance AdmitChildSMALL SAMP
instance AdmitChildEM SAMP
instance AdmitChildSTRONG SAMP
instance AdmitChildDFN SAMP
instance AdmitChildCODE SAMP
instance AdmitChildSAMP SAMP
instance AdmitChildKBD SAMP
instance AdmitChildVAR SAMP
instance AdmitChildCITE SAMP
instance AdmitChildABBR SAMP
instance AdmitChildACRONYM SAMP
instance AdmitChildA SAMP
instance AdmitChildIMG SAMP
instance AdmitChildAPPLET SAMP
instance AdmitChildOBJECT SAMP
instance AdmitChildFONT SAMP
instance AdmitChildBASEFONT SAMP
instance AdmitChildBR SAMP
instance AdmitChildSCRIPT SAMP
instance AdmitChildMAP SAMP
instance AdmitChildQ SAMP
instance AdmitChildSUB SAMP
instance AdmitChildSUP SAMP
instance AdmitChildSPAN SAMP
instance AdmitChildBDO SAMP
instance AdmitChildIFRAME SAMP
instance AdmitChildINPUT SAMP
instance AdmitChildSELECT SAMP
instance AdmitChildTEXTAREA SAMP
instance AdmitChildLABEL SAMP
instance AdmitChildBUTTON SAMP

instance AdmitChildCDATA KBD
instance AdmitChildTT KBD
instance AdmitChildI KBD
instance AdmitChildB KBD
instance AdmitChildU KBD
instance AdmitChildS KBD
instance AdmitChildSTRIKE KBD
instance AdmitChildBIG KBD
instance AdmitChildSMALL KBD
instance AdmitChildEM KBD
instance AdmitChildSTRONG KBD
instance AdmitChildDFN KBD
instance AdmitChildCODE KBD
instance AdmitChildSAMP KBD
instance AdmitChildKBD KBD
instance AdmitChildVAR KBD
instance AdmitChildCITE KBD
instance AdmitChildABBR KBD
instance AdmitChildACRONYM KBD
instance AdmitChildA KBD
instance AdmitChildIMG KBD
instance AdmitChildAPPLET KBD
instance AdmitChildOBJECT KBD
instance AdmitChildFONT KBD
instance AdmitChildBASEFONT KBD
instance AdmitChildBR KBD
instance AdmitChildSCRIPT KBD
instance AdmitChildMAP KBD
instance AdmitChildQ KBD
instance AdmitChildSUB KBD
instance AdmitChildSUP KBD
instance AdmitChildSPAN KBD
instance AdmitChildBDO KBD
instance AdmitChildIFRAME KBD
instance AdmitChildINPUT KBD
instance AdmitChildSELECT KBD
instance AdmitChildTEXTAREA KBD
instance AdmitChildLABEL KBD
instance AdmitChildBUTTON KBD

instance AdmitChildCDATA VAR
instance AdmitChildTT VAR
instance AdmitChildI VAR
instance AdmitChildB VAR
instance AdmitChildU VAR
instance AdmitChildS VAR
instance AdmitChildSTRIKE VAR
instance AdmitChildBIG VAR
instance AdmitChildSMALL VAR
instance AdmitChildEM VAR
instance AdmitChildSTRONG VAR
instance AdmitChildDFN VAR
instance AdmitChildCODE VAR
instance AdmitChildSAMP VAR
instance AdmitChildKBD VAR
instance AdmitChildVAR VAR
instance AdmitChildCITE VAR
instance AdmitChildABBR VAR
instance AdmitChildACRONYM VAR
instance AdmitChildA VAR
instance AdmitChildIMG VAR
instance AdmitChildAPPLET VAR
instance AdmitChildOBJECT VAR
instance AdmitChildFONT VAR
instance AdmitChildBASEFONT VAR
instance AdmitChildBR VAR
instance AdmitChildSCRIPT VAR
instance AdmitChildMAP VAR
instance AdmitChildQ VAR
instance AdmitChildSUB VAR
instance AdmitChildSUP VAR
instance AdmitChildSPAN VAR
instance AdmitChildBDO VAR
instance AdmitChildIFRAME VAR
instance AdmitChildINPUT VAR
instance AdmitChildSELECT VAR
instance AdmitChildTEXTAREA VAR
instance AdmitChildLABEL VAR
instance AdmitChildBUTTON VAR

instance AdmitChildCDATA CITE
instance AdmitChildTT CITE
instance AdmitChildI CITE
instance AdmitChildB CITE
instance AdmitChildU CITE
instance AdmitChildS CITE
instance AdmitChildSTRIKE CITE
instance AdmitChildBIG CITE
instance AdmitChildSMALL CITE
instance AdmitChildEM CITE
instance AdmitChildSTRONG CITE
instance AdmitChildDFN CITE
instance AdmitChildCODE CITE
instance AdmitChildSAMP CITE
instance AdmitChildKBD CITE
instance AdmitChildVAR CITE
instance AdmitChildCITE CITE
instance AdmitChildABBR CITE
instance AdmitChildACRONYM CITE
instance AdmitChildA CITE
instance AdmitChildIMG CITE
instance AdmitChildAPPLET CITE
instance AdmitChildOBJECT CITE
instance AdmitChildFONT CITE
instance AdmitChildBASEFONT CITE
instance AdmitChildBR CITE
instance AdmitChildSCRIPT CITE
instance AdmitChildMAP CITE
instance AdmitChildQ CITE
instance AdmitChildSUB CITE
instance AdmitChildSUP CITE
instance AdmitChildSPAN CITE
instance AdmitChildBDO CITE
instance AdmitChildIFRAME CITE
instance AdmitChildINPUT CITE
instance AdmitChildSELECT CITE
instance AdmitChildTEXTAREA CITE
instance AdmitChildLABEL CITE
instance AdmitChildBUTTON CITE

instance AdmitChildCDATA ABBR
instance AdmitChildTT ABBR
instance AdmitChildI ABBR
instance AdmitChildB ABBR
instance AdmitChildU ABBR
instance AdmitChildS ABBR
instance AdmitChildSTRIKE ABBR
instance AdmitChildBIG ABBR
instance AdmitChildSMALL ABBR
instance AdmitChildEM ABBR
instance AdmitChildSTRONG ABBR
instance AdmitChildDFN ABBR
instance AdmitChildCODE ABBR
instance AdmitChildSAMP ABBR
instance AdmitChildKBD ABBR
instance AdmitChildVAR ABBR
instance AdmitChildCITE ABBR
instance AdmitChildABBR ABBR
instance AdmitChildACRONYM ABBR
instance AdmitChildA ABBR
instance AdmitChildIMG ABBR
instance AdmitChildAPPLET ABBR
instance AdmitChildOBJECT ABBR
instance AdmitChildFONT ABBR
instance AdmitChildBASEFONT ABBR
instance AdmitChildBR ABBR
instance AdmitChildSCRIPT ABBR
instance AdmitChildMAP ABBR
instance AdmitChildQ ABBR
instance AdmitChildSUB ABBR
instance AdmitChildSUP ABBR
instance AdmitChildSPAN ABBR
instance AdmitChildBDO ABBR
instance AdmitChildIFRAME ABBR
instance AdmitChildINPUT ABBR
instance AdmitChildSELECT ABBR
instance AdmitChildTEXTAREA ABBR
instance AdmitChildLABEL ABBR
instance AdmitChildBUTTON ABBR

instance AdmitChildCDATA ACRONYM
instance AdmitChildTT ACRONYM
instance AdmitChildI ACRONYM
instance AdmitChildB ACRONYM
instance AdmitChildU ACRONYM
instance AdmitChildS ACRONYM
instance AdmitChildSTRIKE ACRONYM
instance AdmitChildBIG ACRONYM
instance AdmitChildSMALL ACRONYM
instance AdmitChildEM ACRONYM
instance AdmitChildSTRONG ACRONYM
instance AdmitChildDFN ACRONYM
instance AdmitChildCODE ACRONYM
instance AdmitChildSAMP ACRONYM
instance AdmitChildKBD ACRONYM
instance AdmitChildVAR ACRONYM
instance AdmitChildCITE ACRONYM
instance AdmitChildABBR ACRONYM
instance AdmitChildACRONYM ACRONYM
instance AdmitChildA ACRONYM
instance AdmitChildIMG ACRONYM
instance AdmitChildAPPLET ACRONYM
instance AdmitChildOBJECT ACRONYM
instance AdmitChildFONT ACRONYM
instance AdmitChildBASEFONT ACRONYM
instance AdmitChildBR ACRONYM
instance AdmitChildSCRIPT ACRONYM
instance AdmitChildMAP ACRONYM
instance AdmitChildQ ACRONYM
instance AdmitChildSUB ACRONYM
instance AdmitChildSUP ACRONYM
instance AdmitChildSPAN ACRONYM
instance AdmitChildBDO ACRONYM
instance AdmitChildIFRAME ACRONYM
instance AdmitChildINPUT ACRONYM
instance AdmitChildSELECT ACRONYM
instance AdmitChildTEXTAREA ACRONYM
instance AdmitChildLABEL ACRONYM
instance AdmitChildBUTTON ACRONYM
data ALIGN_bottom = ALIGN_bottom
data ALIGN_center = ALIGN_center
data ALIGN_char = ALIGN_char
data ALIGN_justify = ALIGN_justify
data ALIGN_left = ALIGN_left
data ALIGN_middle = ALIGN_middle
data ALIGN_right = ALIGN_right
data ALIGN_top = ALIGN_top
data CHECKED_checked = CHECKED_checked
data CLEAR_all = CLEAR_all
data CLEAR_left = CLEAR_left
data CLEAR_none = CLEAR_none
data CLEAR_right = CLEAR_right
data COMPACT_compact = COMPACT_compact
data DECLARE_declare = DECLARE_declare
data DEFER_defer = DEFER_defer
data DIR_ltr = DIR_ltr
data DIR_rtl = DIR_rtl
data DISABLED_disabled = DISABLED_disabled
data FRAME_above = FRAME_above
data FRAME_below = FRAME_below
data FRAME_border = FRAME_border
data FRAME_box = FRAME_box
data FRAME_hsides = FRAME_hsides
data FRAME_lhs = FRAME_lhs
data FRAME_rhs = FRAME_rhs
data FRAME_void = FRAME_void
data FRAME_vsides = FRAME_vsides
data ISMAP_ismap = ISMAP_ismap
data METHOD_GET = METHOD_GET
data METHOD_POST = METHOD_POST
data MULTIPLE_multiple = MULTIPLE_multiple
data NOHREF_nohref = NOHREF_nohref
data NORESIZE_noresize = NORESIZE_noresize
data NOSHADE_noshade = NOSHADE_noshade
data NOWRAP_nowrap = NOWRAP_nowrap
data READONLY_readonly = READONLY_readonly
data RULES_all = RULES_all
data RULES_cols = RULES_cols
data RULES_groups = RULES_groups
data RULES_none = RULES_none
data RULES_rows = RULES_rows
data SCOPE_col = SCOPE_col
data SCOPE_colgroup = SCOPE_colgroup
data SCOPE_row = SCOPE_row
data SCOPE_rowgroup = SCOPE_rowgroup
data SCROLLING_auto = SCROLLING_auto
data SCROLLING_no = SCROLLING_no
data SCROLLING_yes = SCROLLING_yes
data SELECTED_selected = SELECTED_selected
data SHAPE_circle = SHAPE_circle
data SHAPE_default' = SHAPE_default'
data SHAPE_poly = SHAPE_poly
data SHAPE_rect = SHAPE_rect
data TYPE_BUTTON = TYPE_BUTTON
data TYPE_CHECKBOX = TYPE_CHECKBOX
data TYPE_FILE = TYPE_FILE
data TYPE_HIDDEN = TYPE_HIDDEN
data TYPE_IMAGE = TYPE_IMAGE
data TYPE_PASSWORD = TYPE_PASSWORD
data TYPE_RADIO = TYPE_RADIO
data TYPE_RESET = TYPE_RESET
data TYPE_SUBMIT = TYPE_SUBMIT
data TYPE_TEXT = TYPE_TEXT
data TYPE_button = TYPE_button
data TYPE_circle = TYPE_circle
data TYPE_disc = TYPE_disc
data TYPE_reset = TYPE_reset
data TYPE_square = TYPE_square
data TYPE_submit = TYPE_submit
data VALIGN_baseline = VALIGN_baseline
data VALIGN_bottom = VALIGN_bottom
data VALIGN_middle = VALIGN_middle
data VALIGN_top = VALIGN_top
data VALUETYPE_DATA = VALUETYPE_DATA
data VALUETYPE_OBJECT = VALUETYPE_OBJECT
data VALUETYPE_REF = VALUETYPE_REF
instance AttrValueABBR Char
instance AttrValueABBR a => AttrValueABBR [a]
instance AttrValueACCEPT Char
instance AttrValueACCEPT a => AttrValueACCEPT [a]
instance AttrValueACCEPT_CHARSET Char
instance AttrValueACCEPT_CHARSET a => AttrValueACCEPT_CHARSET [a]
instance AttrValueACCESSKEY Char
instance AttrValueACCESSKEY a => AttrValueACCESSKEY [a]
instance AttrValueACTION Char
instance AttrValueACTION a => AttrValueACTION [a]
instance AttrValueALIGN ALIGN_bottom
instance AttrValueALIGN ALIGN_center
instance AttrValueALIGN ALIGN_char
instance AttrValueALIGN ALIGN_justify
instance AttrValueALIGN ALIGN_left
instance AttrValueALIGN ALIGN_middle
instance AttrValueALIGN ALIGN_right
instance AttrValueALIGN ALIGN_top
instance AttrValueALINK Char
instance AttrValueALINK a => AttrValueALINK [a]
instance AttrValueALT Char
instance AttrValueALT a => AttrValueALT [a]
instance AttrValueARCHIVE Char
instance AttrValueARCHIVE a => AttrValueARCHIVE [a]
instance AttrValueAXIS Char
instance AttrValueAXIS a => AttrValueAXIS [a]
instance AttrValueBACKGROUND Char
instance AttrValueBACKGROUND a => AttrValueBACKGROUND [a]
instance AttrValueBGCOLOR Char
instance AttrValueBGCOLOR a => AttrValueBGCOLOR [a]
instance AttrValueBORDER Char
instance AttrValueBORDER a => AttrValueBORDER [a]
instance AttrValueCELLPADDING Char
instance AttrValueCELLPADDING a => AttrValueCELLPADDING [a]
instance AttrValueCELLSPACING Char
instance AttrValueCELLSPACING a => AttrValueCELLSPACING [a]
instance AttrValueCHAR Char
instance AttrValueCHAR a => AttrValueCHAR [a]
instance AttrValueCHAROFF Char
instance AttrValueCHAROFF a => AttrValueCHAROFF [a]
instance AttrValueCHARSET Char
instance AttrValueCHARSET a => AttrValueCHARSET [a]
instance AttrValueCHECKED CHECKED_checked
instance AttrValueCITE Char
instance AttrValueCITE a => AttrValueCITE [a]
instance AttrValueCLASS Char
instance AttrValueCLASS a => AttrValueCLASS [a]
instance AttrValueCLASSID Char
instance AttrValueCLASSID a => AttrValueCLASSID [a]
instance AttrValueCLEAR CLEAR_all
instance AttrValueCLEAR CLEAR_left
instance AttrValueCLEAR CLEAR_none
instance AttrValueCLEAR CLEAR_right
instance AttrValueCODE Char
instance AttrValueCODE a => AttrValueCODE [a]
instance AttrValueCODEBASE Char
instance AttrValueCODEBASE a => AttrValueCODEBASE [a]
instance AttrValueCODETYPE Char
instance AttrValueCODETYPE a => AttrValueCODETYPE [a]
instance AttrValueCOLOR Char
instance AttrValueCOLOR a => AttrValueCOLOR [a]
instance AttrValueCOLS Char
instance AttrValueCOLS Int
instance AttrValueCOLS a => AttrValueCOLS [a]
instance AttrValueCOLSPAN Int
instance AttrValueCOMPACT COMPACT_compact
instance AttrValueCONTENT Char
instance AttrValueCONTENT a => AttrValueCONTENT [a]
instance AttrValueCOORDS Char
instance AttrValueCOORDS a => AttrValueCOORDS [a]
instance AttrValueDATA Char
instance AttrValueDATA a => AttrValueDATA [a]
instance AttrValueDATAPAGESIZE Char
instance AttrValueDATAPAGESIZE a => AttrValueDATAPAGESIZE [a]
instance AttrValueDATETIME Char
instance AttrValueDATETIME a => AttrValueDATETIME [a]
instance AttrValueDECLARE DECLARE_declare
instance AttrValueDEFER DEFER_defer
instance AttrValueDIR DIR_ltr
instance AttrValueDIR DIR_rtl
instance AttrValueDISABLED DISABLED_disabled
instance AttrValueENCTYPE Char
instance AttrValueENCTYPE a => AttrValueENCTYPE [a]
instance AttrValueEVENT Char
instance AttrValueEVENT a => AttrValueEVENT [a]
instance AttrValueFACE Char
instance AttrValueFACE a => AttrValueFACE [a]
instance AttrValueFOR Char
instance AttrValueFOR a => AttrValueFOR [a]
instance AttrValueFRAME FRAME_above
instance AttrValueFRAME FRAME_below
instance AttrValueFRAME FRAME_border
instance AttrValueFRAME FRAME_box
instance AttrValueFRAME FRAME_hsides
instance AttrValueFRAME FRAME_lhs
instance AttrValueFRAME FRAME_rhs
instance AttrValueFRAME FRAME_void
instance AttrValueFRAME FRAME_vsides
instance AttrValueFRAMEBORDER Int
instance AttrValueHEADERS Char
instance AttrValueHEADERS a => AttrValueHEADERS [a]
instance AttrValueHEIGHT Char
instance AttrValueHEIGHT a => AttrValueHEIGHT [a]
instance AttrValueHREF Char
instance AttrValueHREF a => AttrValueHREF [a]
instance AttrValueHREFLANG Char
instance AttrValueHREFLANG a => AttrValueHREFLANG [a]
instance AttrValueHSPACE Char
instance AttrValueHSPACE a => AttrValueHSPACE [a]
instance AttrValueHTTP_EQUIV Char
instance AttrValueHTTP_EQUIV a => AttrValueHTTP_EQUIV [a]
instance AttrValueID Char
instance AttrValueID a => AttrValueID [a]
instance AttrValueISMAP ISMAP_ismap
instance AttrValueLABEL Char
instance AttrValueLABEL a => AttrValueLABEL [a]
instance AttrValueLANG Char
instance AttrValueLANG a => AttrValueLANG [a]
instance AttrValueLANGUAGE Char
instance AttrValueLANGUAGE a => AttrValueLANGUAGE [a]
instance AttrValueLINK Char
instance AttrValueLINK a => AttrValueLINK [a]
instance AttrValueLONGDESC Char
instance AttrValueLONGDESC a => AttrValueLONGDESC [a]
instance AttrValueMARGINHEIGHT Char
instance AttrValueMARGINHEIGHT a => AttrValueMARGINHEIGHT [a]
instance AttrValueMARGINWIDTH Char
instance AttrValueMARGINWIDTH a => AttrValueMARGINWIDTH [a]
instance AttrValueMAXLENGTH Int
instance AttrValueMEDIA Char
instance AttrValueMEDIA a => AttrValueMEDIA [a]
instance AttrValueMETHOD METHOD_GET
instance AttrValueMETHOD METHOD_POST
instance AttrValueMULTIPLE MULTIPLE_multiple
instance AttrValueNAME Char
instance AttrValueNAME a => AttrValueNAME [a]
instance AttrValueNOHREF NOHREF_nohref
instance AttrValueNORESIZE NORESIZE_noresize
instance AttrValueNOSHADE NOSHADE_noshade
instance AttrValueNOWRAP NOWRAP_nowrap
instance AttrValueOBJECT Char
instance AttrValueOBJECT a => AttrValueOBJECT [a]
instance AttrValueONBLUR Char
instance AttrValueONBLUR a => AttrValueONBLUR [a]
instance AttrValueONCHANGE Char
instance AttrValueONCHANGE a => AttrValueONCHANGE [a]
instance AttrValueONCLICK Char
instance AttrValueONCLICK a => AttrValueONCLICK [a]
instance AttrValueONDBLCLICK Char
instance AttrValueONDBLCLICK a => AttrValueONDBLCLICK [a]
instance AttrValueONFOCUS Char
instance AttrValueONFOCUS a => AttrValueONFOCUS [a]
instance AttrValueONKEYDOWN Char
instance AttrValueONKEYDOWN a => AttrValueONKEYDOWN [a]
instance AttrValueONKEYPRESS Char
instance AttrValueONKEYPRESS a => AttrValueONKEYPRESS [a]
instance AttrValueONKEYUP Char
instance AttrValueONKEYUP a => AttrValueONKEYUP [a]
instance AttrValueONLOAD Char
instance AttrValueONLOAD a => AttrValueONLOAD [a]
instance AttrValueONMOUSEDOWN Char
instance AttrValueONMOUSEDOWN a => AttrValueONMOUSEDOWN [a]
instance AttrValueONMOUSEMOVE Char
instance AttrValueONMOUSEMOVE a => AttrValueONMOUSEMOVE [a]
instance AttrValueONMOUSEOUT Char
instance AttrValueONMOUSEOUT a => AttrValueONMOUSEOUT [a]
instance AttrValueONMOUSEOVER Char
instance AttrValueONMOUSEOVER a => AttrValueONMOUSEOVER [a]
instance AttrValueONMOUSEUP Char
instance AttrValueONMOUSEUP a => AttrValueONMOUSEUP [a]
instance AttrValueONRESET Char
instance AttrValueONRESET a => AttrValueONRESET [a]
instance AttrValueONSELECT Char
instance AttrValueONSELECT a => AttrValueONSELECT [a]
instance AttrValueONSUBMIT Char
instance AttrValueONSUBMIT a => AttrValueONSUBMIT [a]
instance AttrValueONUNLOAD Char
instance AttrValueONUNLOAD a => AttrValueONUNLOAD [a]
instance AttrValuePROFILE Char
instance AttrValuePROFILE a => AttrValuePROFILE [a]
instance AttrValuePROMPT Char
instance AttrValuePROMPT a => AttrValuePROMPT [a]
instance AttrValueREADONLY READONLY_readonly
instance AttrValueREL Char
instance AttrValueREL a => AttrValueREL [a]
instance AttrValueREV Char
instance AttrValueREV a => AttrValueREV [a]
instance AttrValueROWS Char
instance AttrValueROWS Int
instance AttrValueROWS a => AttrValueROWS [a]
instance AttrValueROWSPAN Int
instance AttrValueRULES RULES_all
instance AttrValueRULES RULES_cols
instance AttrValueRULES RULES_groups
instance AttrValueRULES RULES_none
instance AttrValueRULES RULES_rows
instance AttrValueSCHEME Char
instance AttrValueSCHEME a => AttrValueSCHEME [a]
instance AttrValueSCOPE SCOPE_col
instance AttrValueSCOPE SCOPE_colgroup
instance AttrValueSCOPE SCOPE_row
instance AttrValueSCOPE SCOPE_rowgroup
instance AttrValueSCROLLING SCROLLING_auto
instance AttrValueSCROLLING SCROLLING_no
instance AttrValueSCROLLING SCROLLING_yes
instance AttrValueSELECTED SELECTED_selected
instance AttrValueSHAPE SHAPE_circle
instance AttrValueSHAPE SHAPE_default'
instance AttrValueSHAPE SHAPE_poly
instance AttrValueSHAPE SHAPE_rect
instance AttrValueSIZE Char
instance AttrValueSIZE Int
instance AttrValueSIZE a => AttrValueSIZE [a]
instance AttrValueSPAN Int
instance AttrValueSRC Char
instance AttrValueSRC a => AttrValueSRC [a]
instance AttrValueSTANDBY Char
instance AttrValueSTANDBY a => AttrValueSTANDBY [a]
instance AttrValueSTART Int
instance AttrValueSTYLE Char
instance AttrValueSTYLE a => AttrValueSTYLE [a]
instance AttrValueSUMMARY Char
instance AttrValueSUMMARY a => AttrValueSUMMARY [a]
instance AttrValueTABINDEX Int
instance AttrValueTARGET Char
instance AttrValueTARGET a => AttrValueTARGET [a]
instance AttrValueTEXT Char
instance AttrValueTEXT a => AttrValueTEXT [a]
instance AttrValueTITLE Char
instance AttrValueTITLE a => AttrValueTITLE [a]
instance AttrValueTYPE Char
instance AttrValueTYPE TYPE_BUTTON
instance AttrValueTYPE TYPE_CHECKBOX
instance AttrValueTYPE TYPE_FILE
instance AttrValueTYPE TYPE_HIDDEN
instance AttrValueTYPE TYPE_IMAGE
instance AttrValueTYPE TYPE_PASSWORD
instance AttrValueTYPE TYPE_RADIO
instance AttrValueTYPE TYPE_RESET
instance AttrValueTYPE TYPE_SUBMIT
instance AttrValueTYPE TYPE_TEXT
instance AttrValueTYPE TYPE_button
instance AttrValueTYPE TYPE_circle
instance AttrValueTYPE TYPE_disc
instance AttrValueTYPE TYPE_reset
instance AttrValueTYPE TYPE_square
instance AttrValueTYPE TYPE_submit
instance AttrValueTYPE a => AttrValueTYPE [a]
instance AttrValueUSEMAP Char
instance AttrValueUSEMAP a => AttrValueUSEMAP [a]
instance AttrValueVALIGN VALIGN_baseline
instance AttrValueVALIGN VALIGN_bottom
instance AttrValueVALIGN VALIGN_middle
instance AttrValueVALIGN VALIGN_top
instance AttrValueVALUE Char
instance AttrValueVALUE Int
instance AttrValueVALUE a => AttrValueVALUE [a]
instance AttrValueVALUETYPE VALUETYPE_DATA
instance AttrValueVALUETYPE VALUETYPE_OBJECT
instance AttrValueVALUETYPE VALUETYPE_REF
instance AttrValueVERSION Char
instance AttrValueVERSION a => AttrValueVERSION [a]
instance AttrValueVLINK Char
instance AttrValueVLINK a => AttrValueVLINK [a]
instance AttrValueVSPACE Char
instance AttrValueVSPACE a => AttrValueVSPACE [a]
instance AttrValueWIDTH Char
instance AttrValueWIDTH Int
instance AttrValueWIDTH a => AttrValueWIDTH [a]
instance Show ALIGN_bottom where show ALIGN_bottom = "bottom"
instance Show ALIGN_center where show ALIGN_center = "center"
instance Show ALIGN_char where show ALIGN_char = "char"
instance Show ALIGN_justify where show ALIGN_justify = "justify"
instance Show ALIGN_left where show ALIGN_left = "left"
instance Show ALIGN_middle where show ALIGN_middle = "middle"
instance Show ALIGN_right where show ALIGN_right = "right"
instance Show ALIGN_top where show ALIGN_top = "top"
instance Show CHECKED_checked where show CHECKED_checked = "checked"
instance Show CLEAR_all where show CLEAR_all = "all"
instance Show CLEAR_left where show CLEAR_left = "left"
instance Show CLEAR_none where show CLEAR_none = "none"
instance Show CLEAR_right where show CLEAR_right = "right"
instance Show COMPACT_compact where show COMPACT_compact = "compact"
instance Show DECLARE_declare where show DECLARE_declare = "declare"
instance Show DEFER_defer where show DEFER_defer = "defer"
instance Show DIR_ltr where show DIR_ltr = "ltr"
instance Show DIR_rtl where show DIR_rtl = "rtl"
instance Show DISABLED_disabled where show DISABLED_disabled = "disabled"
instance Show FRAME_above where show FRAME_above = "above"
instance Show FRAME_below where show FRAME_below = "below"
instance Show FRAME_border where show FRAME_border = "border"
instance Show FRAME_box where show FRAME_box = "box"
instance Show FRAME_hsides where show FRAME_hsides = "hsides"
instance Show FRAME_lhs where show FRAME_lhs = "lhs"
instance Show FRAME_rhs where show FRAME_rhs = "rhs"
instance Show FRAME_void where show FRAME_void = "void"
instance Show FRAME_vsides where show FRAME_vsides = "vsides"
instance Show ISMAP_ismap where show ISMAP_ismap = "ismap"
instance Show METHOD_GET where show METHOD_GET = "GET"
instance Show METHOD_POST where show METHOD_POST = "POST"
instance Show MULTIPLE_multiple where show MULTIPLE_multiple = "multiple"
instance Show NOHREF_nohref where show NOHREF_nohref = "nohref"
instance Show NORESIZE_noresize where show NORESIZE_noresize = "noresize"
instance Show NOSHADE_noshade where show NOSHADE_noshade = "noshade"
instance Show NOWRAP_nowrap where show NOWRAP_nowrap = "nowrap"
instance Show READONLY_readonly where show READONLY_readonly = "readonly"
instance Show RULES_all where show RULES_all = "all"
instance Show RULES_cols where show RULES_cols = "cols"
instance Show RULES_groups where show RULES_groups = "groups"
instance Show RULES_none where show RULES_none = "none"
instance Show RULES_rows where show RULES_rows = "rows"
instance Show SCOPE_col where show SCOPE_col = "col"
instance Show SCOPE_colgroup where show SCOPE_colgroup = "colgroup"
instance Show SCOPE_row where show SCOPE_row = "row"
instance Show SCOPE_rowgroup where show SCOPE_rowgroup = "rowgroup"
instance Show SCROLLING_auto where show SCROLLING_auto = "auto"
instance Show SCROLLING_no where show SCROLLING_no = "no"
instance Show SCROLLING_yes where show SCROLLING_yes = "yes"
instance Show SELECTED_selected where show SELECTED_selected = "selected"
instance Show SHAPE_circle where show SHAPE_circle = "circle"
instance Show SHAPE_default' where show SHAPE_default' = "default"
instance Show SHAPE_poly where show SHAPE_poly = "poly"
instance Show SHAPE_rect where show SHAPE_rect = "rect"
instance Show TYPE_BUTTON where show TYPE_BUTTON = "BUTTON"
instance Show TYPE_CHECKBOX where show TYPE_CHECKBOX = "CHECKBOX"
instance Show TYPE_FILE where show TYPE_FILE = "FILE"
instance Show TYPE_HIDDEN where show TYPE_HIDDEN = "HIDDEN"
instance Show TYPE_IMAGE where show TYPE_IMAGE = "IMAGE"
instance Show TYPE_PASSWORD where show TYPE_PASSWORD = "PASSWORD"
instance Show TYPE_RADIO where show TYPE_RADIO = "RADIO"
instance Show TYPE_RESET where show TYPE_RESET = "RESET"
instance Show TYPE_SUBMIT where show TYPE_SUBMIT = "SUBMIT"
instance Show TYPE_TEXT where show TYPE_TEXT = "TEXT"
instance Show TYPE_button where show TYPE_button = "button"
instance Show TYPE_circle where show TYPE_circle = "circle"
instance Show TYPE_disc where show TYPE_disc = "disc"
instance Show TYPE_reset where show TYPE_reset = "reset"
instance Show TYPE_square where show TYPE_square = "square"
instance Show TYPE_submit where show TYPE_submit = "submit"
instance Show VALIGN_baseline where show VALIGN_baseline = "baseline"
instance Show VALIGN_bottom where show VALIGN_bottom = "bottom"
instance Show VALIGN_middle where show VALIGN_middle = "middle"
instance Show VALIGN_top where show VALIGN_top = "top"
instance Show VALUETYPE_DATA where show VALUETYPE_DATA = "DATA"
instance Show VALUETYPE_OBJECT where show VALUETYPE_OBJECT = "OBJECT"
instance Show VALUETYPE_REF where show VALUETYPE_REF = "REF"
instance AdmitAttrABBR TD
instance AdmitAttrABBR TH
instance AdmitAttrACCEPT INPUT
instance AdmitAttrACCEPT_CHARSET FORM
instance AdmitAttrACCESSKEY A
instance AdmitAttrACCESSKEY AREA
instance AdmitAttrACCESSKEY BUTTON
instance AdmitAttrACCESSKEY INPUT
instance AdmitAttrACCESSKEY LABEL
instance AdmitAttrACCESSKEY LEGEND
instance AdmitAttrACCESSKEY TEXTAREA
instance AdmitAttrACTION FORM
instance AdmitAttrALIGN APPLET
instance AdmitAttrALIGN CAPTION
instance AdmitAttrALIGN COL
instance AdmitAttrALIGN COLGROUP
instance AdmitAttrALIGN DIV
instance AdmitAttrALIGN H1
instance AdmitAttrALIGN H2
instance AdmitAttrALIGN H3
instance AdmitAttrALIGN H4
instance AdmitAttrALIGN H5
instance AdmitAttrALIGN H6
instance AdmitAttrALIGN HR
instance AdmitAttrALIGN IFRAME
instance AdmitAttrALIGN IMG
instance AdmitAttrALIGN INPUT
instance AdmitAttrALIGN LEGEND
instance AdmitAttrALIGN OBJECT
instance AdmitAttrALIGN P
instance AdmitAttrALIGN TABLE
instance AdmitAttrALIGN TBODY
instance AdmitAttrALIGN TD
instance AdmitAttrALIGN TFOOT
instance AdmitAttrALIGN TH
instance AdmitAttrALIGN THEAD
instance AdmitAttrALIGN TR
instance AdmitAttrALINK BODY
instance AdmitAttrALT APPLET
instance AdmitAttrALT AREA
instance AdmitAttrALT IMG
instance AdmitAttrALT INPUT
instance AdmitAttrARCHIVE APPLET
instance AdmitAttrARCHIVE OBJECT
instance AdmitAttrAXIS TD
instance AdmitAttrAXIS TH
instance AdmitAttrBACKGROUND BODY
instance AdmitAttrBGCOLOR BODY
instance AdmitAttrBGCOLOR TABLE
instance AdmitAttrBGCOLOR TD
instance AdmitAttrBGCOLOR TH
instance AdmitAttrBGCOLOR TR
instance AdmitAttrBORDER IMG
instance AdmitAttrBORDER OBJECT
instance AdmitAttrBORDER TABLE
instance AdmitAttrCELLPADDING TABLE
instance AdmitAttrCELLSPACING TABLE
instance AdmitAttrCHAR COL
instance AdmitAttrCHAR COLGROUP
instance AdmitAttrCHAR TBODY
instance AdmitAttrCHAR TD
instance AdmitAttrCHAR TFOOT
instance AdmitAttrCHAR TH
instance AdmitAttrCHAR THEAD
instance AdmitAttrCHAR TR
instance AdmitAttrCHAROFF COL
instance AdmitAttrCHAROFF COLGROUP
instance AdmitAttrCHAROFF TBODY
instance AdmitAttrCHAROFF TD
instance AdmitAttrCHAROFF TFOOT
instance AdmitAttrCHAROFF TH
instance AdmitAttrCHAROFF THEAD
instance AdmitAttrCHAROFF TR
instance AdmitAttrCHARSET A
instance AdmitAttrCHARSET LINK
instance AdmitAttrCHARSET SCRIPT
instance AdmitAttrCHECKED INPUT
instance AdmitAttrCITE BLOCKQUOTE
instance AdmitAttrCITE DEL
instance AdmitAttrCITE INS
instance AdmitAttrCITE Q
instance AdmitAttrCLASS A
instance AdmitAttrCLASS ABBR
instance AdmitAttrCLASS ACRONYM
instance AdmitAttrCLASS ADDRESS
instance AdmitAttrCLASS APPLET
instance AdmitAttrCLASS AREA
instance AdmitAttrCLASS B
instance AdmitAttrCLASS BDO
instance AdmitAttrCLASS BIG
instance AdmitAttrCLASS BLOCKQUOTE
instance AdmitAttrCLASS BODY
instance AdmitAttrCLASS BR
instance AdmitAttrCLASS BUTTON
instance AdmitAttrCLASS CAPTION
instance AdmitAttrCLASS CENTER
instance AdmitAttrCLASS CITE
instance AdmitAttrCLASS CODE
instance AdmitAttrCLASS COL
instance AdmitAttrCLASS COLGROUP
instance AdmitAttrCLASS DD
instance AdmitAttrCLASS DEL
instance AdmitAttrCLASS DFN
instance AdmitAttrCLASS DIR
instance AdmitAttrCLASS DIV
instance AdmitAttrCLASS DL
instance AdmitAttrCLASS DT
instance AdmitAttrCLASS EM
instance AdmitAttrCLASS FIELDSET
instance AdmitAttrCLASS FONT
instance AdmitAttrCLASS FORM
instance AdmitAttrCLASS FRAME
instance AdmitAttrCLASS FRAMESET
instance AdmitAttrCLASS H1
instance AdmitAttrCLASS H2
instance AdmitAttrCLASS H3
instance AdmitAttrCLASS H4
instance AdmitAttrCLASS H5
instance AdmitAttrCLASS H6
instance AdmitAttrCLASS HR
instance AdmitAttrCLASS I
instance AdmitAttrCLASS IFRAME
instance AdmitAttrCLASS IMG
instance AdmitAttrCLASS INPUT
instance AdmitAttrCLASS INS
instance AdmitAttrCLASS ISINDEX
instance AdmitAttrCLASS KBD
instance AdmitAttrCLASS LABEL
instance AdmitAttrCLASS LEGEND
instance AdmitAttrCLASS LI
instance AdmitAttrCLASS LINK
instance AdmitAttrCLASS MAP
instance AdmitAttrCLASS MENU
instance AdmitAttrCLASS NOFRAMES
instance AdmitAttrCLASS NOSCRIPT
instance AdmitAttrCLASS OBJECT
instance AdmitAttrCLASS OL
instance AdmitAttrCLASS OPTGROUP
instance AdmitAttrCLASS OPTION
instance AdmitAttrCLASS P
instance AdmitAttrCLASS PRE
instance AdmitAttrCLASS Q
instance AdmitAttrCLASS S
instance AdmitAttrCLASS SAMP
instance AdmitAttrCLASS SELECT
instance AdmitAttrCLASS SMALL
instance AdmitAttrCLASS SPAN
instance AdmitAttrCLASS STRIKE
instance AdmitAttrCLASS STRONG
instance AdmitAttrCLASS SUB
instance AdmitAttrCLASS SUP
instance AdmitAttrCLASS TABLE
instance AdmitAttrCLASS TBODY
instance AdmitAttrCLASS TD
instance AdmitAttrCLASS TEXTAREA
instance AdmitAttrCLASS TFOOT
instance AdmitAttrCLASS TH
instance AdmitAttrCLASS THEAD
instance AdmitAttrCLASS TR
instance AdmitAttrCLASS TT
instance AdmitAttrCLASS U
instance AdmitAttrCLASS UL
instance AdmitAttrCLASS VAR
instance AdmitAttrCLASSID OBJECT
instance AdmitAttrCLEAR BR
instance AdmitAttrCODE APPLET
instance AdmitAttrCODEBASE APPLET
instance AdmitAttrCODEBASE OBJECT
instance AdmitAttrCODETYPE OBJECT
instance AdmitAttrCOLOR BASEFONT
instance AdmitAttrCOLOR FONT
instance AdmitAttrCOLS FRAMESET
instance AdmitAttrCOLS TEXTAREA
instance AdmitAttrCOLSPAN TD
instance AdmitAttrCOLSPAN TH
instance AdmitAttrCOMPACT DIR
instance AdmitAttrCOMPACT DL
instance AdmitAttrCOMPACT MENU
instance AdmitAttrCOMPACT OL
instance AdmitAttrCOMPACT UL
instance AdmitAttrCONTENT META
instance AdmitAttrCOORDS A
instance AdmitAttrCOORDS AREA
instance AdmitAttrDATA OBJECT
instance AdmitAttrDATAPAGESIZE TABLE
instance AdmitAttrDATETIME DEL
instance AdmitAttrDATETIME INS
instance AdmitAttrDECLARE OBJECT
instance AdmitAttrDEFER SCRIPT
instance AdmitAttrDIR A
instance AdmitAttrDIR ABBR
instance AdmitAttrDIR ACRONYM
instance AdmitAttrDIR ADDRESS
instance AdmitAttrDIR AREA
instance AdmitAttrDIR B
instance AdmitAttrDIR BDO
instance AdmitAttrDIR BIG
instance AdmitAttrDIR BLOCKQUOTE
instance AdmitAttrDIR BODY
instance AdmitAttrDIR BUTTON
instance AdmitAttrDIR CAPTION
instance AdmitAttrDIR CENTER
instance AdmitAttrDIR CITE
instance AdmitAttrDIR CODE
instance AdmitAttrDIR COL
instance AdmitAttrDIR COLGROUP
instance AdmitAttrDIR DD
instance AdmitAttrDIR DEL
instance AdmitAttrDIR DFN
instance AdmitAttrDIR DIR
instance AdmitAttrDIR DIV
instance AdmitAttrDIR DL
instance AdmitAttrDIR DT
instance AdmitAttrDIR EM
instance AdmitAttrDIR FIELDSET
instance AdmitAttrDIR FONT
instance AdmitAttrDIR FORM
instance AdmitAttrDIR H1
instance AdmitAttrDIR H2
instance AdmitAttrDIR H3
instance AdmitAttrDIR H4
instance AdmitAttrDIR H5
instance AdmitAttrDIR H6
instance AdmitAttrDIR HEAD
instance AdmitAttrDIR HR
instance AdmitAttrDIR HTML
instance AdmitAttrDIR I
instance AdmitAttrDIR IMG
instance AdmitAttrDIR INPUT
instance AdmitAttrDIR INS
instance AdmitAttrDIR ISINDEX
instance AdmitAttrDIR KBD
instance AdmitAttrDIR LABEL
instance AdmitAttrDIR LEGEND
instance AdmitAttrDIR LI
instance AdmitAttrDIR LINK
instance AdmitAttrDIR MAP
instance AdmitAttrDIR MENU
instance AdmitAttrDIR META
instance AdmitAttrDIR NOFRAMES
instance AdmitAttrDIR NOSCRIPT
instance AdmitAttrDIR OBJECT
instance AdmitAttrDIR OL
instance AdmitAttrDIR OPTGROUP
instance AdmitAttrDIR OPTION
instance AdmitAttrDIR P
instance AdmitAttrDIR PRE
instance AdmitAttrDIR Q
instance AdmitAttrDIR S
instance AdmitAttrDIR SAMP
instance AdmitAttrDIR SELECT
instance AdmitAttrDIR SMALL
instance AdmitAttrDIR SPAN
instance AdmitAttrDIR STRIKE
instance AdmitAttrDIR STRONG
instance AdmitAttrDIR STYLE
instance AdmitAttrDIR SUB
instance AdmitAttrDIR SUP
instance AdmitAttrDIR TABLE
instance AdmitAttrDIR TBODY
instance AdmitAttrDIR TD
instance AdmitAttrDIR TEXTAREA
instance AdmitAttrDIR TFOOT
instance AdmitAttrDIR TH
instance AdmitAttrDIR THEAD
instance AdmitAttrDIR TITLE
instance AdmitAttrDIR TR
instance AdmitAttrDIR TT
instance AdmitAttrDIR U
instance AdmitAttrDIR UL
instance AdmitAttrDIR VAR
instance AdmitAttrDISABLED BUTTON
instance AdmitAttrDISABLED INPUT
instance AdmitAttrDISABLED OPTGROUP
instance AdmitAttrDISABLED OPTION
instance AdmitAttrDISABLED SELECT
instance AdmitAttrDISABLED TEXTAREA
instance AdmitAttrENCTYPE FORM
instance AdmitAttrEVENT SCRIPT
instance AdmitAttrFACE BASEFONT
instance AdmitAttrFACE FONT
instance AdmitAttrFOR LABEL
instance AdmitAttrFOR SCRIPT
instance AdmitAttrFRAME TABLE
instance AdmitAttrFRAMEBORDER FRAME
instance AdmitAttrFRAMEBORDER IFRAME
instance AdmitAttrHEADERS TD
instance AdmitAttrHEADERS TH
instance AdmitAttrHEIGHT APPLET
instance AdmitAttrHEIGHT IFRAME
instance AdmitAttrHEIGHT IMG
instance AdmitAttrHEIGHT OBJECT
instance AdmitAttrHEIGHT TD
instance AdmitAttrHEIGHT TH
instance AdmitAttrHREF A
instance AdmitAttrHREF AREA
instance AdmitAttrHREF BASE
instance AdmitAttrHREF LINK
instance AdmitAttrHREFLANG A
instance AdmitAttrHREFLANG LINK
instance AdmitAttrHSPACE APPLET
instance AdmitAttrHSPACE IMG
instance AdmitAttrHSPACE OBJECT
instance AdmitAttrHTTP_EQUIV META
instance AdmitAttrID A
instance AdmitAttrID ABBR
instance AdmitAttrID ACRONYM
instance AdmitAttrID ADDRESS
instance AdmitAttrID APPLET
instance AdmitAttrID AREA
instance AdmitAttrID B
instance AdmitAttrID BASEFONT
instance AdmitAttrID BDO
instance AdmitAttrID BIG
instance AdmitAttrID BLOCKQUOTE
instance AdmitAttrID BODY
instance AdmitAttrID BR
instance AdmitAttrID BUTTON
instance AdmitAttrID CAPTION
instance AdmitAttrID CENTER
instance AdmitAttrID CITE
instance AdmitAttrID CODE
instance AdmitAttrID COL
instance AdmitAttrID COLGROUP
instance AdmitAttrID DD
instance AdmitAttrID DEL
instance AdmitAttrID DFN
instance AdmitAttrID DIR
instance AdmitAttrID DIV
instance AdmitAttrID DL
instance AdmitAttrID DT
instance AdmitAttrID EM
instance AdmitAttrID FIELDSET
instance AdmitAttrID FONT
instance AdmitAttrID FORM
instance AdmitAttrID FRAME
instance AdmitAttrID FRAMESET
instance AdmitAttrID H1
instance AdmitAttrID H2
instance AdmitAttrID H3
instance AdmitAttrID H4
instance AdmitAttrID H5
instance AdmitAttrID H6
instance AdmitAttrID HR
instance AdmitAttrID I
instance AdmitAttrID IFRAME
instance AdmitAttrID IMG
instance AdmitAttrID INPUT
instance AdmitAttrID INS
instance AdmitAttrID ISINDEX
instance AdmitAttrID KBD
instance AdmitAttrID LABEL
instance AdmitAttrID LEGEND
instance AdmitAttrID LI
instance AdmitAttrID LINK
instance AdmitAttrID MAP
instance AdmitAttrID MENU
instance AdmitAttrID NOFRAMES
instance AdmitAttrID NOSCRIPT
instance AdmitAttrID OBJECT
instance AdmitAttrID OL
instance AdmitAttrID OPTGROUP
instance AdmitAttrID OPTION
instance AdmitAttrID P
instance AdmitAttrID PARAM
instance AdmitAttrID PRE
instance AdmitAttrID Q
instance AdmitAttrID S
instance AdmitAttrID SAMP
instance AdmitAttrID SELECT
instance AdmitAttrID SMALL
instance AdmitAttrID SPAN
instance AdmitAttrID STRIKE
instance AdmitAttrID STRONG
instance AdmitAttrID SUB
instance AdmitAttrID SUP
instance AdmitAttrID TABLE
instance AdmitAttrID TBODY
instance AdmitAttrID TD
instance AdmitAttrID TEXTAREA
instance AdmitAttrID TFOOT
instance AdmitAttrID TH
instance AdmitAttrID THEAD
instance AdmitAttrID TR
instance AdmitAttrID TT
instance AdmitAttrID U
instance AdmitAttrID UL
instance AdmitAttrID VAR
instance AdmitAttrISMAP IMG
instance AdmitAttrISMAP INPUT
instance AdmitAttrLABEL OPTGROUP
instance AdmitAttrLABEL OPTION
instance AdmitAttrLANG A
instance AdmitAttrLANG ABBR
instance AdmitAttrLANG ACRONYM
instance AdmitAttrLANG ADDRESS
instance AdmitAttrLANG AREA
instance AdmitAttrLANG B
instance AdmitAttrLANG BDO
instance AdmitAttrLANG BIG
instance AdmitAttrLANG BLOCKQUOTE
instance AdmitAttrLANG BODY
instance AdmitAttrLANG BUTTON
instance AdmitAttrLANG CAPTION
instance AdmitAttrLANG CENTER
instance AdmitAttrLANG CITE
instance AdmitAttrLANG CODE
instance AdmitAttrLANG COL
instance AdmitAttrLANG COLGROUP
instance AdmitAttrLANG DD
instance AdmitAttrLANG DEL
instance AdmitAttrLANG DFN
instance AdmitAttrLANG DIR
instance AdmitAttrLANG DIV
instance AdmitAttrLANG DL
instance AdmitAttrLANG DT
instance AdmitAttrLANG EM
instance AdmitAttrLANG FIELDSET
instance AdmitAttrLANG FONT
instance AdmitAttrLANG FORM
instance AdmitAttrLANG H1
instance AdmitAttrLANG H2
instance AdmitAttrLANG H3
instance AdmitAttrLANG H4
instance AdmitAttrLANG H5
instance AdmitAttrLANG H6
instance AdmitAttrLANG HEAD
instance AdmitAttrLANG HR
instance AdmitAttrLANG HTML
instance AdmitAttrLANG I
instance AdmitAttrLANG IMG
instance AdmitAttrLANG INPUT
instance AdmitAttrLANG INS
instance AdmitAttrLANG ISINDEX
instance AdmitAttrLANG KBD
instance AdmitAttrLANG LABEL
instance AdmitAttrLANG LEGEND
instance AdmitAttrLANG LI
instance AdmitAttrLANG LINK
instance AdmitAttrLANG MAP
instance AdmitAttrLANG MENU
instance AdmitAttrLANG META
instance AdmitAttrLANG NOFRAMES
instance AdmitAttrLANG NOSCRIPT
instance AdmitAttrLANG OBJECT
instance AdmitAttrLANG OL
instance AdmitAttrLANG OPTGROUP
instance AdmitAttrLANG OPTION
instance AdmitAttrLANG P
instance AdmitAttrLANG PRE
instance AdmitAttrLANG Q
instance AdmitAttrLANG S
instance AdmitAttrLANG SAMP
instance AdmitAttrLANG SELECT
instance AdmitAttrLANG SMALL
instance AdmitAttrLANG SPAN
instance AdmitAttrLANG STRIKE
instance AdmitAttrLANG STRONG
instance AdmitAttrLANG STYLE
instance AdmitAttrLANG SUB
instance AdmitAttrLANG SUP
instance AdmitAttrLANG TABLE
instance AdmitAttrLANG TBODY
instance AdmitAttrLANG TD
instance AdmitAttrLANG TEXTAREA
instance AdmitAttrLANG TFOOT
instance AdmitAttrLANG TH
instance AdmitAttrLANG THEAD
instance AdmitAttrLANG TITLE
instance AdmitAttrLANG TR
instance AdmitAttrLANG TT
instance AdmitAttrLANG U
instance AdmitAttrLANG UL
instance AdmitAttrLANG VAR
instance AdmitAttrLANGUAGE SCRIPT
instance AdmitAttrLINK BODY
instance AdmitAttrLONGDESC FRAME
instance AdmitAttrLONGDESC IFRAME
instance AdmitAttrLONGDESC IMG
instance AdmitAttrMARGINHEIGHT FRAME
instance AdmitAttrMARGINHEIGHT IFRAME
instance AdmitAttrMARGINWIDTH FRAME
instance AdmitAttrMARGINWIDTH IFRAME
instance AdmitAttrMAXLENGTH INPUT
instance AdmitAttrMEDIA LINK
instance AdmitAttrMEDIA STYLE
instance AdmitAttrMETHOD FORM
instance AdmitAttrMULTIPLE SELECT
instance AdmitAttrNAME A
instance AdmitAttrNAME APPLET
instance AdmitAttrNAME BUTTON
instance AdmitAttrNAME FORM
instance AdmitAttrNAME FRAME
instance AdmitAttrNAME IFRAME
instance AdmitAttrNAME IMG
instance AdmitAttrNAME INPUT
instance AdmitAttrNAME MAP
instance AdmitAttrNAME META
instance AdmitAttrNAME OBJECT
instance AdmitAttrNAME PARAM
instance AdmitAttrNAME SELECT
instance AdmitAttrNAME TEXTAREA
instance AdmitAttrNOHREF AREA
instance AdmitAttrNORESIZE FRAME
instance AdmitAttrNOSHADE HR
instance AdmitAttrNOWRAP TD
instance AdmitAttrNOWRAP TH
instance AdmitAttrOBJECT APPLET
instance AdmitAttrONBLUR A
instance AdmitAttrONBLUR AREA
instance AdmitAttrONBLUR BUTTON
instance AdmitAttrONBLUR INPUT
instance AdmitAttrONBLUR LABEL
instance AdmitAttrONBLUR SELECT
instance AdmitAttrONBLUR TEXTAREA
instance AdmitAttrONCHANGE INPUT
instance AdmitAttrONCHANGE SELECT
instance AdmitAttrONCHANGE TEXTAREA
instance AdmitAttrONCLICK A
instance AdmitAttrONCLICK ABBR
instance AdmitAttrONCLICK ACRONYM
instance AdmitAttrONCLICK ADDRESS
instance AdmitAttrONCLICK AREA
instance AdmitAttrONCLICK B
instance AdmitAttrONCLICK BIG
instance AdmitAttrONCLICK BLOCKQUOTE
instance AdmitAttrONCLICK BODY
instance AdmitAttrONCLICK BUTTON
instance AdmitAttrONCLICK CAPTION
instance AdmitAttrONCLICK CENTER
instance AdmitAttrONCLICK CITE
instance AdmitAttrONCLICK CODE
instance AdmitAttrONCLICK COL
instance AdmitAttrONCLICK COLGROUP
instance AdmitAttrONCLICK DD
instance AdmitAttrONCLICK DEL
instance AdmitAttrONCLICK DFN
instance AdmitAttrONCLICK DIR
instance AdmitAttrONCLICK DIV
instance AdmitAttrONCLICK DL
instance AdmitAttrONCLICK DT
instance AdmitAttrONCLICK EM
instance AdmitAttrONCLICK FIELDSET
instance AdmitAttrONCLICK FORM
instance AdmitAttrONCLICK H1
instance AdmitAttrONCLICK H2
instance AdmitAttrONCLICK H3
instance AdmitAttrONCLICK H4
instance AdmitAttrONCLICK H5
instance AdmitAttrONCLICK H6
instance AdmitAttrONCLICK HR
instance AdmitAttrONCLICK I
instance AdmitAttrONCLICK IMG
instance AdmitAttrONCLICK INPUT
instance AdmitAttrONCLICK INS
instance AdmitAttrONCLICK KBD
instance AdmitAttrONCLICK LABEL
instance AdmitAttrONCLICK LEGEND
instance AdmitAttrONCLICK LI
instance AdmitAttrONCLICK LINK
instance AdmitAttrONCLICK MAP
instance AdmitAttrONCLICK MENU
instance AdmitAttrONCLICK NOFRAMES
instance AdmitAttrONCLICK NOSCRIPT
instance AdmitAttrONCLICK OBJECT
instance AdmitAttrONCLICK OL
instance AdmitAttrONCLICK OPTGROUP
instance AdmitAttrONCLICK OPTION
instance AdmitAttrONCLICK P
instance AdmitAttrONCLICK PRE
instance AdmitAttrONCLICK Q
instance AdmitAttrONCLICK S
instance AdmitAttrONCLICK SAMP
instance AdmitAttrONCLICK SELECT
instance AdmitAttrONCLICK SMALL
instance AdmitAttrONCLICK SPAN
instance AdmitAttrONCLICK STRIKE
instance AdmitAttrONCLICK STRONG
instance AdmitAttrONCLICK SUB
instance AdmitAttrONCLICK SUP
instance AdmitAttrONCLICK TABLE
instance AdmitAttrONCLICK TBODY
instance AdmitAttrONCLICK TD
instance AdmitAttrONCLICK TEXTAREA
instance AdmitAttrONCLICK TFOOT
instance AdmitAttrONCLICK TH
instance AdmitAttrONCLICK THEAD
instance AdmitAttrONCLICK TR
instance AdmitAttrONCLICK TT
instance AdmitAttrONCLICK U
instance AdmitAttrONCLICK UL
instance AdmitAttrONCLICK VAR
instance AdmitAttrONDBLCLICK A
instance AdmitAttrONDBLCLICK ABBR
instance AdmitAttrONDBLCLICK ACRONYM
instance AdmitAttrONDBLCLICK ADDRESS
instance AdmitAttrONDBLCLICK AREA
instance AdmitAttrONDBLCLICK B
instance AdmitAttrONDBLCLICK BIG
instance AdmitAttrONDBLCLICK BLOCKQUOTE
instance AdmitAttrONDBLCLICK BODY
instance AdmitAttrONDBLCLICK BUTTON
instance AdmitAttrONDBLCLICK CAPTION
instance AdmitAttrONDBLCLICK CENTER
instance AdmitAttrONDBLCLICK CITE
instance AdmitAttrONDBLCLICK CODE
instance AdmitAttrONDBLCLICK COL
instance AdmitAttrONDBLCLICK COLGROUP
instance AdmitAttrONDBLCLICK DD
instance AdmitAttrONDBLCLICK DEL
instance AdmitAttrONDBLCLICK DFN
instance AdmitAttrONDBLCLICK DIR
instance AdmitAttrONDBLCLICK DIV
instance AdmitAttrONDBLCLICK DL
instance AdmitAttrONDBLCLICK DT
instance AdmitAttrONDBLCLICK EM
instance AdmitAttrONDBLCLICK FIELDSET
instance AdmitAttrONDBLCLICK FORM
instance AdmitAttrONDBLCLICK H1
instance AdmitAttrONDBLCLICK H2
instance AdmitAttrONDBLCLICK H3
instance AdmitAttrONDBLCLICK H4
instance AdmitAttrONDBLCLICK H5
instance AdmitAttrONDBLCLICK H6
instance AdmitAttrONDBLCLICK HR
instance AdmitAttrONDBLCLICK I
instance AdmitAttrONDBLCLICK IMG
instance AdmitAttrONDBLCLICK INPUT
instance AdmitAttrONDBLCLICK INS
instance AdmitAttrONDBLCLICK KBD
instance AdmitAttrONDBLCLICK LABEL
instance AdmitAttrONDBLCLICK LEGEND
instance AdmitAttrONDBLCLICK LI
instance AdmitAttrONDBLCLICK LINK
instance AdmitAttrONDBLCLICK MAP
instance AdmitAttrONDBLCLICK MENU
instance AdmitAttrONDBLCLICK NOFRAMES
instance AdmitAttrONDBLCLICK NOSCRIPT
instance AdmitAttrONDBLCLICK OBJECT
instance AdmitAttrONDBLCLICK OL
instance AdmitAttrONDBLCLICK OPTGROUP
instance AdmitAttrONDBLCLICK OPTION
instance AdmitAttrONDBLCLICK P
instance AdmitAttrONDBLCLICK PRE
instance AdmitAttrONDBLCLICK Q
instance AdmitAttrONDBLCLICK S
instance AdmitAttrONDBLCLICK SAMP
instance AdmitAttrONDBLCLICK SELECT
instance AdmitAttrONDBLCLICK SMALL
instance AdmitAttrONDBLCLICK SPAN
instance AdmitAttrONDBLCLICK STRIKE
instance AdmitAttrONDBLCLICK STRONG
instance AdmitAttrONDBLCLICK SUB
instance AdmitAttrONDBLCLICK SUP
instance AdmitAttrONDBLCLICK TABLE
instance AdmitAttrONDBLCLICK TBODY
instance AdmitAttrONDBLCLICK TD
instance AdmitAttrONDBLCLICK TEXTAREA
instance AdmitAttrONDBLCLICK TFOOT
instance AdmitAttrONDBLCLICK TH
instance AdmitAttrONDBLCLICK THEAD
instance AdmitAttrONDBLCLICK TR
instance AdmitAttrONDBLCLICK TT
instance AdmitAttrONDBLCLICK U
instance AdmitAttrONDBLCLICK UL
instance AdmitAttrONDBLCLICK VAR
instance AdmitAttrONFOCUS A
instance AdmitAttrONFOCUS AREA
instance AdmitAttrONFOCUS BUTTON
instance AdmitAttrONFOCUS INPUT
instance AdmitAttrONFOCUS LABEL
instance AdmitAttrONFOCUS SELECT
instance AdmitAttrONFOCUS TEXTAREA
instance AdmitAttrONKEYDOWN A
instance AdmitAttrONKEYDOWN ABBR
instance AdmitAttrONKEYDOWN ACRONYM
instance AdmitAttrONKEYDOWN ADDRESS
instance AdmitAttrONKEYDOWN AREA
instance AdmitAttrONKEYDOWN B
instance AdmitAttrONKEYDOWN BIG
instance AdmitAttrONKEYDOWN BLOCKQUOTE
instance AdmitAttrONKEYDOWN BODY
instance AdmitAttrONKEYDOWN BUTTON
instance AdmitAttrONKEYDOWN CAPTION
instance AdmitAttrONKEYDOWN CENTER
instance AdmitAttrONKEYDOWN CITE
instance AdmitAttrONKEYDOWN CODE
instance AdmitAttrONKEYDOWN COL
instance AdmitAttrONKEYDOWN COLGROUP
instance AdmitAttrONKEYDOWN DD
instance AdmitAttrONKEYDOWN DEL
instance AdmitAttrONKEYDOWN DFN
instance AdmitAttrONKEYDOWN DIR
instance AdmitAttrONKEYDOWN DIV
instance AdmitAttrONKEYDOWN DL
instance AdmitAttrONKEYDOWN DT
instance AdmitAttrONKEYDOWN EM
instance AdmitAttrONKEYDOWN FIELDSET
instance AdmitAttrONKEYDOWN FORM
instance AdmitAttrONKEYDOWN H1
instance AdmitAttrONKEYDOWN H2
instance AdmitAttrONKEYDOWN H3
instance AdmitAttrONKEYDOWN H4
instance AdmitAttrONKEYDOWN H5
instance AdmitAttrONKEYDOWN H6
instance AdmitAttrONKEYDOWN HR
instance AdmitAttrONKEYDOWN I
instance AdmitAttrONKEYDOWN IMG
instance AdmitAttrONKEYDOWN INPUT
instance AdmitAttrONKEYDOWN INS
instance AdmitAttrONKEYDOWN KBD
instance AdmitAttrONKEYDOWN LABEL
instance AdmitAttrONKEYDOWN LEGEND
instance AdmitAttrONKEYDOWN LI
instance AdmitAttrONKEYDOWN LINK
instance AdmitAttrONKEYDOWN MAP
instance AdmitAttrONKEYDOWN MENU
instance AdmitAttrONKEYDOWN NOFRAMES
instance AdmitAttrONKEYDOWN NOSCRIPT
instance AdmitAttrONKEYDOWN OBJECT
instance AdmitAttrONKEYDOWN OL
instance AdmitAttrONKEYDOWN OPTGROUP
instance AdmitAttrONKEYDOWN OPTION
instance AdmitAttrONKEYDOWN P
instance AdmitAttrONKEYDOWN PRE
instance AdmitAttrONKEYDOWN Q
instance AdmitAttrONKEYDOWN S
instance AdmitAttrONKEYDOWN SAMP
instance AdmitAttrONKEYDOWN SELECT
instance AdmitAttrONKEYDOWN SMALL
instance AdmitAttrONKEYDOWN SPAN
instance AdmitAttrONKEYDOWN STRIKE
instance AdmitAttrONKEYDOWN STRONG
instance AdmitAttrONKEYDOWN SUB
instance AdmitAttrONKEYDOWN SUP
instance AdmitAttrONKEYDOWN TABLE
instance AdmitAttrONKEYDOWN TBODY
instance AdmitAttrONKEYDOWN TD
instance AdmitAttrONKEYDOWN TEXTAREA
instance AdmitAttrONKEYDOWN TFOOT
instance AdmitAttrONKEYDOWN TH
instance AdmitAttrONKEYDOWN THEAD
instance AdmitAttrONKEYDOWN TR
instance AdmitAttrONKEYDOWN TT
instance AdmitAttrONKEYDOWN U
instance AdmitAttrONKEYDOWN UL
instance AdmitAttrONKEYDOWN VAR
instance AdmitAttrONKEYPRESS A
instance AdmitAttrONKEYPRESS ABBR
instance AdmitAttrONKEYPRESS ACRONYM
instance AdmitAttrONKEYPRESS ADDRESS
instance AdmitAttrONKEYPRESS AREA
instance AdmitAttrONKEYPRESS B
instance AdmitAttrONKEYPRESS BIG
instance AdmitAttrONKEYPRESS BLOCKQUOTE
instance AdmitAttrONKEYPRESS BODY
instance AdmitAttrONKEYPRESS BUTTON
instance AdmitAttrONKEYPRESS CAPTION
instance AdmitAttrONKEYPRESS CENTER
instance AdmitAttrONKEYPRESS CITE
instance AdmitAttrONKEYPRESS CODE
instance AdmitAttrONKEYPRESS COL
instance AdmitAttrONKEYPRESS COLGROUP
instance AdmitAttrONKEYPRESS DD
instance AdmitAttrONKEYPRESS DEL
instance AdmitAttrONKEYPRESS DFN
instance AdmitAttrONKEYPRESS DIR
instance AdmitAttrONKEYPRESS DIV
instance AdmitAttrONKEYPRESS DL
instance AdmitAttrONKEYPRESS DT
instance AdmitAttrONKEYPRESS EM
instance AdmitAttrONKEYPRESS FIELDSET
instance AdmitAttrONKEYPRESS FORM
instance AdmitAttrONKEYPRESS H1
instance AdmitAttrONKEYPRESS H2
instance AdmitAttrONKEYPRESS H3
instance AdmitAttrONKEYPRESS H4
instance AdmitAttrONKEYPRESS H5
instance AdmitAttrONKEYPRESS H6
instance AdmitAttrONKEYPRESS HR
instance AdmitAttrONKEYPRESS I
instance AdmitAttrONKEYPRESS IMG
instance AdmitAttrONKEYPRESS INPUT
instance AdmitAttrONKEYPRESS INS
instance AdmitAttrONKEYPRESS KBD
instance AdmitAttrONKEYPRESS LABEL
instance AdmitAttrONKEYPRESS LEGEND
instance AdmitAttrONKEYPRESS LI
instance AdmitAttrONKEYPRESS LINK
instance AdmitAttrONKEYPRESS MAP
instance AdmitAttrONKEYPRESS MENU
instance AdmitAttrONKEYPRESS NOFRAMES
instance AdmitAttrONKEYPRESS NOSCRIPT
instance AdmitAttrONKEYPRESS OBJECT
instance AdmitAttrONKEYPRESS OL
instance AdmitAttrONKEYPRESS OPTGROUP
instance AdmitAttrONKEYPRESS OPTION
instance AdmitAttrONKEYPRESS P
instance AdmitAttrONKEYPRESS PRE
instance AdmitAttrONKEYPRESS Q
instance AdmitAttrONKEYPRESS S
instance AdmitAttrONKEYPRESS SAMP
instance AdmitAttrONKEYPRESS SELECT
instance AdmitAttrONKEYPRESS SMALL
instance AdmitAttrONKEYPRESS SPAN
instance AdmitAttrONKEYPRESS STRIKE
instance AdmitAttrONKEYPRESS STRONG
instance AdmitAttrONKEYPRESS SUB
instance AdmitAttrONKEYPRESS SUP
instance AdmitAttrONKEYPRESS TABLE
instance AdmitAttrONKEYPRESS TBODY
instance AdmitAttrONKEYPRESS TD
instance AdmitAttrONKEYPRESS TEXTAREA
instance AdmitAttrONKEYPRESS TFOOT
instance AdmitAttrONKEYPRESS TH
instance AdmitAttrONKEYPRESS THEAD
instance AdmitAttrONKEYPRESS TR
instance AdmitAttrONKEYPRESS TT
instance AdmitAttrONKEYPRESS U
instance AdmitAttrONKEYPRESS UL
instance AdmitAttrONKEYPRESS VAR
instance AdmitAttrONKEYUP A
instance AdmitAttrONKEYUP ABBR
instance AdmitAttrONKEYUP ACRONYM
instance AdmitAttrONKEYUP ADDRESS
instance AdmitAttrONKEYUP AREA
instance AdmitAttrONKEYUP B
instance AdmitAttrONKEYUP BIG
instance AdmitAttrONKEYUP BLOCKQUOTE
instance AdmitAttrONKEYUP BODY
instance AdmitAttrONKEYUP BUTTON
instance AdmitAttrONKEYUP CAPTION
instance AdmitAttrONKEYUP CENTER
instance AdmitAttrONKEYUP CITE
instance AdmitAttrONKEYUP CODE
instance AdmitAttrONKEYUP COL
instance AdmitAttrONKEYUP COLGROUP
instance AdmitAttrONKEYUP DD
instance AdmitAttrONKEYUP DEL
instance AdmitAttrONKEYUP DFN
instance AdmitAttrONKEYUP DIR
instance AdmitAttrONKEYUP DIV
instance AdmitAttrONKEYUP DL
instance AdmitAttrONKEYUP DT
instance AdmitAttrONKEYUP EM
instance AdmitAttrONKEYUP FIELDSET
instance AdmitAttrONKEYUP FORM
instance AdmitAttrONKEYUP H1
instance AdmitAttrONKEYUP H2
instance AdmitAttrONKEYUP H3
instance AdmitAttrONKEYUP H4
instance AdmitAttrONKEYUP H5
instance AdmitAttrONKEYUP H6
instance AdmitAttrONKEYUP HR
instance AdmitAttrONKEYUP I
instance AdmitAttrONKEYUP IMG
instance AdmitAttrONKEYUP INPUT
instance AdmitAttrONKEYUP INS
instance AdmitAttrONKEYUP KBD
instance AdmitAttrONKEYUP LABEL
instance AdmitAttrONKEYUP LEGEND
instance AdmitAttrONKEYUP LI
instance AdmitAttrONKEYUP LINK
instance AdmitAttrONKEYUP MAP
instance AdmitAttrONKEYUP MENU
instance AdmitAttrONKEYUP NOFRAMES
instance AdmitAttrONKEYUP NOSCRIPT
instance AdmitAttrONKEYUP OBJECT
instance AdmitAttrONKEYUP OL
instance AdmitAttrONKEYUP OPTGROUP
instance AdmitAttrONKEYUP OPTION
instance AdmitAttrONKEYUP P
instance AdmitAttrONKEYUP PRE
instance AdmitAttrONKEYUP Q
instance AdmitAttrONKEYUP S
instance AdmitAttrONKEYUP SAMP
instance AdmitAttrONKEYUP SELECT
instance AdmitAttrONKEYUP SMALL
instance AdmitAttrONKEYUP SPAN
instance AdmitAttrONKEYUP STRIKE
instance AdmitAttrONKEYUP STRONG
instance AdmitAttrONKEYUP SUB
instance AdmitAttrONKEYUP SUP
instance AdmitAttrONKEYUP TABLE
instance AdmitAttrONKEYUP TBODY
instance AdmitAttrONKEYUP TD
instance AdmitAttrONKEYUP TEXTAREA
instance AdmitAttrONKEYUP TFOOT
instance AdmitAttrONKEYUP TH
instance AdmitAttrONKEYUP THEAD
instance AdmitAttrONKEYUP TR
instance AdmitAttrONKEYUP TT
instance AdmitAttrONKEYUP U
instance AdmitAttrONKEYUP UL
instance AdmitAttrONKEYUP VAR
instance AdmitAttrONLOAD BODY
instance AdmitAttrONLOAD FRAMESET
instance AdmitAttrONMOUSEDOWN A
instance AdmitAttrONMOUSEDOWN ABBR
instance AdmitAttrONMOUSEDOWN ACRONYM
instance AdmitAttrONMOUSEDOWN ADDRESS
instance AdmitAttrONMOUSEDOWN AREA
instance AdmitAttrONMOUSEDOWN B
instance AdmitAttrONMOUSEDOWN BIG
instance AdmitAttrONMOUSEDOWN BLOCKQUOTE
instance AdmitAttrONMOUSEDOWN BODY
instance AdmitAttrONMOUSEDOWN BUTTON
instance AdmitAttrONMOUSEDOWN CAPTION
instance AdmitAttrONMOUSEDOWN CENTER
instance AdmitAttrONMOUSEDOWN CITE
instance AdmitAttrONMOUSEDOWN CODE
instance AdmitAttrONMOUSEDOWN COL
instance AdmitAttrONMOUSEDOWN COLGROUP
instance AdmitAttrONMOUSEDOWN DD
instance AdmitAttrONMOUSEDOWN DEL
instance AdmitAttrONMOUSEDOWN DFN
instance AdmitAttrONMOUSEDOWN DIR
instance AdmitAttrONMOUSEDOWN DIV
instance AdmitAttrONMOUSEDOWN DL
instance AdmitAttrONMOUSEDOWN DT
instance AdmitAttrONMOUSEDOWN EM
instance AdmitAttrONMOUSEDOWN FIELDSET
instance AdmitAttrONMOUSEDOWN FORM
instance AdmitAttrONMOUSEDOWN H1
instance AdmitAttrONMOUSEDOWN H2
instance AdmitAttrONMOUSEDOWN H3
instance AdmitAttrONMOUSEDOWN H4
instance AdmitAttrONMOUSEDOWN H5
instance AdmitAttrONMOUSEDOWN H6
instance AdmitAttrONMOUSEDOWN HR
instance AdmitAttrONMOUSEDOWN I
instance AdmitAttrONMOUSEDOWN IMG
instance AdmitAttrONMOUSEDOWN INPUT
instance AdmitAttrONMOUSEDOWN INS
instance AdmitAttrONMOUSEDOWN KBD
instance AdmitAttrONMOUSEDOWN LABEL
instance AdmitAttrONMOUSEDOWN LEGEND
instance AdmitAttrONMOUSEDOWN LI
instance AdmitAttrONMOUSEDOWN LINK
instance AdmitAttrONMOUSEDOWN MAP
instance AdmitAttrONMOUSEDOWN MENU
instance AdmitAttrONMOUSEDOWN NOFRAMES
instance AdmitAttrONMOUSEDOWN NOSCRIPT
instance AdmitAttrONMOUSEDOWN OBJECT
instance AdmitAttrONMOUSEDOWN OL
instance AdmitAttrONMOUSEDOWN OPTGROUP
instance AdmitAttrONMOUSEDOWN OPTION
instance AdmitAttrONMOUSEDOWN P
instance AdmitAttrONMOUSEDOWN PRE
instance AdmitAttrONMOUSEDOWN Q
instance AdmitAttrONMOUSEDOWN S
instance AdmitAttrONMOUSEDOWN SAMP
instance AdmitAttrONMOUSEDOWN SELECT
instance AdmitAttrONMOUSEDOWN SMALL
instance AdmitAttrONMOUSEDOWN SPAN
instance AdmitAttrONMOUSEDOWN STRIKE
instance AdmitAttrONMOUSEDOWN STRONG
instance AdmitAttrONMOUSEDOWN SUB
instance AdmitAttrONMOUSEDOWN SUP
instance AdmitAttrONMOUSEDOWN TABLE
instance AdmitAttrONMOUSEDOWN TBODY
instance AdmitAttrONMOUSEDOWN TD
instance AdmitAttrONMOUSEDOWN TEXTAREA
instance AdmitAttrONMOUSEDOWN TFOOT
instance AdmitAttrONMOUSEDOWN TH
instance AdmitAttrONMOUSEDOWN THEAD
instance AdmitAttrONMOUSEDOWN TR
instance AdmitAttrONMOUSEDOWN TT
instance AdmitAttrONMOUSEDOWN U
instance AdmitAttrONMOUSEDOWN UL
instance AdmitAttrONMOUSEDOWN VAR
instance AdmitAttrONMOUSEMOVE A
instance AdmitAttrONMOUSEMOVE ABBR
instance AdmitAttrONMOUSEMOVE ACRONYM
instance AdmitAttrONMOUSEMOVE ADDRESS
instance AdmitAttrONMOUSEMOVE AREA
instance AdmitAttrONMOUSEMOVE B
instance AdmitAttrONMOUSEMOVE BIG
instance AdmitAttrONMOUSEMOVE BLOCKQUOTE
instance AdmitAttrONMOUSEMOVE BODY
instance AdmitAttrONMOUSEMOVE BUTTON
instance AdmitAttrONMOUSEMOVE CAPTION
instance AdmitAttrONMOUSEMOVE CENTER
instance AdmitAttrONMOUSEMOVE CITE
instance AdmitAttrONMOUSEMOVE CODE
instance AdmitAttrONMOUSEMOVE COL
instance AdmitAttrONMOUSEMOVE COLGROUP
instance AdmitAttrONMOUSEMOVE DD
instance AdmitAttrONMOUSEMOVE DEL
instance AdmitAttrONMOUSEMOVE DFN
instance AdmitAttrONMOUSEMOVE DIR
instance AdmitAttrONMOUSEMOVE DIV
instance AdmitAttrONMOUSEMOVE DL
instance AdmitAttrONMOUSEMOVE DT
instance AdmitAttrONMOUSEMOVE EM
instance AdmitAttrONMOUSEMOVE FIELDSET
instance AdmitAttrONMOUSEMOVE FORM
instance AdmitAttrONMOUSEMOVE H1
instance AdmitAttrONMOUSEMOVE H2
instance AdmitAttrONMOUSEMOVE H3
instance AdmitAttrONMOUSEMOVE H4
instance AdmitAttrONMOUSEMOVE H5
instance AdmitAttrONMOUSEMOVE H6
instance AdmitAttrONMOUSEMOVE HR
instance AdmitAttrONMOUSEMOVE I
instance AdmitAttrONMOUSEMOVE IMG
instance AdmitAttrONMOUSEMOVE INPUT
instance AdmitAttrONMOUSEMOVE INS
instance AdmitAttrONMOUSEMOVE KBD
instance AdmitAttrONMOUSEMOVE LABEL
instance AdmitAttrONMOUSEMOVE LEGEND
instance AdmitAttrONMOUSEMOVE LI
instance AdmitAttrONMOUSEMOVE LINK
instance AdmitAttrONMOUSEMOVE MAP
instance AdmitAttrONMOUSEMOVE MENU
instance AdmitAttrONMOUSEMOVE NOFRAMES
instance AdmitAttrONMOUSEMOVE NOSCRIPT
instance AdmitAttrONMOUSEMOVE OBJECT
instance AdmitAttrONMOUSEMOVE OL
instance AdmitAttrONMOUSEMOVE OPTGROUP
instance AdmitAttrONMOUSEMOVE OPTION
instance AdmitAttrONMOUSEMOVE P
instance AdmitAttrONMOUSEMOVE PRE
instance AdmitAttrONMOUSEMOVE Q
instance AdmitAttrONMOUSEMOVE S
instance AdmitAttrONMOUSEMOVE SAMP
instance AdmitAttrONMOUSEMOVE SELECT
instance AdmitAttrONMOUSEMOVE SMALL
instance AdmitAttrONMOUSEMOVE SPAN
instance AdmitAttrONMOUSEMOVE STRIKE
instance AdmitAttrONMOUSEMOVE STRONG
instance AdmitAttrONMOUSEMOVE SUB
instance AdmitAttrONMOUSEMOVE SUP
instance AdmitAttrONMOUSEMOVE TABLE
instance AdmitAttrONMOUSEMOVE TBODY
instance AdmitAttrONMOUSEMOVE TD
instance AdmitAttrONMOUSEMOVE TEXTAREA
instance AdmitAttrONMOUSEMOVE TFOOT
instance AdmitAttrONMOUSEMOVE TH
instance AdmitAttrONMOUSEMOVE THEAD
instance AdmitAttrONMOUSEMOVE TR
instance AdmitAttrONMOUSEMOVE TT
instance AdmitAttrONMOUSEMOVE U
instance AdmitAttrONMOUSEMOVE UL
instance AdmitAttrONMOUSEMOVE VAR
instance AdmitAttrONMOUSEOUT A
instance AdmitAttrONMOUSEOUT ABBR
instance AdmitAttrONMOUSEOUT ACRONYM
instance AdmitAttrONMOUSEOUT ADDRESS
instance AdmitAttrONMOUSEOUT AREA
instance AdmitAttrONMOUSEOUT B
instance AdmitAttrONMOUSEOUT BIG
instance AdmitAttrONMOUSEOUT BLOCKQUOTE
instance AdmitAttrONMOUSEOUT BODY
instance AdmitAttrONMOUSEOUT BUTTON
instance AdmitAttrONMOUSEOUT CAPTION
instance AdmitAttrONMOUSEOUT CENTER
instance AdmitAttrONMOUSEOUT CITE
instance AdmitAttrONMOUSEOUT CODE
instance AdmitAttrONMOUSEOUT COL
instance AdmitAttrONMOUSEOUT COLGROUP
instance AdmitAttrONMOUSEOUT DD
instance AdmitAttrONMOUSEOUT DEL
instance AdmitAttrONMOUSEOUT DFN
instance AdmitAttrONMOUSEOUT DIR
instance AdmitAttrONMOUSEOUT DIV
instance AdmitAttrONMOUSEOUT DL
instance AdmitAttrONMOUSEOUT DT
instance AdmitAttrONMOUSEOUT EM
instance AdmitAttrONMOUSEOUT FIELDSET
instance AdmitAttrONMOUSEOUT FORM
instance AdmitAttrONMOUSEOUT H1
instance AdmitAttrONMOUSEOUT H2
instance AdmitAttrONMOUSEOUT H3
instance AdmitAttrONMOUSEOUT H4
instance AdmitAttrONMOUSEOUT H5
instance AdmitAttrONMOUSEOUT H6
instance AdmitAttrONMOUSEOUT HR
instance AdmitAttrONMOUSEOUT I
instance AdmitAttrONMOUSEOUT IMG
instance AdmitAttrONMOUSEOUT INPUT
instance AdmitAttrONMOUSEOUT INS
instance AdmitAttrONMOUSEOUT KBD
instance AdmitAttrONMOUSEOUT LABEL
instance AdmitAttrONMOUSEOUT LEGEND
instance AdmitAttrONMOUSEOUT LI
instance AdmitAttrONMOUSEOUT LINK
instance AdmitAttrONMOUSEOUT MAP
instance AdmitAttrONMOUSEOUT MENU
instance AdmitAttrONMOUSEOUT NOFRAMES
instance AdmitAttrONMOUSEOUT NOSCRIPT
instance AdmitAttrONMOUSEOUT OBJECT
instance AdmitAttrONMOUSEOUT OL
instance AdmitAttrONMOUSEOUT OPTGROUP
instance AdmitAttrONMOUSEOUT OPTION
instance AdmitAttrONMOUSEOUT P
instance AdmitAttrONMOUSEOUT PRE
instance AdmitAttrONMOUSEOUT Q
instance AdmitAttrONMOUSEOUT S
instance AdmitAttrONMOUSEOUT SAMP
instance AdmitAttrONMOUSEOUT SELECT
instance AdmitAttrONMOUSEOUT SMALL
instance AdmitAttrONMOUSEOUT SPAN
instance AdmitAttrONMOUSEOUT STRIKE
instance AdmitAttrONMOUSEOUT STRONG
instance AdmitAttrONMOUSEOUT SUB
instance AdmitAttrONMOUSEOUT SUP
instance AdmitAttrONMOUSEOUT TABLE
instance AdmitAttrONMOUSEOUT TBODY
instance AdmitAttrONMOUSEOUT TD
instance AdmitAttrONMOUSEOUT TEXTAREA
instance AdmitAttrONMOUSEOUT TFOOT
instance AdmitAttrONMOUSEOUT TH
instance AdmitAttrONMOUSEOUT THEAD
instance AdmitAttrONMOUSEOUT TR
instance AdmitAttrONMOUSEOUT TT
instance AdmitAttrONMOUSEOUT U
instance AdmitAttrONMOUSEOUT UL
instance AdmitAttrONMOUSEOUT VAR
instance AdmitAttrONMOUSEOVER A
instance AdmitAttrONMOUSEOVER ABBR
instance AdmitAttrONMOUSEOVER ACRONYM
instance AdmitAttrONMOUSEOVER ADDRESS
instance AdmitAttrONMOUSEOVER AREA
instance AdmitAttrONMOUSEOVER B
instance AdmitAttrONMOUSEOVER BIG
instance AdmitAttrONMOUSEOVER BLOCKQUOTE
instance AdmitAttrONMOUSEOVER BODY
instance AdmitAttrONMOUSEOVER BUTTON
instance AdmitAttrONMOUSEOVER CAPTION
instance AdmitAttrONMOUSEOVER CENTER
instance AdmitAttrONMOUSEOVER CITE
instance AdmitAttrONMOUSEOVER CODE
instance AdmitAttrONMOUSEOVER COL
instance AdmitAttrONMOUSEOVER COLGROUP
instance AdmitAttrONMOUSEOVER DD
instance AdmitAttrONMOUSEOVER DEL
instance AdmitAttrONMOUSEOVER DFN
instance AdmitAttrONMOUSEOVER DIR
instance AdmitAttrONMOUSEOVER DIV
instance AdmitAttrONMOUSEOVER DL
instance AdmitAttrONMOUSEOVER DT
instance AdmitAttrONMOUSEOVER EM
instance AdmitAttrONMOUSEOVER FIELDSET
instance AdmitAttrONMOUSEOVER FORM
instance AdmitAttrONMOUSEOVER H1
instance AdmitAttrONMOUSEOVER H2
instance AdmitAttrONMOUSEOVER H3
instance AdmitAttrONMOUSEOVER H4
instance AdmitAttrONMOUSEOVER H5
instance AdmitAttrONMOUSEOVER H6
instance AdmitAttrONMOUSEOVER HR
instance AdmitAttrONMOUSEOVER I
instance AdmitAttrONMOUSEOVER IMG
instance AdmitAttrONMOUSEOVER INPUT
instance AdmitAttrONMOUSEOVER INS
instance AdmitAttrONMOUSEOVER KBD
instance AdmitAttrONMOUSEOVER LABEL
instance AdmitAttrONMOUSEOVER LEGEND
instance AdmitAttrONMOUSEOVER LI
instance AdmitAttrONMOUSEOVER LINK
instance AdmitAttrONMOUSEOVER MAP
instance AdmitAttrONMOUSEOVER MENU
instance AdmitAttrONMOUSEOVER NOFRAMES
instance AdmitAttrONMOUSEOVER NOSCRIPT
instance AdmitAttrONMOUSEOVER OBJECT
instance AdmitAttrONMOUSEOVER OL
instance AdmitAttrONMOUSEOVER OPTGROUP
instance AdmitAttrONMOUSEOVER OPTION
instance AdmitAttrONMOUSEOVER P
instance AdmitAttrONMOUSEOVER PRE
instance AdmitAttrONMOUSEOVER Q
instance AdmitAttrONMOUSEOVER S
instance AdmitAttrONMOUSEOVER SAMP
instance AdmitAttrONMOUSEOVER SELECT
instance AdmitAttrONMOUSEOVER SMALL
instance AdmitAttrONMOUSEOVER SPAN
instance AdmitAttrONMOUSEOVER STRIKE
instance AdmitAttrONMOUSEOVER STRONG
instance AdmitAttrONMOUSEOVER SUB
instance AdmitAttrONMOUSEOVER SUP
instance AdmitAttrONMOUSEOVER TABLE
instance AdmitAttrONMOUSEOVER TBODY
instance AdmitAttrONMOUSEOVER TD
instance AdmitAttrONMOUSEOVER TEXTAREA
instance AdmitAttrONMOUSEOVER TFOOT
instance AdmitAttrONMOUSEOVER TH
instance AdmitAttrONMOUSEOVER THEAD
instance AdmitAttrONMOUSEOVER TR
instance AdmitAttrONMOUSEOVER TT
instance AdmitAttrONMOUSEOVER U
instance AdmitAttrONMOUSEOVER UL
instance AdmitAttrONMOUSEOVER VAR
instance AdmitAttrONMOUSEUP A
instance AdmitAttrONMOUSEUP ABBR
instance AdmitAttrONMOUSEUP ACRONYM
instance AdmitAttrONMOUSEUP ADDRESS
instance AdmitAttrONMOUSEUP AREA
instance AdmitAttrONMOUSEUP B
instance AdmitAttrONMOUSEUP BIG
instance AdmitAttrONMOUSEUP BLOCKQUOTE
instance AdmitAttrONMOUSEUP BODY
instance AdmitAttrONMOUSEUP BUTTON
instance AdmitAttrONMOUSEUP CAPTION
instance AdmitAttrONMOUSEUP CENTER
instance AdmitAttrONMOUSEUP CITE
instance AdmitAttrONMOUSEUP CODE
instance AdmitAttrONMOUSEUP COL
instance AdmitAttrONMOUSEUP COLGROUP
instance AdmitAttrONMOUSEUP DD
instance AdmitAttrONMOUSEUP DEL
instance AdmitAttrONMOUSEUP DFN
instance AdmitAttrONMOUSEUP DIR
instance AdmitAttrONMOUSEUP DIV
instance AdmitAttrONMOUSEUP DL
instance AdmitAttrONMOUSEUP DT
instance AdmitAttrONMOUSEUP EM
instance AdmitAttrONMOUSEUP FIELDSET
instance AdmitAttrONMOUSEUP FORM
instance AdmitAttrONMOUSEUP H1
instance AdmitAttrONMOUSEUP H2
instance AdmitAttrONMOUSEUP H3
instance AdmitAttrONMOUSEUP H4
instance AdmitAttrONMOUSEUP H5
instance AdmitAttrONMOUSEUP H6
instance AdmitAttrONMOUSEUP HR
instance AdmitAttrONMOUSEUP I
instance AdmitAttrONMOUSEUP IMG
instance AdmitAttrONMOUSEUP INPUT
instance AdmitAttrONMOUSEUP INS
instance AdmitAttrONMOUSEUP KBD
instance AdmitAttrONMOUSEUP LABEL
instance AdmitAttrONMOUSEUP LEGEND
instance AdmitAttrONMOUSEUP LI
instance AdmitAttrONMOUSEUP LINK
instance AdmitAttrONMOUSEUP MAP
instance AdmitAttrONMOUSEUP MENU
instance AdmitAttrONMOUSEUP NOFRAMES
instance AdmitAttrONMOUSEUP NOSCRIPT
instance AdmitAttrONMOUSEUP OBJECT
instance AdmitAttrONMOUSEUP OL
instance AdmitAttrONMOUSEUP OPTGROUP
instance AdmitAttrONMOUSEUP OPTION
instance AdmitAttrONMOUSEUP P
instance AdmitAttrONMOUSEUP PRE
instance AdmitAttrONMOUSEUP Q
instance AdmitAttrONMOUSEUP S
instance AdmitAttrONMOUSEUP SAMP
instance AdmitAttrONMOUSEUP SELECT
instance AdmitAttrONMOUSEUP SMALL
instance AdmitAttrONMOUSEUP SPAN
instance AdmitAttrONMOUSEUP STRIKE
instance AdmitAttrONMOUSEUP STRONG
instance AdmitAttrONMOUSEUP SUB
instance AdmitAttrONMOUSEUP SUP
instance AdmitAttrONMOUSEUP TABLE
instance AdmitAttrONMOUSEUP TBODY
instance AdmitAttrONMOUSEUP TD
instance AdmitAttrONMOUSEUP TEXTAREA
instance AdmitAttrONMOUSEUP TFOOT
instance AdmitAttrONMOUSEUP TH
instance AdmitAttrONMOUSEUP THEAD
instance AdmitAttrONMOUSEUP TR
instance AdmitAttrONMOUSEUP TT
instance AdmitAttrONMOUSEUP U
instance AdmitAttrONMOUSEUP UL
instance AdmitAttrONMOUSEUP VAR
instance AdmitAttrONRESET FORM
instance AdmitAttrONSELECT INPUT
instance AdmitAttrONSELECT TEXTAREA
instance AdmitAttrONSUBMIT FORM
instance AdmitAttrONUNLOAD BODY
instance AdmitAttrONUNLOAD FRAMESET
instance AdmitAttrPROFILE HEAD
instance AdmitAttrPROMPT ISINDEX
instance AdmitAttrREADONLY INPUT
instance AdmitAttrREADONLY TEXTAREA
instance AdmitAttrREL A
instance AdmitAttrREL LINK
instance AdmitAttrREV A
instance AdmitAttrREV LINK
instance AdmitAttrROWS FRAMESET
instance AdmitAttrROWS TEXTAREA
instance AdmitAttrROWSPAN TD
instance AdmitAttrROWSPAN TH
instance AdmitAttrRULES TABLE
instance AdmitAttrSCHEME META
instance AdmitAttrSCOPE TD
instance AdmitAttrSCOPE TH
instance AdmitAttrSCROLLING FRAME
instance AdmitAttrSCROLLING IFRAME
instance AdmitAttrSELECTED OPTION
instance AdmitAttrSHAPE A
instance AdmitAttrSHAPE AREA
instance AdmitAttrSIZE BASEFONT
instance AdmitAttrSIZE FONT
instance AdmitAttrSIZE HR
instance AdmitAttrSIZE INPUT
instance AdmitAttrSIZE SELECT
instance AdmitAttrSPAN COL
instance AdmitAttrSPAN COLGROUP
instance AdmitAttrSRC FRAME
instance AdmitAttrSRC IFRAME
instance AdmitAttrSRC IMG
instance AdmitAttrSRC INPUT
instance AdmitAttrSRC SCRIPT
instance AdmitAttrSTANDBY OBJECT
instance AdmitAttrSTART OL
instance AdmitAttrSTYLE A
instance AdmitAttrSTYLE ABBR
instance AdmitAttrSTYLE ACRONYM
instance AdmitAttrSTYLE ADDRESS
instance AdmitAttrSTYLE APPLET
instance AdmitAttrSTYLE AREA
instance AdmitAttrSTYLE B
instance AdmitAttrSTYLE BDO
instance AdmitAttrSTYLE BIG
instance AdmitAttrSTYLE BLOCKQUOTE
instance AdmitAttrSTYLE BODY
instance AdmitAttrSTYLE BR
instance AdmitAttrSTYLE BUTTON
instance AdmitAttrSTYLE CAPTION
instance AdmitAttrSTYLE CENTER
instance AdmitAttrSTYLE CITE
instance AdmitAttrSTYLE CODE
instance AdmitAttrSTYLE COL
instance AdmitAttrSTYLE COLGROUP
instance AdmitAttrSTYLE DD
instance AdmitAttrSTYLE DEL
instance AdmitAttrSTYLE DFN
instance AdmitAttrSTYLE DIR
instance AdmitAttrSTYLE DIV
instance AdmitAttrSTYLE DL
instance AdmitAttrSTYLE DT
instance AdmitAttrSTYLE EM
instance AdmitAttrSTYLE FIELDSET
instance AdmitAttrSTYLE FONT
instance AdmitAttrSTYLE FORM
instance AdmitAttrSTYLE FRAME
instance AdmitAttrSTYLE FRAMESET
instance AdmitAttrSTYLE H1
instance AdmitAttrSTYLE H2
instance AdmitAttrSTYLE H3
instance AdmitAttrSTYLE H4
instance AdmitAttrSTYLE H5
instance AdmitAttrSTYLE H6
instance AdmitAttrSTYLE HR
instance AdmitAttrSTYLE I
instance AdmitAttrSTYLE IFRAME
instance AdmitAttrSTYLE IMG
instance AdmitAttrSTYLE INPUT
instance AdmitAttrSTYLE INS
instance AdmitAttrSTYLE ISINDEX
instance AdmitAttrSTYLE KBD
instance AdmitAttrSTYLE LABEL
instance AdmitAttrSTYLE LEGEND
instance AdmitAttrSTYLE LI
instance AdmitAttrSTYLE LINK
instance AdmitAttrSTYLE MAP
instance AdmitAttrSTYLE MENU
instance AdmitAttrSTYLE NOFRAMES
instance AdmitAttrSTYLE NOSCRIPT
instance AdmitAttrSTYLE OBJECT
instance AdmitAttrSTYLE OL
instance AdmitAttrSTYLE OPTGROUP
instance AdmitAttrSTYLE OPTION
instance AdmitAttrSTYLE P
instance AdmitAttrSTYLE PRE
instance AdmitAttrSTYLE Q
instance AdmitAttrSTYLE S
instance AdmitAttrSTYLE SAMP
instance AdmitAttrSTYLE SELECT
instance AdmitAttrSTYLE SMALL
instance AdmitAttrSTYLE SPAN
instance AdmitAttrSTYLE STRIKE
instance AdmitAttrSTYLE STRONG
instance AdmitAttrSTYLE SUB
instance AdmitAttrSTYLE SUP
instance AdmitAttrSTYLE TABLE
instance AdmitAttrSTYLE TBODY
instance AdmitAttrSTYLE TD
instance AdmitAttrSTYLE TEXTAREA
instance AdmitAttrSTYLE TFOOT
instance AdmitAttrSTYLE TH
instance AdmitAttrSTYLE THEAD
instance AdmitAttrSTYLE TR
instance AdmitAttrSTYLE TT
instance AdmitAttrSTYLE U
instance AdmitAttrSTYLE UL
instance AdmitAttrSTYLE VAR
instance AdmitAttrSUMMARY TABLE
instance AdmitAttrTABINDEX A
instance AdmitAttrTABINDEX AREA
instance AdmitAttrTABINDEX BUTTON
instance AdmitAttrTABINDEX INPUT
instance AdmitAttrTABINDEX OBJECT
instance AdmitAttrTABINDEX SELECT
instance AdmitAttrTABINDEX TEXTAREA
instance AdmitAttrTARGET A
instance AdmitAttrTARGET AREA
instance AdmitAttrTARGET BASE
instance AdmitAttrTARGET FORM
instance AdmitAttrTARGET LINK
instance AdmitAttrTEXT BODY
instance AdmitAttrTITLE A
instance AdmitAttrTITLE ABBR
instance AdmitAttrTITLE ACRONYM
instance AdmitAttrTITLE ADDRESS
instance AdmitAttrTITLE APPLET
instance AdmitAttrTITLE AREA
instance AdmitAttrTITLE B
instance AdmitAttrTITLE BDO
instance AdmitAttrTITLE BIG
instance AdmitAttrTITLE BLOCKQUOTE
instance AdmitAttrTITLE BODY
instance AdmitAttrTITLE BR
instance AdmitAttrTITLE BUTTON
instance AdmitAttrTITLE CAPTION
instance AdmitAttrTITLE CENTER
instance AdmitAttrTITLE CITE
instance AdmitAttrTITLE CODE
instance AdmitAttrTITLE COL
instance AdmitAttrTITLE COLGROUP
instance AdmitAttrTITLE DD
instance AdmitAttrTITLE DEL
instance AdmitAttrTITLE DFN
instance AdmitAttrTITLE DIR
instance AdmitAttrTITLE DIV
instance AdmitAttrTITLE DL
instance AdmitAttrTITLE DT
instance AdmitAttrTITLE EM
instance AdmitAttrTITLE FIELDSET
instance AdmitAttrTITLE FONT
instance AdmitAttrTITLE FORM
instance AdmitAttrTITLE FRAME
instance AdmitAttrTITLE FRAMESET
instance AdmitAttrTITLE H1
instance AdmitAttrTITLE H2
instance AdmitAttrTITLE H3
instance AdmitAttrTITLE H4
instance AdmitAttrTITLE H5
instance AdmitAttrTITLE H6
instance AdmitAttrTITLE HR
instance AdmitAttrTITLE I
instance AdmitAttrTITLE IFRAME
instance AdmitAttrTITLE IMG
instance AdmitAttrTITLE INPUT
instance AdmitAttrTITLE INS
instance AdmitAttrTITLE ISINDEX
instance AdmitAttrTITLE KBD
instance AdmitAttrTITLE LABEL
instance AdmitAttrTITLE LEGEND
instance AdmitAttrTITLE LI
instance AdmitAttrTITLE LINK
instance AdmitAttrTITLE MAP
instance AdmitAttrTITLE MENU
instance AdmitAttrTITLE NOFRAMES
instance AdmitAttrTITLE NOSCRIPT
instance AdmitAttrTITLE OBJECT
instance AdmitAttrTITLE OL
instance AdmitAttrTITLE OPTGROUP
instance AdmitAttrTITLE OPTION
instance AdmitAttrTITLE P
instance AdmitAttrTITLE PRE
instance AdmitAttrTITLE Q
instance AdmitAttrTITLE S
instance AdmitAttrTITLE SAMP
instance AdmitAttrTITLE SELECT
instance AdmitAttrTITLE SMALL
instance AdmitAttrTITLE SPAN
instance AdmitAttrTITLE STRIKE
instance AdmitAttrTITLE STRONG
instance AdmitAttrTITLE STYLE
instance AdmitAttrTITLE SUB
instance AdmitAttrTITLE SUP
instance AdmitAttrTITLE TABLE
instance AdmitAttrTITLE TBODY
instance AdmitAttrTITLE TD
instance AdmitAttrTITLE TEXTAREA
instance AdmitAttrTITLE TFOOT
instance AdmitAttrTITLE TH
instance AdmitAttrTITLE THEAD
instance AdmitAttrTITLE TR
instance AdmitAttrTITLE TT
instance AdmitAttrTITLE U
instance AdmitAttrTITLE UL
instance AdmitAttrTITLE VAR
instance AdmitAttrTYPE A
instance AdmitAttrTYPE BUTTON
instance AdmitAttrTYPE INPUT
instance AdmitAttrTYPE LI
instance AdmitAttrTYPE LINK
instance AdmitAttrTYPE OBJECT
instance AdmitAttrTYPE OL
instance AdmitAttrTYPE PARAM
instance AdmitAttrTYPE SCRIPT
instance AdmitAttrTYPE STYLE
instance AdmitAttrTYPE UL
instance AdmitAttrUSEMAP IMG
instance AdmitAttrUSEMAP INPUT
instance AdmitAttrUSEMAP OBJECT
instance AdmitAttrVALIGN COL
instance AdmitAttrVALIGN COLGROUP
instance AdmitAttrVALIGN TBODY
instance AdmitAttrVALIGN TD
instance AdmitAttrVALIGN TFOOT
instance AdmitAttrVALIGN TH
instance AdmitAttrVALIGN THEAD
instance AdmitAttrVALIGN TR
instance AdmitAttrVALUE BUTTON
instance AdmitAttrVALUE INPUT
instance AdmitAttrVALUE LI
instance AdmitAttrVALUE OPTION
instance AdmitAttrVALUE PARAM
instance AdmitAttrVALUETYPE PARAM
instance AdmitAttrVERSION HTML
instance AdmitAttrVLINK BODY
instance AdmitAttrVSPACE APPLET
instance AdmitAttrVSPACE IMG
instance AdmitAttrVSPACE OBJECT
instance AdmitAttrWIDTH APPLET
instance AdmitAttrWIDTH COL
instance AdmitAttrWIDTH COLGROUP
instance AdmitAttrWIDTH HR
instance AdmitAttrWIDTH IFRAME
instance AdmitAttrWIDTH IMG
instance AdmitAttrWIDTH OBJECT
instance AdmitAttrWIDTH PRE
instance AdmitAttrWIDTH TABLE
instance AdmitAttrWIDTH TD
instance AdmitAttrWIDTH TH
