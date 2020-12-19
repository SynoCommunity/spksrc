PKG_NAME = rmlint
PKG_VERS = 2.10.1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/sahib/rmlint/archive
PKG_DIST_FILE=$(PKG_NAME)-v$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/glib

HOMEPAGE = https://rmlint.readthedocs.io
COMMENT = rmlint finds space waste and other broken things on your filesystem and offers to remove it.
LICENSE = GPLv3

# PPC archs except QorIQ are not supported
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

CONFIGURE_TARGET = nop
COMPILE_TARGET = rmlint_compile
INSTALL_TARGET = rmlint_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: rmlint_compile rmlint_install
rmlint_compile:
	$(RUN) scons config --prefix=${INSTALL_PREFIX} VERBOSE=0 DEBUG=0 O=release
	$(RUN) scons --prefix=${INSTALL_PREFIX} VERBOSE=0 DEBUG=0 O=release

rmlint_install:
	$(RUN) install --mode=755 --target-directory=${INSTALL_DIR}${INSTALL_PREFIX}/bin/ ./rmlint
