#
# Makefile for WASH/Utility (Haskell98)
# copyright 2001-2005 by Peter Thiemann
#

PACKAGE=Utility
VERSION=0.3.11

include $(TOP)/mk/config.mk
include $(TOP)/mk/common.mk

FILES= Makefile LICENSE $(HS_SOURCES) $(C_SOURCES) $(H_SOURCES)
MODULES= $(EXPOSED_MODULES)$(HIDDEN_MODULES)
PACKAGE_DEPENDENCIES= haskell98 text
HIDDEN_MODULES=
EXPOSED_MODULES= \
	Auxiliary \
	Base32 \
	Base64 \
	BulkIO \
	FileNames \
	Hex \
	ISO8601 \
	IntToString \
	JavaScript \
	Locking \
	QuotedPrintable \
	RFC2047 \
	RFC2279 \
	RFC2397 \
	SHA1 \
	SimpleParser \
	Shell \
	URLCoding \
	Unique

HS_SOURCES= $(MODULES:=.hs)
C_SOURCES= sha1lib.c
H_SOURCES= sha1lib.h

FULLNAME=$(PACKAGE)-$(VERSION)
BINDISTNAME=$(PACKAGE)-bin-$(VERSION).tgz
DISTNAME=$(FULLNAME).tgz
# where the WASH homepage resides
WWWDIR=$(HOME)/public/www/haskell/WASH
TMPDIR=/tmp

######################################################################
# goals

all: libUtility.a

# the single C object is incorporated by special magic
#PJT# libUtility.a: libUtility.a($(HS_SOURCES:.hs=.o) $(C_SOURCES:.c=.o))
libUtility.a: libUtility.a($(HS_SOURCES:.hs=.o))
	$(RANLIB) $@



dist: documentation
	$(RM) -rf $(TMPDIR)/$(FULLNAME)
	$(MKDIR) -p $(TMPDIR)/$(FULLNAME)/$(DOCSUBDIR)
	$(CP) $(FILES) $(TMPDIR)/$(FULLNAME)
	$(CP) -rp $(DOCSUBDIR) $(TMPDIR)/$(FULLNAME)
	$(TAR) cfCvz $(DISTNAME) $(TMPDIR) $(FULLNAME)

install-distribution: dist
	$(INSTALL) $(DISTNAME) $(WWWDIR)

install: libUtility.a install-files install-package

install-files:
	$(INSTALL) -d $(PACKAGELIBDIR)
	$(INSTALL) -d $(PACKAGEIMPORTDIR)
	$(INSTALL) -c -m 644 $(HS_SOURCES:.hs=.hi) $(PACKAGEIMPORTDIR)
	$(INSTALL) -c -m 644 libUtility.a $(PACKAGELIBDIR)
	$(RANLIB) $(PACKAGELIBDIR)/libUtility.a

######################################################################
# special dependencies

sha1lib.o: sha1lib.h
#PJT# SHA1.o: sha1lib.h
SHA1-pre.o: sha1lib.h

#PJT# experimental.
# work around hs-plugins limitation: 
# hs-plugins does not load supplementary C objects dynamically
# now we try to cheat it by glueing the C object onto the Haskell object 
# that imports it
SHA1-pre.o: SHA1.hs
	$(HC) $(HCFLAGS) -c $< -o $@
SHA1.o: SHA1-pre.o sha1lib.o
	$(LD) -r SHA1-pre.o sha1lib.o -o $@

######################################################################
# generic stuff

HC_SPEC_FLAGS=  -package-name $(PACKAGE)
HCINCLUDES=	-package text
HCLOADFLAGS=

OPT=		-O2 -ffi

HCFLAGS=	$(OPT) $(HC_SPEC_FLAGS) $(HCINCLUDES) $(HCEXTRAFLAGS)

HS_FILES=	$(HS_SOURCES)

DOCSUBDIR= doc

documentation: $(DOCSUBDIR)

$(DOCSUBDIR): $(HS_SOURCES)
	$(RM) -rf $(DOCSUBDIR)
	$(MKDIR) $(DOCSUBDIR)
	$(HADDOCK) -o $(DOCSUBDIR) -h $(HS_SOURCES)

clean:
	$(RM) -f *.a *.o *.hi

veryclean:: clean

depend::
	$(HC) -M $(HCFLAGS) $(HS_FILES)

# DO NOT DELETE: Beginning of Haskell dependencies
Shell.o : Shell.hs
SimpleParser.o : SimpleParser.hs
SHA1.o : SHA1.hs
RFC2279.o : RFC2279.hs
IntToString.o : IntToString.hs
ISO8601.o : ISO8601.hs
ISO8601.o : SimpleParser.hi
ISO8601.o : IntToString.hi
Hex.o : Hex.hs
JavaScript.o : JavaScript.hs
JavaScript.o : Hex.hi
QuotedPrintable.o : QuotedPrintable.hs
QuotedPrintable.o : Hex.hi
URLCoding.o : URLCoding.hs
URLCoding.o : Hex.hi
FileNames.o : FileNames.hs
BulkIO.o : BulkIO.hs
Base64.o : Base64.hs
RFC2047.o : RFC2047.hs
RFC2047.o : Hex.hi
RFC2047.o : QuotedPrintable.hi
RFC2047.o : Base64.hi
RFC2397.o : RFC2397.hs
RFC2397.o : Base64.hi
RFC2397.o : URLCoding.hi
Base32.o : Base32.hs
Auxiliary.o : Auxiliary.hs
Auxiliary.o : Shell.hi
Auxiliary.o : FileNames.hi
Locking.o : Locking.hs
Locking.o : Auxiliary.hi
Unique.o : Unique.hs
Unique.o : Locking.hi
Unique.o : Auxiliary.hi
# DO NOT DELETE: End of Haskell dependencies
