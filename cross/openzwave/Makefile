PKG_NAME = openzwave
PKG_VERS = 1.6.1914
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://old.openzwave.com/downloads
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://www.openzwave.net
COMMENT  = C++ library to control Z-Wave Networks via a USB Z-Wave Controller.
LICENSE  = LGPLv3

CONFIGURE_TARGET = nop
INSTALL_TARGET = openzwave_install
POST_INSTALL_TARGET = openzwave_post_install

ENV += CROSS_COMPILE=$(TC_PATH)$(TC_PREFIX)

include ../../mk/spksrc.cross-cc.mk

.PHONY: openzwave_install
# workaround for the non gnu standard usage of pkgconfig
# as the owner is not willing to fix this
# see https://github.com/OpenZWave/open-zwave/issues/1416
openzwave_install:
	$(RUN) $(MAKE) DESTDIR=$(INSTALL_DIR) install PREFIX=$(INSTALL_PREFIX) instlibdir=$(INSTALL_PREFIX)/lib pkgconfigdir=$(INSTALL_PREFIX)/lib/pkgconfig

.PHONY: openzwave_post_install
# patch includes as some compilers fail to work with the include folder structure of openzwave
# (use hardcoded list of referenced header files in base folder to avoid too large sed expression size)
openzwave_post_install:
	sed -e 's|\(#include "\)\([^.].*/\)|\1../\2|g' -i $(INSTALL_DIR)/$(INSTALL_PREFIX)/include/openzwave/*/*.h
	sed -e 's|\(#include "\)\([^.].*/\)|\1../../\2|g' -i $(INSTALL_DIR)/$(INSTALL_PREFIX)/include/openzwave/*/*/*.h
	sed -e 's%\(#include \"\)\(Bitfield\.h\|CompatOptionManager\.h\|Defs\.h\|Driver\.h\|TimerThread\.h\|ValueIDIndexes\.h\)%\1../\2%g' -i $(INSTALL_DIR)/$(INSTALL_PREFIX)/include/openzwave/*/*.h
