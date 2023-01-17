PKG_NAME = museek+
PKG_VERS = 0.2
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/museek-plus/museek-plus/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libxml++ cross/libevent

HOMEPAGE = http://www.museek-plus.org/
COMMENT  = Museek+ is a GPL licensed file-sharing application for the ​Soulseek peer-to-peer network
LICENSE  = 

CONFIGURE_TARGET = myConfigure
INSTALL_TARGET = myInstall
ENV += CMAKE_INCLUDE_PATH="$(STAGING_INSTALL_PREFIX)/include" CMAKE_LIBRARY_PATH="$(STAGING_INSTALL_PREFIX)/lib"

include ../../mk/spksrc.cross-cc.mk

.PHONY: myConfigure
myConfigure:
	$(RUN) cmake CMakeLists.txt -DPREFIX=$(INSTALL_PREFIX) -DMANDIR=no -DCMAKE_BUILD_TYPE=Release -DNO_SETUP=1 -DNO_PYMUCIPHER=1 -DNO_MUSEEQ=1

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)
