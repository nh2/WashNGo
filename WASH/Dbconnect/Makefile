PACKAGE=DBCONNECT
VERSION= 0.1.1
FILES= Makefile lib/Makefile lib/Dbconnect.hs lib/Libpqfe.chs lib/Libpqfe.hs \
	examples/Makefile examples/Main.hs examples/Mystylesheet.hs \
	examples/ducktales.sql examples/removeDucktales.sql
include $(TOP)/mk/config.mk
include $(TOP)/mk/common.mk

FULLNAME=$(PACKAGE)-$(VERSION)
DISTNAME=$(FULLNAME).tgz

TMPDIR=/tmp

all: 
	$(MAKE) -C lib all $(SUBDIRASSIGNMENT) VERSION=$(VERSION)

install:
	$(MAKE) -C lib install $(SUBDIRASSIGNMENT) VERSION=$(VERSION)

depend:
	$(MAKE) -C lib depend $(SUBDIRASSIGNMENT) VERSION=$(VERSION)

clean:
	$(MAKE) -C lib clean $(SUBDIRASSIGNMENT) VERSION=$(VERSION)

veryclean:
	$(MAKE) -C lib veryclean $(SUBDIRASSIGNMENT) VERSION=$(VERSION)

doc:
	$(MKDIR) -p doc
	$(MAKE) -C lib doc DOCDIR=../doc

install-distribution: $(DISTNAME)
	$(MKDIR) -p $(WWWDIR)
	$(INSTALL) -c -m 644 $< $(WWWDIR)

$(DISTNAME): doc Makefile
	$(RM) -rf $(TMPDIR)/$(FULLNAME)
	$(MKDIR) -p $(TMPDIR)/$(FULLNAME)
	$(TAR) cf - $(FILES) | tar xfC - $(TMPDIR)/$(FULLNAME)
	$(TAR) cfCvz $(DISTNAME) $(TMPDIR) $(FULLNAME)
