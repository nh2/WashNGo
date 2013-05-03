#
# Makefile for WASH/CGI (Haskell98)
# copyright 2001-2005 by Peter Thiemann
#

PACKAGE=WASH-CGI
VERSION=1.4.38

include $(TOP)/mk/config.mk
include $(TOP)/mk/common.mk

HC_SPEC_FLAGS=	-package-name $(PACKAGE) -package text
HCLOADFLAGS=
HCINCLUDES=	-i$(PATH_TO_UTILITY):$(PATH_TO_WASHMAIL):$(PATH_TO_WASHHTML)
OPT=

HCFLAGS=	$(HCEXTRAFLAGS) $(OPT) $(HC_SPEC_FLAGS) $(HCINCLUDES)

HS_FILES=	$(HS_SOURCES)

PACKAGE_DEPENDENCIES= haskell98 text WASHHTML WASHMail Utility

TMPDIR=/tmp
FULLNAME=$(PACKAGE)-$(VERSION)
FILES= Makefile README INSTALL LICENSE $(HS_SOURCES)
HS_SOURCES= $(MODULES:=.hs)
MODULES= $(EXPOSED_MODULES)$(HIDDEN_MODULES)
HIDDEN_MODULES=
EXPOSED_MODULES= \
	AbstractSelector \
	CGI \
	CGIConfig \
	CGIGraphics \
	CGIInternals \
	CGIMonad \
	CGIOutput \
	CGITypes \
	CGIXX \
	ContentType \
	Cookie \
	CookieIO \
	Debug \
	EventHandlers \
	Fields \
	Frames \
	GuaranteedCGI \
	HTMLMail \
	HTMLWrapper \
	Images \
	PPM \
	Persistent2 \
	RawCGITypes \
	RawCGI \
	RawCGIInternal \
	StateItem \
	Style \
	Submit98 \
	SubmitXX \
	Types

DOCDIR= doc

all: lib$(PACKAGE).a

lib$(PACKAGE).a: lib$(PACKAGE).a($(HS_SOURCES:.hs=.o))
	$(RANLIB) $@

install-everything: install install-example-sources

install-distribution: $(FULLNAME).tgz WASH-CGI-Examples-$(VERSION).tgz
	$(INSTALL) -c -m 644 $(FULLNAME).tgz WASH-CGI-Examples-$(VERSION).tgz $(WWWDIR)

install-dumb-package: lib$(PACKAGE).a install-files install-package

install-files:
	$(INSTALL) -d $(PACKAGELIBDIR)
	$(INSTALL) -d $(PACKAGEIMPORTDIR)
	$(INSTALL) -c -m 644 $(HS_SOURCES:.hs=.hi) $(PACKAGEIMPORTDIR)
	$(INSTALL) -c -m 644 lib$(PACKAGE).a $(PACKAGELIBDIR)
	$(RANLIB) $(PACKAGELIBDIR)/lib$(PACKAGE).a

install: install-dumb-package
ifeq ($(ENABLE_REG_PACKAGE),yes)
	$(GENPKG) WASH --ghc-version $(HC_VERSION) --version $(VERSION) --license BSD3 --package_deps WASH-CGI --extra_ghc_opts -F -pgmF $(bindir)/wash2hs | $(GHCPKG_UPDATE) $(GHCPKGFLAGS) --auto-ghci-libs
endif

