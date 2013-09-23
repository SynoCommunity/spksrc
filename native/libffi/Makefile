PKG_NAME = libffi
PKG_VERS = 3.0.11
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://sourceware.org/pub/$(PKG_NAME)

DEPENDS =

HOMEPAGE = http://sourceware.org/libffi/
COMMENT  = A Portable Foreign Function Interface Library
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --prefix=${WORK_DIR}/${TC_BASE_DIR}/native

PRE_CONFIGURE_TARGET = myPreConfigure
COMPILE_TARGET = myCompile
#INSTALL_TARGET = myInstall

include ../../mk/spksrc.native-cc.mk

.PHONY: myPreConfigure
myPreConfigure:
	$(RUN) aclocal
	$(RUN) automake

.PHONY: myCompile
myCompile:
	$(RUN) make
	$(RUN) make install

