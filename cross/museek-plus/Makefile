PKG_NAME = museek-plus
ORIGINAL_NAME = museek+
PKG_VERS = 0.2
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(ORIGINAL_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/$(PKG_NAME)/$(PKG_NAME)/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libxml++ cross/libevent

HOMEPAGE = http://www.museek-plus.org/
COMMENT  = Museek+ is a GPL licensed file-sharing application for the ​Soulseek peer-to-peer network.
LICENSE  = GPLv2

POST_EXTRACT_TARGET = museek-plus_post_extract
CONFIGURE_TARGET = museek-plus_configure
INSTALL_TARGET = museek-plus_install
ENV += CMAKE_INCLUDE_PATH="$(STAGING_INSTALL_PREFIX)/include" CMAKE_LIBRARY_PATH="$(STAGING_INSTALL_PREFIX)/lib"

include ../../mk/spksrc.cross-cc.mk

.PHONY: museek-plus_post_extract
# rename from museek+ to museek-plus to avoid build problems with '+' in path.
museek-plus_post_extract:
	mv $(WORK_DIR)/$(ORIGINAL_NAME)-$(PKG_VERS) $(WORK_DIR)/$(PKG_DIR)

.PHONY: museek-plus_configure
museek-plus_configure:
	$(RUN) cmake CMakeLists.txt -DPREFIX=$(INSTALL_PREFIX) -DMANDIR=no -DCMAKE_BUILD_TYPE=Release -DNO_SETUP=1 -DNO_PYMUCIPHER=1 -DNO_MUSEEQ=1

.PHONY: museek-plus_install
museek-plus_install:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)
