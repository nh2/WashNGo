
HC_SPEC_FLAGS=	-package WashNGo
HCLOADFLAGS=	$(OPT) $(HC_SPEC_FLAGS)

#OPT=		-O
OPT=		

HCFLAGS=	$(OPT) $(HC_SPEC_FLAGS) $(HINCLUDES) $(HCEXTRAFLAGS)

HINCLUDES=

LINK.o=		$(HC) $(HCLOADFLAGS)

FILES= Makefile $(HS_FILES)

HS_FILES=	\
	CalcHistory.hs \
	CalcFix.hs \
	Calculator.hs \
	Counter.hs \
	CounterControl.hs \
	CounterWithBoundedLog.hs \
	DiskImages.hs \
	ForeignReport.hs \
	GuessNumber.hs \
	GuessNumberCookie.hs \
	GuessNumberNoCheating.hs \
	HelloWorld.hs \
	Item.hs \
	Login.hs \
	Manager.hs \
	Multiplication.hs \
	RepBase.hs \
	Report2.hs \
	Score.hs \
	SendFile.hs \
	Submit.hs \
	TimeTable.hs \
	TinyShop.hs \
	TinyShopXX.hs \
	Tutorial.hs \
	UpDownCounter.hs \
	Upload.hs \
	UseAT.hs \
	UseCGI4.hs \
	UseGraphics.hs \
	Vote.hs \
	ex1.hs ex2-2.hs ex2-3.hs ex3-1.hs ex3-2-a.hs ex3-2-b.hs

OTHER_FILES=	\
	GraphicsEditor.hs \
	MANAGER.hs \
	ReportForAuthor.hs \


EXAMPLES= \
	 CalcHistory CalcFix Calculator Counter HelloWorld \
	 Multiplication UpDownCounter UseAT UseCGI4 UseGraphics \
	 GuessNumberCookie GuessNumber GuessNumberNoCheating TimeTable \
	 SendFile Tutorial Upload Vote TinyShop TinyShopXX \
	 ex1 ex2-2 ex2-3 ex3-1 ex3-2-a ex3-2-b
	 # GraphicsEditor  

all: $(EXAMPLES)

include $(TOP)/mk/config.mk
include $(TOP)/mk/common.mk

WASH-CGI-Examples-$(VERSION).tgz: $(FILES)
	$(TAR) cvhfz $@ $(FILES)

install: all
	$(SSH) $(WWWHOST) mkdir -p $(CGIDIR); \
	for f in $(EXAMPLES); \
	do \
	$(SCP) -q $$f $(WWWHOST):$(CGIDIR)/$$f.cgi; \
	$(SSH) $(WWWHOST) chmod 755 $(CGIDIR)/$$f.cgi; \
	done

install-example-sources:
	for f in $(EXAMPLES); \
	do \
	$(SCP) -q $$f.hs $(WWWHOST):$(WWWDIR); \
	$(SSH) $(WWWHOST) chmod 644 $(WWWDIR)/$$f.hs; \
	done

Manager: Manager.o Item.o RepBase.o Report2.o Submit.o ForeignReport.o
	$(LINK.o) $^ -o $@ -package text

MANAGER: MANAGER.o Item.o RepBase.o Report2.o Submit.o ForeignReport.o
	$(LINK.o) $^ -o $@ -package text
Manager.o : Manager.hs
	$(HC) $(HCFLAGS) -c $< -o $@
MANAGER.o : MANAGER.hs
	$(HC) $(HCFLAGS) -c $< -o $@
Report2.o : Report2.hs
	$(HC) $(HCFLAGS) -c $< -o $@
Submit.o : Submit.hs
	$(HC) $(HCFLAGS) -c $< -o $@
Item.o : Item.hs
	$(HC) $(HCFLAGS) -c $< -o $@

GuessNumber: GuessNumber.o Score.o
GuessNumberNoCheating: GuessNumberNoCheating.o Score.o
GuessNumberCookie: GuessNumberCookie.o Score.o
TinyShop: TinyShop.o DiskImages.o
	$(LINK.o) $^ -o $@ -package text
TinyShopXX: TinyShopXX.o DiskImages.o
	$(LINK.o) $^ -o $@ -package text

clean::
	$(RM) -f *.hi *.o

veryclean:: clean
	$(RM) -f $(EXAMPLES)

depend::
	$(HC) -M $(HCFLAGS) $(HS_FILES)

include $(TOP)/mk/common-goals.mk

# DO NOT DELETE: Beginning of Haskell dependencies
Calculator.o : Calculator.hs
Counter.o : Counter.hs
DiskImages.o : DiskImages.hs
ForeignReport.o : ForeignReport.hs
ForeignReport.o : ./RepBase.hi
ForeignReport.o : ./Item.hi
GuessNumber.o : GuessNumber.hs
GuessNumber.o : ./Score.hi
GuessNumberCookie.o : GuessNumberCookie.hs
GuessNumberNoCheating.o : GuessNumberNoCheating.hs
GuessNumberNoCheating.o : ./Score.hi
HelloWorld.o : HelloWorld.hs
Item.o : Item.hs
Login.o : Login.hs
Manager.o : Manager.hs
Manager.o : ./Submit.hi
Multiplication.o : Multiplication.hs
RepBase.o : RepBase.hs
RepBase.o : Item.hi
Report2.o : Report2.hs
Report2.o : RepBase.hi
Score.o : Score.hs
SendFile.o : SendFile.hs
Submit.o : Submit.hs
Submit.o : ForeignReport.hi
Submit.o : Report2.hi
Submit.o : Item.hi
TimeTable.o : TimeTable.hs
TinyShop.o : TinyShop.hs
TinyShop.o : DiskImages.hi
TinyShopXX.o : TinyShopXX.hs
TinyShopXX.o : DiskImages.hi
Tutorial.o : Tutorial.hs
UpDownCounter.o : UpDownCounter.hs
Upload.o : Upload.hs
UseAT.o : UseAT.hs
UseCGI4.o : UseCGI4.hs
UseGraphics.o : UseGraphics.hs
Vote.o : Vote.hs
ex1.o : ex1.hs
ex2-2.o : ex2-2.hs
ex2-3.o : ex2-3.hs
ex3-1.o : ex3-1.hs
ex3-2-a.o : ex3-2-a.hs
ex3-2-b.o : ex3-2-b.hs
# DO NOT DELETE: End of Haskell dependencies
