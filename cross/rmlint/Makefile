PKG_NAME = rmlint
PKG_VERS = 2.10.3
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/sahib/rmlint/archive
PKG_DIST_FILE=$(PKG_NAME)-v$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/glib
# libblkid required to "Optimize non-rotational disks"
DEPENDS += cross/libblkid
# libelf required to "Find non-stripped binaries"
DEPENDS += cross/libelf
# json-glib required to "Read json caches"
DEPENDS += cross/json-glib

HOMEPAGE = https://rmlint.readthedocs.io
COMMENT = rmlint finds space waste and other broken things on your filesystem and offers to remove it.
LICENSE = GPLv3

# rmlint needs glib >= 2.64, i.e. cross/glib-2.66, which itself needs gcc 4.6;
# below that the glib virtual can only offer 2.58:
#   Checking for glib-2.0 >= 2.64... Error: glib-2.0 >= 2.64 not found.
MIN_GCC_VERSION = 4.6

CONFIGURE_TARGET = nop
COMPILE_TARGET = rmlint_compile
INSTALL_TARGET = rmlint_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: rmlint_compile rmlint_install
rmlint_compile:
	@$(RUN) scons config --prefix=$(INSTALL_PREFIX) VERBOSE=0 DEBUG=0 O=release
	@$(RUN) scons --prefix=$(INSTALL_PREFIX) VERBOSE=0 DEBUG=0 O=release

rmlint_install:
	@$(RUN) install --mode=755 --target-directory=$(STAGING_INSTALL_PREFIX)/bin/ ./rmlint
