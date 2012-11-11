PKG_NAME = boost
PKG_VERS = 1.52.0
PKG_EXT = tar.bz2
PKG_DIR = $(PKG_NAME)_$(subst .,_,$(PKG_VERS))
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://sourceforge.net/projects/$(PKG_NAME)/files/$(PKG_NAME)/$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://www.boost.org/
COMMENT  = Boost provides free peer-reviewed portable C++ source libraries.
LICENSE  = http://www.boost.org/LICENSE_1_0.txt

CONFIGURE_TARGET = myConfigure
COMPILE_TARGET = myCompile
GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

.PHONY: myConfigure
myConfigure:
	$(RUN) ./bootstrap.sh
	echo "using gcc : `$(TC_PATH)$(TC_PREFIX)gcc -dumpversion` : $(TC_PATH)$(TC_PREFIX)g++ ; " > $(WORK_DIR)/$(PKG_DIR)/tools/build/v2/user-config.jam

.PHONY: myCompile
myCompile:
	$(RUN) ./b2 -d+2 --toolset=gcc --without-mpi --prefix=$(STAGING_INSTALL_PREFIX) install
