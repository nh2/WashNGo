#
# Makefile for WASH/HTML (Haskell98)
# copyright 2001-2005 by Peter Thiemann
#

PACKAGE=WASHHTML
VERSION=0.14.8

include $(TOP)/mk/config.mk
include $(TOP)/mk/common.mk

PATH_TO_UTILITY=../Utility

FILES=  Makefile \
	LICENSE \
	$(HS_SOURCES)

HS_SOURCES= $(MODULES:=.hs)
MODULES= $(EXPOSED_MODULES)$(HIDDEN_MODULES)
PACKAGE_DEPENDENCIES= haskell98 text Utility
HIDDEN_MODULES=
EXPOSED_MODULES= \
	HTMLBase \
	HTMLMonad \
	HTMLMonadAttrs \
	HTMLMonad98 \
	HTMLMonadBase \
	HTMLPrelude \
	HTMLPrelude98 \
	HTMLTypedBase \
	HTMLTypedBase98 \
	HTMLTemplates

EXTENDED= \
	HTMLSuperBase.hs \
	HTMLSuperPrelude.hs \

FULLNAME=$(PACKAGE)-$(VERSION)
DISTNAME=$(FULLNAME).tgz

WASP_FILES= WASP-HTML.tgz WASP-SUPER.tgz WASP-Examples.tgz
WWW_ROOT= $(HOME)/public/www/haskell/WASP
WWWDIR=$(HOME)/public/www/haskell/WASH
TMPDIR=/tmp

######################################################################
# goals

all: libWASHHTML.a

libWASHHTML.a: libWASHHTML.a($(HS_SOURCES:.hs=.o))
	$(RANLIB) $@

Version: $(WASP_HTML_FILES) $(WASP_SUPER_FILES) $(WASP_EXAMPLE_FILES)
	$(DATE) > Version

WASP_HTML_FILES= HTMLBase.hs HTMLTypedBase.hs HTMLPrelude.hs
WASP-HTML.tgz: $(WASP_HTML_FILES) Version
	$(TAR) cvfz WASP-HTML.tgz $(WASP_HTML_FILES) Version

WASP_SUPER_FILES= HTMLBase.hs HTMLSuperBase.hs HTMLSuperPrelude.hs
WASP-SUPER.tgz: $(WASP_SUPER_FILES) Version
	$(TAR) cvfz WASP-SUPER.tgz $(WASP_SUPER_FILES) Version

WASP_EXAMPLE_FILES= Example.hs Texinfo.hs
WASP-Examples.tgz: $(WASP_EXAMPLE_FILES) Version
	$(TAR) cvfz WASP-Examples.tgz $(WASP_EXAMPLE_FILES) Version

dist::
	$(RM) -rf $(TMPDIR)/$(FULLNAME)
	$(INSTALL) -d $(TMPDIR)/$(FULLNAME)
	$(INSTALL) $(FILES) $(TMPDIR)/$(FULLNAME)
	$(TAR) cfCvz $(DISTNAME) $(TMPDIR) $(FULLNAME)

install-distribution: dist
	$(INSTALL) $(DISTNAME) $(WWWDIR)

install: libWASHHTML.a install-files install-package

install-files:
	$(INSTALL) -d $(PACKAGELIBDIR)
	$(INSTALL) -d $(PACKAGEIMPORTDIR)
	$(INSTALL) -c -m 644 $(HS_SOURCES:.hs=.hi) $(PACKAGEIMPORTDIR)
	$(INSTALL) -c -m 644 libWASHHTML.a $(PACKAGELIBDIR)
	$(RANLIB) $(PACKAGELIBDIR)/libWASHHTML.a

######################################################################
# generic stuff

HC_SPEC_FLAGS=	-package-name $(PACKAGE) # -cpp -package posix -package data
HCINCLUDES=	-i$(PATH_TO_UTILITY)
HCLOADFLAGS=

#OPT=		-fvia-C -O2-for-C 
#OPT=		-O
OPT=

HCFLAGS=	$(OPT) $(HC_SPEC_FLAGS) $(HCINCLUDES) $(HCEXTRAFLAGS)

DOCDIR= doc

clean:
	$(RM) -f *.a *.o *.hi

veryclean:: clean

depend::
	$(HC) -M $(HCFLAGS) $(HS_SOURCES)

# DO NOT DELETE: Beginning of Haskell dependencies
../Utility/SHA1.o : ../Utility/SHA1.hs
../Utility/Hex.o : ../Utility/Hex.hs
../Utility/JavaScript.o : ../Utility/JavaScript.hs
../Utility/JavaScript.o : ../Utility/Hex.hi
../Utility/Base32.o : ../Utility/Base32.hs
HTMLBase.o : HTMLBase.hs
HTMLMonadBase.o : HTMLMonadBase.hs
HTMLMonadBase.o : HTMLBase.hi
HTMLMonad.o : HTMLMonad.hs
HTMLMonad.o : HTMLMonadBase.hi
HTMLMonad98.o : HTMLMonad98.hs
HTMLMonad98.o : HTMLMonad.hi
HTMLMonad98.o : HTMLMonad.hi
HTMLMonadAttrs.o : HTMLMonadAttrs.hs
HTMLMonadAttrs.o : HTMLMonadBase.hi
HTMLTypedBase.o : HTMLTypedBase.hs
HTMLTypedBase.o : HTMLBase.hi
HTMLPrelude.o : HTMLPrelude.hs
HTMLPrelude.o : HTMLTypedBase.hi
HTMLTypedBase98.o : HTMLTypedBase98.hs
HTMLTypedBase98.o : HTMLBase.hi
HTMLPrelude98.o : HTMLPrelude98.hs
HTMLPrelude98.o : HTMLTypedBase98.hi
HTMLTemplates.o : HTMLTemplates.hs
HTMLTemplates.o : ../Utility/Base32.hi
HTMLTemplates.o : ../Utility/JavaScript.hi
HTMLTemplates.o : ../Utility/SHA1.hi
HTMLTemplates.o : HTMLBase.hi
# DO NOT DELETE: End of Haskell dependencies
