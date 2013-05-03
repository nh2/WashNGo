#
# Makefile for wash2hs (Haskell98)
# copyright 2004 by Peter Thiemann
#

VERSION= 0.5
PACKAGE= wash2hs

include $(TOP)/mk/config.mk
include $(TOP)/mk/common.mk

# you should not need to change anything below this line
FILES= Makefile LICENSE CHANGES \
	hs/Makefile \
	hs/WASHClean.hs hs/WASHData.hs hs/WASHExpression.hs hs/WASHFlags.hs \
	hs/WASHGenerator.hs \
	hs/WASHMain.hs hs/WASHParser.hs hs/WASHUtil.hs hs/WASHOut.hs \
	test/Makefile \
	test/Counter.wash test/Tutorial.wash test/ManuelsTable.hs \
	test/include.html test/TestF.hs test/Attributes.wash \
	spec/translation.txt

TMPDIR=	/tmp
WWWDIR= $(HOME)/public/www/haskell/WASH

FULLNAME=$(PACKAGE)-$(VERSION)

all:
	$(MAKE) -C hs all $(SUBDIRASSIGNMENT)

install: all
	$(INSTALL) -d $(bindir)
	$(INSTALL) -m 755 hs/WASHMain $(bindir)/wash2hs

clean:
	$(MAKE) -C hs clean $(SUBDIRASSIGNMENT)
	$(MAKE) -C test clean $(SUBDIRASSIGNMENT)

veryclean:
	$(MAKE) -C hs veryclean $(SUBDIRASSIGNMENT)
	$(MAKE) -C test veryclean $(SUBDIRASSIGNMENT)

depend:
	$(MAKE) -C hs depend $(SUBDIRASSIGNMENT)

test: install
	$(MAKE) -C test $(SUBDIRASSIGNMENT)

$(FULLNAME).tgz:
	$(RM) -rf $(TMPDIR)/$(FULLNAME)
	$(MKDIR) -p $(TMPDIR)/$(FULLNAME)
	$(TAR) chf - $(FILES) | tar xCf $(TMPDIR)/$(FULLNAME) -
	$(TAR) cvhfCz $@ $(TMPDIR) $(FULLNAME)
	$(RM) -rf $(TMPDIR)/$(FULLNAME)

install-distribution: $(FULLNAME).tgz
	$(INSTALL) -m 644 $(FULLNAME).tgz $(WWWDIR)
	$(RM) $(FULLNAME).tgz

include $(TOP)/mk/common-goals.mk