$(FULLNAME).tgz: $(FILES) $(EXFILES) documentation
	$(RM) -rf $(TMPDIR)/$(FULLNAME)
	$(MKDIR) -p $(TMPDIR)/$(FULLNAME)/$(EXDIR) $(TMPDIR)/$(FULLNAME)/$(DOCDIR)
	$(CP) $(FILES) $(TMPDIR)/$(FULLNAME)
	$(CP) $(addprefix $(EXDIR),$(EXSOURCES)) $(TMPDIR)/$(FULLNAME)/$(EXDIR)
	$(CP) $(DOCDIR)/*.html $(DOCDIR)/*.gif $(DOCDIR)/*.css $(TMPDIR)/$(FULLNAME)/$(DOCDIR)
	$(TAR) cvhfCz $@ $(TMPDIR) $(FULLNAME)

documentation::
	$(HADDOCK) -o $(DOCDIR) -h $(HS_SOURCES)

clean:
	$(RM) -f *.a *.o *.hi

veryclean:: clean

depend::
	$(HC) -M $(HCFLAGS) -optdep-exclude-directory=$(PATH_TO_WASHHTML) -optdep-exclude-directory=$(PATH_TO_WASHMAIL) -optdep-exclude-directory=$(PATH_TO_UTILITY) $(HS_FILES)

# DO NOT DELETE: Beginning of Haskell dependencies
../Mail/RFC2822.o : ../Mail/RFC2822.hs
../Mail/ContentDisposition.o : ../Mail/ContentDisposition.hs
../Mail/ContentDisposition.o : ../Mail/RFC2822.hi
../Utility/SimpleParser.o : ../Utility/SimpleParser.hs
../Utility/IntToString.o : ../Utility/IntToString.hs
../Utility/ISO8601.o : ../Utility/ISO8601.hs
../Utility/ISO8601.o : ../Utility/SimpleParser.hi
../Utility/ISO8601.o : ../Utility/IntToString.hi
../Utility/BulkIO.o : ../Utility/BulkIO.hs
../Utility/Base32.o : ../Utility/Base32.hs
../Utility/SHA1.o : ../Utility/SHA1.hs
../Utility/RFC2279.o : ../Utility/RFC2279.hs
../Utility/Base64.o : ../Utility/Base64.hs
../WASH/HTMLBase.o : ../WASH/HTMLBase.hs
../WASH/HTMLMonadBase.o : ../WASH/HTMLMonadBase.hs
../WASH/HTMLMonadBase.o : ../WASH/HTMLBase.hi
../WASH/HTMLMonad.o : ../WASH/HTMLMonad.hs
../WASH/HTMLMonad.o : ../WASH/HTMLMonadBase.hi
../WASH/HTMLMonad98.o : ../WASH/HTMLMonad98.hs
../WASH/HTMLMonad98.o : ../WASH/HTMLMonad.hi
../WASH/HTMLMonad98.o : ../WASH/HTMLMonad.hi
../Utility/FileNames.o : ../Utility/FileNames.hs
../Utility/Shell.o : ../Utility/Shell.hs
../Utility/Auxiliary.o : ../Utility/Auxiliary.hs
../Utility/Auxiliary.o : ../Utility/Shell.hi
../Utility/Auxiliary.o : ../Utility/FileNames.hi
../Utility/Locking.o : ../Utility/Locking.hs
../Utility/Locking.o : ../Utility/Auxiliary.hi
../Utility/Unique.o : ../Utility/Unique.hs
../Utility/Unique.o : ../Utility/Locking.hi
../Utility/Unique.o : ../Utility/Auxiliary.hi
../Utility/Hex.o : ../Utility/Hex.hs
../Utility/URLCoding.o : ../Utility/URLCoding.hs
../Utility/URLCoding.o : ../Utility/Hex.hi
../Utility/RFC2397.o : ../Utility/RFC2397.hs
../Utility/RFC2397.o : ../Utility/Base64.hi
../Utility/RFC2397.o : ../Utility/URLCoding.hi
../Utility/QuotedPrintable.o : ../Utility/QuotedPrintable.hs
../Utility/QuotedPrintable.o : ../Utility/Hex.hi
../Utility/RFC2047.o : ../Utility/RFC2047.hs
../Utility/RFC2047.o : ../Utility/Hex.hi
../Utility/RFC2047.o : ../Utility/QuotedPrintable.hi
../Utility/RFC2047.o : ../Utility/Base64.hi
../Mail/HeaderField.o : ../Mail/HeaderField.hs
../Mail/HeaderField.o : ../Utility/RFC2047.hi
../Mail/MIME.o : ../Mail/MIME.hs
../Mail/MIME.o : ../Utility/RFC2279.hi
../Mail/MIME.o : ../Mail/HeaderField.hi
../Mail/MIME.o : ../Utility/QuotedPrintable.hi
../Mail/MIME.o : ../Mail/ContentDisposition.hi
../Mail/MIME.o : ../Utility/Base64.hi
../Utility/JavaScript.o : ../Utility/JavaScript.hs
../Utility/JavaScript.o : ../Utility/Hex.hi
../WASH/HTMLTemplates.o : ../WASH/HTMLTemplates.hs
../WASH/HTMLTemplates.o : ../Utility/Base32.hi
../WASH/HTMLTemplates.o : ../Utility/JavaScript.hi
../WASH/HTMLTemplates.o : ../Utility/SHA1.hi
../WASH/HTMLTemplates.o : ../WASH/HTMLBase.hi
Types.o : Types.hs
Style.o : Style.hs
Style.o : ../WASH/HTMLMonad.hi
StateItem.o : StateItem.hs
PPM.o : PPM.hs
HTMLWrapper.o : HTMLWrapper.hs
HTMLWrapper.o : ../WASH/HTMLMonad.hi
HTMLMail.o : HTMLMail.hs
HTMLMail.o : ../Mail/MIME.hi
HTMLMail.o : ../WASH/HTMLMonad.hi
EventHandlers.o : EventHandlers.hs
EventHandlers.o : HTMLWrapper.hi
ContentType.o : ContentType.hs
CGITypes.o : CGITypes.hs
CGITypes.o : HTMLWrapper.hi
Fields.o : Fields.hs
Fields.o : CGITypes.hi
Fields.o : ../Utility/SimpleParser.hi
Fields.o : ../Utility/ISO8601.hi
Images.o : Images.hs
Images.o : ../Utility/JavaScript.hi
Images.o : ../Utility/RFC2397.hi
Images.o : CGITypes.hi
RawCGITypes.o : RawCGITypes.hs
RawCGITypes.o : CGITypes.hi
Debug.o : Debug.hs
Debug.o : ../Utility/IntToString.hi
Debug.o : ../Utility/ISO8601.hi
Debug.o : ../Utility/Shell.hi
Debug.o : RawCGITypes.hi
Debug.o : ../Utility/Auxiliary.hi
CGIConfig.o : CGIConfig.hs
CGIOutput.o : CGIOutput.hs
CGIOutput.o : ../WASH/HTMLTemplates.hi
CGIOutput.o : HTMLWrapper.hi
CGIOutput.o : CGITypes.hi
CGIOutput.o : CGIConfig.hi
CGIOutput.o : ../Utility/Shell.hi
CGIOutput.o : ../Utility/RFC2279.hi
CGIOutput.o : Debug.hi
CGIOutput.o : ../Utility/BulkIO.hi
CGIOutput.o : ../Utility/Auxiliary.hi
RawCGIInternal.o : RawCGIInternal.hs
RawCGIInternal.o : Debug.hi
RawCGIInternal.o : ../Utility/Hex.hi
RawCGIInternal.o : ../Utility/BulkIO.hi
RawCGIInternal.o : RawCGITypes.hi
RawCGIInternal.o : CGITypes.hi
RawCGIInternal.o : CGIConfig.hi
RawCGIInternal.o : ../Utility/RFC2279.hi
RawCGIInternal.o : ../Utility/URLCoding.hi
RawCGIInternal.o : ../Utility/Unique.hi
RawCGIInternal.o : ../Utility/Auxiliary.hi
CGIMonad.o : CGIMonad.hs
CGIMonad.o : ../Utility/SHA1.hi
CGIMonad.o : RawCGIInternal.hi
CGIMonad.o : ../WASH/HTMLMonad.hi
CGIMonad.o : CGITypes.hi
CookieIO.o : CookieIO.hs
CookieIO.o : ../Utility/URLCoding.hi
CookieIO.o : RawCGITypes.hi
CookieIO.o : Debug.hi
CookieIO.o : CGIMonad.hi
Frames.o : Frames.hs
Frames.o : ../Utility/JavaScript.hi
Frames.o : ../Utility/URLCoding.hi
Frames.o : RawCGIInternal.hi
Frames.o : Images.hi
Frames.o : Fields.hi
Frames.o : EventHandlers.hi
Frames.o : CGITypes.hi
Frames.o : CGIOutput.hi
Frames.o : CGIMonad.hi
Frames.o : CGIConfig.hi
Frames.o : CookieIO.hi
Frames.o : HTMLWrapper.hi
Frames.o : ../Utility/Auxiliary.hi
CGIInternals.o : CGIInternals.hs
CGIInternals.o : CGIConfig.hi
CGIInternals.o : ../Utility/URLCoding.hi
CGIInternals.o : RawCGIInternal.hi
CGIInternals.o : ../Utility/RFC2397.hi
CGIInternals.o : ../Utility/RFC2279.hi
CGIInternals.o : ../Utility/JavaScript.hi
CGIInternals.o : Images.hi
CGIInternals.o : HTMLWrapper.hi
CGIInternals.o : Frames.hi
CGIInternals.o : Fields.hi
CGIInternals.o : EventHandlers.hi
CGIInternals.o : CGITypes.hi
CGIInternals.o : CGIOutput.hi
CGIInternals.o : CGIMonad.hi
CGIInternals.o : CookieIO.hi
CGIInternals.o : ../Utility/Base64.hi
CGIInternals.o : ../Utility/Auxiliary.hi
CGIGraphics.o : CGIGraphics.hs
CGIGraphics.o : CGIConfig.hi
CGIGraphics.o : ../Utility/Unique.hi
CGIGraphics.o : ../WASH/HTMLMonad.hi
CGIGraphics.o : PPM.hi
CGIGraphics.o : CGIMonad.hi
CGIGraphics.o : CGIInternals.hi
CGIGraphics.o : CGITypes.hi
CGIGraphics.o : RawCGIInternal.hi
CGIGraphics.o : ../Utility/Hex.hi
Cookie.o : Cookie.hs
Cookie.o : StateItem.hi
Cookie.o : Types.hi
Cookie.o : ../WASH/HTMLMonad.hi
Cookie.o : CGIMonad.hi
Cookie.o : CGIInternals.hi
SubmitXX.o : SubmitXX.hs
SubmitXX.o : EventHandlers.hi
SubmitXX.o : CGIMonad.hi
SubmitXX.o : CGIInternals.hi
CGIXX.o : CGIXX.hs
CGIXX.o : Frames.hi
CGIXX.o : HTMLWrapper.hi
CGIXX.o : Style.hi
CGIXX.o : Fields.hi
CGIXX.o : CGITypes.hi
CGIXX.o : CGIOutput.hi
CGIXX.o : SubmitXX.hi
CGIXX.o : CGIInternals.hi
CGIXX.o : CGIMonad.hi
CGIXX.o : CGITypes.hi
RawCGI.o : RawCGI.hs
RawCGI.o : RawCGIInternal.hi
RawCGI.o : CGITypes.hi
AbstractSelector.o : AbstractSelector.hs
AbstractSelector.o : ../Utility/JavaScript.hi
AbstractSelector.o : ../Utility/URLCoding.hi
AbstractSelector.o : RawCGIInternal.hi
AbstractSelector.o : ../Utility/URLCoding.hi
AbstractSelector.o : HTMLWrapper.hi
AbstractSelector.o : CGIMonad.hi
AbstractSelector.o : CGIInternals.hi
Submit98.o : Submit98.hs
Submit98.o : HTMLWrapper.hi
Submit98.o : EventHandlers.hi
Submit98.o : CGIMonad.hi
Submit98.o : CGIInternals.hi
Submit98.o : AbstractSelector.hi
CGI.o : CGI.hs
CGI.o : Frames.hi
CGI.o : HTMLWrapper.hi
CGI.o : HTMLWrapper.hi
CGI.o : Style.hi
CGI.o : Fields.hi
CGI.o : CGITypes.hi
CGI.o : CGIOutput.hi
CGI.o : Submit98.hi
CGI.o : CGIInternals.hi
CGI.o : CGIMonad.hi
CGI.o : CGITypes.hi
CGI.o : AbstractSelector.hi
GuaranteedCGI.o : GuaranteedCGI.hs
GuaranteedCGI.o : CGI.hi
GuaranteedCGI.o : ../WASH/HTMLMonad98.hi
GuaranteedCGI.o : CGI.hi
GuaranteedCGI.o : CGIInternals.hi
GuaranteedCGI.o : Style.hi
GuaranteedCGI.o : Fields.hi
GuaranteedCGI.o : CGITypes.hi
Persistent2.o : Persistent2.hs
Persistent2.o : ../Utility/Base32.hi
Persistent2.o : ../Utility/SHA1.hi
Persistent2.o : StateItem.hi
Persistent2.o : ../Utility/Locking.hi
Persistent2.o : Types.hi
Persistent2.o : CGIInternals.hi
Persistent2.o : CGI.hi
Persistent2.o : ../Utility/Auxiliary.hi
Persistent2.o : CGIConfig.hi
# DO NOT DELETE: End of Haskell dependencies
