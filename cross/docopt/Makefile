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

DOCOPT_PC = $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/docopt.pc
POST_INSTALL_TARGET = $(DOCOPT_PC)

include ../../mk/spksrc.cross-cmake.mk

$(DOCOPT_PC):
	@$(MSG) - Creating pkgconfig $(notdir $@)
	@install -d $(dir $@)
	@printf 'prefix=$(INSTALL_PREFIX)\n' > $@
	@printf 'exec_prefix=$${prefix}\n' >> $@
	@printf 'libdir=$${exec_prefix}/lib\n' >> $@
	@printf 'includedir=$${prefix}/include\n' >> $@
	@printf '\n' >> $@
	@printf 'Name: docopt\n' >> $@
	@printf 'Description: C++ command line argument parser\n' >> $@
	@printf 'Version: $(PKG_VERS)\n' >> $@
	@printf '\n' >> $@
	@printf 'Requires:\n' >> $@
	@printf 'Cflags: -I$${includedir}\n' >> $@
	@printf 'Libs: -L\$${libdir} -ldocopt\n' >> $@
