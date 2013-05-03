SETUPFLAGS= 
SETUP= ./Setup.lhs

all:
	$(SETUP) configure $(SETUPFLAGS)
	$(SETUP) build $(SETUPFLAGS)

clean:
	-$(SETUP) clean $(SETUPFLAGS)
	cd Examples; $(SETUP) clean $(SETUPFLAGS)
	-rm `find . -name "*.hsc"` `find . -name "*.hi"`

install:
	$(SETUP) install $(SETUPFLAGS)

haddock:
	$(SETUP) haddock $(SETUPFLAGS)

examples:
	$(MAKE) -C Examples

-include Makefile.distributor
