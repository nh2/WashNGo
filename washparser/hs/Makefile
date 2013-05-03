include $(TOP)/mk/config.mk
include $(TOP)/mk/common.mk


HC_SPEC_FLAGS=	
HCLOADFLAGS=	$(HCPACKAGEFLAGS)
OPT=

HCFLAGS=	$(OPT) $(HC_SPEC_FLAGS) $(HINCLUDES)

HINCLUDES=	$(HCPACKAGEFLAGS)
HCPACKAGEFLAGS=	-package text


LINK.o=		$(HC) $(HCLOADFLAGS)


HS_FILES= \
	WASHOut.hs \
	WASHData.hs \
	WASHUtil.hs \
	WASHParser.hs \
	WASHClean.hs \
	WASHFlags.hs \
	WASHExpression.hs \
	WASHGenerator.hs \
	WASHMain.hs \

CLEAN_FILES= \
	$(HS_FILES:.hs=.o) \
	$(HS_FILES:.hs=.hi) \


all: WASHMain

WASHMain: $(HS_FILES:.hs=.o)

depend::
	$(HC) -M $(HCFLAGS) $(HS_FILES)

clean::
	$(RM) -f $(CLEAN_FILES)

veryclean: clean
	$(RM) -f WASHMain wash2hs

include $(TOP)/mk/common-goals.mk

# DO NOT DELETE: Beginning of Haskell dependencies
WASHFlags.o : WASHFlags.hs
WASHOut.o : WASHOut.hs
WASHData.o : WASHData.hs
WASHUtil.o : WASHUtil.hs
WASHUtil.o : WASHData.hi
WASHParser.o : WASHParser.hs
WASHParser.o : WASHUtil.hi
WASHParser.o : WASHData.hi
WASHClean.o : WASHClean.hs
WASHClean.o : WASHData.hi
WASHExpression.o : WASHExpression.hs
WASHExpression.o : WASHOut.hi
WASHExpression.o : WASHData.hi
WASHExpression.o : WASHUtil.hi
WASHExpression.o : WASHFlags.hi
WASHGenerator.o : WASHGenerator.hs
WASHGenerator.o : WASHFlags.hi
WASHGenerator.o : WASHClean.hi
WASHGenerator.o : WASHExpression.hi
WASHGenerator.o : WASHParser.hi
WASHGenerator.o : WASHData.hi
WASHMain.o : WASHMain.hs
WASHMain.o : WASHFlags.hi
WASHMain.o : WASHGenerator.hi
# DO NOT DELETE: End of Haskell dependencies
