PKG_NAME = rnm
PKG_VERS = 4.0.9
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/neurobin/rnm/archive
PKG_DIST_FILE=$(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/jpcre2 cross/gmp

HOMEPAGE = https://neurobin.org/projects/softwares/unix/rnm/
COMMENT = rnm renames files/directories in bulk. Naming scheme (Name String) can be applied or regex replace can be performed to modify file names on the fly. It uses PCRE2 (revised version of PCRE) regex to provide search (and replace) functionality.
LICENSE = GPL v3.0

GNU_CONFIGURE = 1

PRE_CONFIGURE_TARGET = rnm_pre_configure

include ../../mk/spksrc.cross-cc.mk

# requires gnu GCC >= 4.8
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

.PHONY: rnm_pre_configure
rnm_pre_configure:
	$(RUN) ./autogen.sh
