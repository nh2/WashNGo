LINK.o=		$(HC) $(HCLOADFLAGS)

EXAMPLES=Counter HelloWorld Multiplication GuessNumberNoCheating Tutorial

MODULES=$(EXAMPLES) Score

FURTHER_EXAMPLES= TimeTable \
	 SendFile Upload Vote TinyShop TinyShopXX \
	 ex1 ex2-2 ex2-3 ex3-1 ex3-2-a ex3-2-b


include $(TOP)/mk/config.mk
include $(TOP)/mk/common.mk

all: 
	$(MAKE) reallyall HC=$(bindir)/washc

reallyall: $(EXAMPLES)

clean:
	$(RM) -f $(MODULES:=.hi) $(MODULES:=.o)

veryclean: clean
	$(RM) -f $(EXAMPLES)


depend:
	$(HC) -M $(HCFLAGS) $(MODULES:=.hs)

GuessNumberNoCheating: GuessNumberNoCheating.o Score.o


include $(TOP)/mk/common-goals.mk
# DO NOT DELETE: Beginning of Haskell dependencies
./Score.o : ./Score.hs
GuessNumberNoCheating.o : GuessNumberNoCheating.hs
GuessNumberNoCheating.o : ./Score.hi
Multiplication.o : Multiplication.hs
HelloWorld.o : HelloWorld.hs
Counter.o : Counter.hs
# DO NOT DELETE: End of Haskell dependencies
