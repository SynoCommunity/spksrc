PKG_NAME = nnn
PKG_VERS = 4.8
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/jarun/nnn/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncursesw cross/readline

# REMARKS:
# nnn version 4.8 is the latest version for 64-bit archs on DSM 6
# 32-bit archs fail with the following error with 32-bit DSM 6 and comcerto2k toolchains:
# error "<fts.h> cannot be used with -D_FILE_OFFSET_BITS==64"
# 
# REASON:
# on 32-bit platforms fts needs glibc >= 2.23 to support 64-bit file offsets (i.e. files > 2GB)

# compiler too old (-std=c11 required)
MIN_GCC_VERSION = 4.6

# 32 bit archs require glibc >= 2.23 (includes comcerto2k on DSM 7)
include ../../mk/spksrc.common.mk
ifeq ($(call version_lt, $(TC_GLIBC), 2.23),1)
UNSUPPORTED_ARCHS = $(32bit_ARCHS)
endif

HOMEPAGE = https://github.com/jarun/nnn
COMMENT  = n³ The unorthodox terminal file manager.
LICENSE  = 2-clause BSD

CONFIGURE_TARGET = nop
INSTALL_ARGS = install DESTDIR=$(INSTALL_DIR) PREFIX=$(INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk
