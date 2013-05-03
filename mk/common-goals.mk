install-package:
ifeq ($(ENABLE_REG_PACKAGE),yes)
	$(GENPKG) $(PACKAGE) --ghc-version $(HC_VERSION) --version $(PACKAGE_VERSION) --license BSD3 --author 'Peter Thiemann' --exposed True --exposed-modules $(EXPOSED_MODULES) --hidden-modules $(HIDDEN_MODULES) --import_dirs $(PACKAGEIMPORTDIR) --library_dirs $(PACKAGELIBDIR) --hs_libraries $(HS_LIBRARIES) --package_deps $(PACKAGE_DEPENDENCIES) --extra_libraries $(EXTRA_LIBRARIES) --extra_ld_opts $(LD_OPTIONS) | $(GHCPKG_UPDATE) $(GHCPKGFLAGS) --auto-ghci-libs
endif

install-files: create-package-dirs copy-interfaces copy-component

create-package-dirs:
	$(INSTALL) -d $(PACKAGELIBDIR)
	$(INSTALL) -d $(PACKAGEIMPORTDIR)

copy-interfaces:
ifdef HS_SOURCES
	tar cf - $(HS_SOURCES:.hs=.hi) | tar xvfC - $(PACKAGEIMPORTDIR)
endif

copy-component:
ifdef COMPONENT
	$(INSTALL) -c -m 644 $(COMPONENT) $(PACKAGELIBDIR)
	$(RANLIB) $(PACKAGELIBDIR)/$(COMPONENT)
endif

echo:
	@echo $($(WHAT))

subdirs:
	for d in $(SUBDIRS) ; do \
	$(MAKE) -C $$d $(GOAL) $(SUBDIRASSIGNMENT) ; \
	done

%.o: %.hs
	$(HC) $(HCEXTRAFLAGS) $(HCFLAGS) -c $< -o $@

%.hi: %.o
	@\:
