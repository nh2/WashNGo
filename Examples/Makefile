CGIDIR= /usr/lib/cgi-bin/WASH
CONFIGFLAGS= --prefix=$(CGIDIR)
INSTALLFLAGS=
SETUP= ./Setup.lhs

all:
	$(SETUP) configure $(CONFIGFLAGS)
	$(SETUP) build

install:
	$(SETUP) install $(INSTALLFLAGS)

clean:	
	$(SETUP) clean
