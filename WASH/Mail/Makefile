#
# Makefile for WASH/Mail (Haskell98)
# copyright 2001-2005 by Peter Thiemann
#

PACKAGE=WASHMail
VERSION=0.3.8

include $(TOP)/mk/config.mk
include $(TOP)/mk/common.mk

FILES= Makefile LICENSE $(HS_SOURCES)
HS_SOURCES= $(MODULES:=.hs)
MODULES= $(EXPOSED_MODULES)$(HIDDEN_MODULES)
PACKAGE_DEPENDENCIES=  text Utility
HIDDEN_MODULES=
EXPOSED_MODULES= \
	ContentDisposition \
	Email \
	EmailConfig \
	HeaderField \
	MIME \
	MailParser \
	Message \
	RFC2822

FULLNAME=$(PACKAGE)-$(VERSION)
BINDISTNAME=$(PACKAGE)-bin-$(VERSION).tgz
DISTNAME=$(FULLNAME).tgz
WWWDIR=$(HOME)/public/www/haskell/WASH
TMPDIR=/tmp

PATH_TO_UTILITY=../Utility

######################################################################
# goals

all: libWASHMail.a

libWASHMail.a: libWASHMail.a($(HS_SOURCES:.hs=.o))
	$(RANLIB) $@

dist: documentation
	$(RM) -rf $(TMPDIR)/$(FULLNAME)
	$(MKDIR) -p $(TMPDIR)/$(FULLNAME)/$(DOCSUBDIR)
	$(CP) $(FILES) $(TMPDIR)/$(FULLNAME)
	$(CP) -rp $(DOCSUBDIR) $(TMPDIR)/$(FULLNAME)
	$(TAR) cfCvz $(DISTNAME) $(TMPDIR) $(FULLNAME)

install-distribution: dist
	$(INSTALL) $(DISTNAME) $(WWWDIR)

install: libWASHMail.a install-files install-package

install-files:
	$(INSTALL) -d $(PACKAGELIBDIR)
	$(INSTALL) -d $(PACKAGEIMPORTDIR)
	$(INSTALL) -c -m 644 $(HS_SOURCES:.hs=.hi) $(PACKAGEIMPORTDIR)
	$(INSTALL) -c -m 644 libWASHMail.a $(PACKAGELIBDIR)
	$(RANLIB) $(PACKAGELIBDIR)/libWASHMail.a

######################################################################
# generic stuff

HC_SPEC_FLAGS=	-package-name $(PACKAGE) -package text  # -cpp -package posix -package data
HCINCLUDES=	-i$(PATH_TO_UTILITY)
HCLOADFLAGS=

#OPT=		-fvia-C -O2-for-C 
#OPT=		-O
OPT=

HCFLAGS=	$(OPT) $(HC_SPEC_FLAGS) $(HCINCLUDES) $(HCEXTRAFLAGS)

DOCSUBDIR= doc


install: all

WASH-CGI-$(VERSION).tgz: $(FILES) $(EXFILES) documentation
	$(RM) -rf WASH-CGI-$(VERSION)
	$(MKDIR) -p WASH-CGI-$(VERSION)/$(EXDIR) WASH-CGI-$(VERSION)/$(DOCDIR)
	$(INSTALL) $(FILES) WASH-CGI-$(VERSION)
	cd $(EXDIR); $(INSTALL) $(EXSOURCES) ../WASH-CGI-$(VERSION)/$(EXDIR)
	cd $(DOCDIR); $(INSTALL) *.html *.gif *.css ../WASH-CGI-$(VERSION)/$(DOCDIR)
	$(TAR) cvhfz $@ WASH-CGI-$(VERSION)

documentation::
	$(MKDIR) -p $(DOCSUBDIR)
	$(HADDOCK) -o $(DOCSUBDIR) -h $(HS_SOURCES)

clean:
	$(RM) -f *.a *.o *.hi

veryclean:: clean

depend::
	$(HC) -M -optdep-exclude-directory=$(PATH_TO_UTILITY) $(HCFLAGS) $(HS_SOURCES)

# DO NOT DELETE: Beginning of Haskell dependencies
../Utility/RFC2279.o : ../Utility/RFC2279.hs
../Utility/Base64.o : ../Utility/Base64.hs
../Utility/Hex.o : ../Utility/Hex.hs
../Utility/QuotedPrintable.o : ../Utility/QuotedPrintable.hs
../Utility/QuotedPrintable.o : ../Utility/Hex.hi
../Utility/RFC2047.o : ../Utility/RFC2047.hs
../Utility/RFC2047.o : ../Utility/Hex.hi
../Utility/RFC2047.o : ../Utility/QuotedPrintable.hi
../Utility/RFC2047.o : ../Utility/Base64.hi
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
RFC2822.o : RFC2822.hs
HeaderField.o : HeaderField.hs
HeaderField.o : ../Utility/RFC2047.hi
Message.o : Message.hs
Message.o : HeaderField.hi
MailParser.o : MailParser.hs
MailParser.o : HeaderField.hi
MailParser.o : Message.hi
MailParser.o : RFC2822.hi
MailParser.o : ../Utility/RFC2047.hi
MailParser.o : ../Utility/QuotedPrintable.hi
MailParser.o : ../Utility/Base64.hi
EmailConfig.o : EmailConfig.hs
ContentDisposition.o : ContentDisposition.hs
ContentDisposition.o : RFC2822.hi
MIME.o : MIME.hs
MIME.o : ../Utility/RFC2279.hi
MIME.o : HeaderField.hi
MIME.o : ../Utility/QuotedPrintable.hi
MIME.o : ContentDisposition.hi
MIME.o : ../Utility/Base64.hi
Email.o : Email.hs
Email.o : MIME.hi
Email.o : HeaderField.hi
Email.o : EmailConfig.hi
Email.o : ../Utility/Unique.hi
Email.o : ../Utility/Auxiliary.hi
# DO NOT DELETE: End of Haskell dependencies
