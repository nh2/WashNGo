# the $(PACKAGE) variable is set by the toplevel Makefile in each compiler
# package
#
pkgdatadir    = $(datadir)/$(PACKAGE)-$(PACKAGE_VERSION)
pkgdocdir     = $(docdir)/$(PACKAGE)-$(PACKAGE_VERSION)
PACKAGELIBDIR = $(libdir)/$(PACKAGE)-$(PACKAGE_VERSION)/$(SYS)
PACKAGEIMPORTDIR = $(PACKAGELIBDIR)/import


CGIDIR= /export/server/cgibin/WASH
WWWDIR= $(HOME)/public/www/haskell/WASH
WWWHOST= nakalele.informatik.uni-freiburg.de

GENPKG=			$(TOP)/GenPKG/GenPKG

SUBDIRASSIGNMENT=	TOP=$(TOP)

