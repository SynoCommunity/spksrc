PKG_NAME = demometa-python-cmake
PKG_VERS = 1.0.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/SynoCommunity/spksrc
COMMENT  = Meta cross-dependency test (cmake channel): resolves python-meta libs (libzstd, sqlite3) via pkg-config
LICENSE  = MIT

PRE_DOWNLOAD_TARGET = demometa_python_cmake_create_tarball
CHECKSUM_TARGET = nop

include ../../mk/spksrc.cross-cmake.mk

.PHONY: demometa_python_cmake_create_tarball
demometa_python_cmake_create_tarball:
	@$(MSG) Creating source tarball for $(PKG_NAME)
	@mkdir -p $(DISTRIB_DIR)
	@if [ ! -f "$(DISTRIB_DIR)/$(PKG_DIST_NAME)" ]; then \
		rm -rf /tmp/$(PKG_NAME)-$(PKG_VERS) && \
		cp -r $(CURDIR)/src /tmp/$(PKG_NAME)-$(PKG_VERS) && \
		(cd /tmp && tar czf $(DISTRIB_DIR)/$(PKG_DIST_NAME) $(PKG_NAME)-$(PKG_VERS)) && \
		rm -rf /tmp/$(PKG_NAME)-$(PKG_VERS); \
	fi
