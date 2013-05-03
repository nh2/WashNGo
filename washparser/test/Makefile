HC=		ghc
HCPACKAGEFLAGS=	-package-conf $(HOME)/public/lib/ghc/package.conf -package WASH
HC_SPEC_FLAGS=	
HCLOADFLAGS=	$(HCPACKAGEFLAGS) $(OPT) $(HC_SPEC_FLAGS)	

#OPT=		-O
OPT=

HCFLAGS=	$(OPT) $(HC_SPEC_FLAGS) $(HINCLUDES)

HMAKE=		$(HC) --make 			# hmake
HINCLUDES=	$(HCPACKAGEFLAGS) 
HAPPY=		happy
HAPPYFLAGS=	-i
RM=		rm -f

LINK.o=		$(HC) $(HCLOADFLAGS)

HS_FILES=	\
	ManuelsTable.hs

EXAMPLES= \
	 ManuelsTable

all: $(EXAMPLES)

veryclean:: clean
	$(RM) *.hi *.o

depend::
	$(HC) -M $(HCFLAGS) $(HS_FILES)

clean::
	$(RM) $(EXAMPLES)

%.hs: %.wash
	wash2hs $<

%.o: %.hs
	$(HC) $(HCFLAGS) -c $< -o $@

%.hi: %.o
	@\:

# DO NOT DELETE: Beginning of Haskell dependencies
ManuelsTable.o : ManuelsTable.hs
# DO NOT DELETE: End of Haskell dependencies
