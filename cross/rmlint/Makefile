PKG_NAME = rmlint
PKG_VERS = 2.9.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/sahib/rmlint/archive
PKG_DIST_FILE=$(PKG_NAME)-v$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/glib

HOMEPAGE = http://rmlint.rtfd.org/
COMMENT = Extremely fast tool to remove duplicates and other lint from your filesystem.
LICENSE = GPLv3

# PPC_ARCHES except QorIQ are not supported
UNSUPPORTED_ARCHS = powerpc ppc824x ppc853x ppc854x

CONFIGURE_TARGET = none
COMPILE_TARGET = rmlint_compile_target
INSTALL_TARGET = rmlint_install_target

include ../../mk/spksrc.cross-cc.mk

.PHONY: rmlint_compile_target rmlint_install_target
rmlint_compile_target:
	$(RUN) scons prefix=${STAGING_INSTALL_PREFIX} actual_prefix=$(INSTALL_PREFIX) VERBOSE=0 DEBUG=0 O=release

rmlint_install_target:
	$(RUN) install --mode=755 --target-directory=${STAGING_INSTALL_PREFIX}/bin/ ./rmlint
