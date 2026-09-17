PKG_NAME = docopt.cpp
PKG_VERS = 0.6.2
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/docopt/docopt.cpp/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# C++ 11 required
MIN_GCC_VERSION = 4.9

HOMEPAGE = https://github.com/docopt/docopt.cpp
COMMENT = C++11 port of docopt, C++ command line argument parser.
LICENSE = BSL-1.0 and MIT

POST_INSTALL_TARGET = docopt_post_install

include ../../mk/spksrc.cross-cmake.mk

.PHONY: docopt_post_install
docopt_post_install:
	@$(MSG) Create pkgconfig file
	@install -d $(STAGING_INSTALL_PREFIX)/lib/pkgconfig
	@( \
		echo "prefix=$(STAGING_INSTALL_PREFIX)"; \
		echo "exec_prefix=\$${prefix}"; \
		echo "libdir=\$${exec_prefix}/lib"; \
		echo "includedir=\$${prefix}/include"; \
		echo ""; \
		echo "Name: docopt"; \
		echo "Description: C++ command line argument parser"; \
		echo "Version: $(PKG_VERS)"; \
		echo ""; \
		echo "Requires:"; \
		echo "Libs: -L\$${libdir} -ldocopt"; \
		echo "Cflags: -I\$${includedir}"; \
	) > $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/docopt.pc
