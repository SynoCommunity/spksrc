PKG_NAME = rnm
PKG_VERS = 4.0.9
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/neurobin/rnm/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/jpcre2 cross/gmp

# C++11: configure stops on gcc 4.7.3 and older ("A compiler with support for C++11
# language features is required").
MIN_GCC_VERSION = 4.8

HOMEPAGE = https://neurobin.org/projects/softwares/unix/rnm/
COMMENT = rnm renames files/directories in bulk. Naming scheme (Name String) can be applied or regex replace can be performed to modify file names on the fly. It uses PCRE2 (revised version of PCRE) regex to provide search (and replace) functionality.
LICENSE = GPL v3.0

GNU_CONFIGURE = 1

PRE_CONFIGURE_TARGET = rnm_pre_configure

include ../../mk/spksrc.cross-cc.mk


.PHONY: rnm_pre_configure
rnm_pre_configure:
	@$(RUN) ./autogen.sh
