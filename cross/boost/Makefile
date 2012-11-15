PKG_NAME = boost
PKG_VERS = 1.52.0
PKG_EXT = tar.bz2
PKG_DIR = $(PKG_NAME)_$(subst .,_,$(PKG_VERS))
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://sourceforge.net/projects/$(PKG_NAME)/files/$(PKG_NAME)/$(PKG_VERS)

DEPENDS = cross/bzip2 cross/zlib native/python

HOMEPAGE = http://www.boost.org/
COMMENT  = Boost provides free peer-reviewed portable C++ source libraries.
LICENSE  = http://www.boost.org/LICENSE_1_0.txt

CONFIGURE_TARGET = myConfigure
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall
GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --with-toolset=gcc --without-libraries=wave,mpi,math --prefix=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-python=$(WORK_DIR)/../../../native/python/work-native/install/usr/local/bin/python
OFLAGS = -O3
ifeq ($(findstring $(ARCH),88f5281),$(ARCH))
OFLAGS = -O2
endif

include ../../mk/spksrc.cross-cc.mk

.PHONY: myConfigure
myConfigure:
	[ `$(TC_PATH)$(TC_PREFIX)gcc -dumpversion | cut -f1 -d.` -ge 4 ]
	$(RUN) ./bootstrap.sh $(CONFIGURE_ARGS)
	echo "using gcc : `$(TC_PATH)$(TC_PREFIX)gcc -dumpversion` : $(TC_PATH)$(TC_PREFIX)g++ : <cflags>\"$(CFLAGS)\" <cxxflags>\"$(CPPFLAGS)\" <linkflags>\"$(LDFLAGS)\" ; " > $(WORK_DIR)/$(PKG_DIR)/tools/build/v2/user-config.jam
	echo "project : requirements <cxxflags>$(OFLAGS) ;" >> $(WORK_DIR)/$(PKG_DIR)/tools/build/v2/user-config.jam

.PHONY: myCompile
myCompile:
	$(RUN) ./b2

.PHONY: myInstall
myInstall:
	$(RUN) ./b2 install
