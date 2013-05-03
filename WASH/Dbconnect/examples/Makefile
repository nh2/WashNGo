# pg_config --includedir
#    /usr/local/tools/postgres/include
#
# pg_config --libdir
#    /usr/local/tools/postgres/lib
#
# 
# alle wichtigen Pfade

#WASHROOT=	$(HOME)/src/haskell/washngo
WASHROOT =/home/lack/wash
#WASHROOT =/home/sl/wash

PACKAGEROOT=	/usr/lib/ghc-6.2
PACKAGECONFIG=	$(PACKAGEROOT)/package.conf
#PACKAGEROOT=	$(HOME)/public/lib/ghc
#PACKAGECONFIG=	$(PACKAGEROOT)/package.conf

CGIDIR= /cgi-bin/catalogue/
#CGIDIR=/srv/www/cgi-bin/WASH



PATH_TO_DBCONNECT=../lib
CGIDIR= /cgi-bin/ducktales
CGIDIRUNI= /export/server/cgibin/ducktales

#PGLIB=/usr/local/tools/postgres/lib
#PGLIB=/usr/lib
PGLIB='pg_config --libdir'


#PGINCLUDE=/usr/include/postgresql
PGINCLUDE=`pg_config --includedir`

DOCDIR= haddock

HC=		ghc  -package-conf $(PACKAGECONFIG)

HC_SPEC_FLAGS=  -package WASH-CGI -package DBCONNECT -package text -package c2hs 
HCLOADFLAGS=	$(OPT) $(HC_SPEC_FLAGS)	
#	-optl -Xlinker -optl -rpath -optl -Xlinker -optl $(PGLIB)  



OPT=		-ffi 


HCFLAGS=	$(OPT) $(HC_SPEC_FLAGS) $(HINCLUDES)

HMAKE=		$(HC) --make 			# hmake
HINCLUDES=	-i$(PATH_TO_WASHCGI) -i$(PATH_TO_UTILITY) -i$(PATH_TO_WASHMAIL) \
		-i$(PATH_TO_WASHHTML) -i$(PATH_TO_DBCONNECT)
HAPPY=		happy
HAPPYFLAGS=	-i
RM=		rm -f

LINK.o=		$(HC) $(HCLOADFLAGS)  -optl--rpath=`pg_config --libdir` 


LIBSOURCES=Main.hs Style2.hs
HS_FILES=  Main.hs Style2.hs




Main :  Main.o  Style2.o
	$(LINK.o) -o Main Main.o Style2.o 


Main.o : Style2.o 
	$(HC)  $(HCFLAGS) -c Main.hs



veryclean: clean
	$(RM) *.hi *.o *.a

depend: 
	$(HC) -M $(HCFLAGS) $(HS_FILES) $(PATH_TO_DBCONNECT)/Dbconnect.o

doc::
	haddock -o $(DOCDIR) -h $(HS_FILES) 

install: Main
	 install -c -m 755 Main $(CGIDIR)/ducks.cgi; \

install-uni: Main
	install -c -m 755 Main $(CGIDIRUNI)/ducks.cgi; \




clean:
	$(RM) $(EXAMPLES)
%.o: %.hs
	$(HC) $(HCFLAGS) -c $< -o $@

%.hi: %.o
	@\:
# DO NOT DELETE: Beginning of Haskell dependencies
Main.o : Main.hs
Main.o : ./Style2.hi
Main.o : ../lib/Dbconnect.hi
Style2.o : Style2.hs
# DO NOT DELETE: End of Haskell dependencies
