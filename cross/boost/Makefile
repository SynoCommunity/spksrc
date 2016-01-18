PKG_NAME = boost
PKG_VERS = 1.59.0
PKG_EXT = tar.bz2
PKG_DIR = $(PKG_NAME)_$(subst .,_,$(PKG_VERS))
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://sourceforge.net/projects/$(PKG_NAME)/files/$(PKG_NAME)/$(PKG_VERS)

DEPENDS = cross/bzip2 cross/zlib cross/python

HOMEPAGE = http://www.boost.org/
COMMENT  = Boost provides free peer-reviewed portable C++ source libraries.
LICENSE  = http://www.boost.org/LICENSE_1_0.txt

CONFIGURE_TARGET = myConfigure
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall

# Build all if not told otherwise (will most likely fail)
BOOST_LIBRARIES ?= all

# Useful variables for subst
comma:= ,
empty:=
space:= $(empty) $(empty)

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --with-toolset=gcc --with-libraries=$(subst $(space),$(comma),$(sort $(BOOST_LIBRARIES))) --prefix=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-python=$(WORK_DIR)/../../../native/python/work-native/install/usr/local/bin/python

ADDRESS_MODEL = 32
ifneq ($(findstring $(ARCH), avoton braswell bromolow cedarview x64 x86),)
ADDRESS_MODEL = 64
endif

include ../../mk/spksrc.cross-cc.mk
-include $(WORK_DIR)/python-cc.mk

.PHONY: myConfigure
myConfigure:
	$(RUN) ./bootstrap.sh $(CONFIGURE_ARGS)

.PHONY: myCompile
myCompile:
	@# Recreate user-config.jam to include python-cc.mk on second run
	@rm -rf $(WORK_DIR)/$(PKG_DIR)/user-config.jam
	@echo "using gcc : `$(TC_PATH)$(TC_PREFIX)gcc -dumpversion` : $(TC_PATH)$(TC_PREFIX)g++ : <address-model>\"$(ADDRESS_MODEL)\" <cflags>\"$(CFLAGS)\" <cxxflags>\"$(CXXFLAGS)\" <linkflags>\"$(LDFLAGS)\" <link>\"shared\" ; " > $(WORK_DIR)/$(PKG_DIR)/user-config.jam
	@echo "using python : $(PYTHON_VERSION) : : $(STAGING_INSTALL_PREFIX)/$(PYTHON_INC_DIR) ;" >> $(WORK_DIR)/$(PKG_DIR)/user-config.jam
	@echo "project : requirements <cxxflags>$(OFLAGS) ;" >> $(WORK_DIR)/$(PKG_DIR)/user-config.jam
	$(RUN) ./b2 --user-config=$(WORK_DIR)/$(PKG_DIR)/user-config.jam

.PHONY: myInstall
myInstall:
	$(RUN) ./b2 --user-config=$(WORK_DIR)/$(PKG_DIR)/user-config.jam install
