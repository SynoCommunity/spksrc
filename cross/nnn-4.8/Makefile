PKG_NAME = nnn
PKG_VERS = 4.8
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/jarun/nnn/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# REMARKS:
# nnn version 4.0 is the latest version for 32-bit archs on DSM 6 and for comcerto2k
# nnn version 4.8 is the latest version for 64-bit archs on DSM 6
# later versions fail with the following error for all DSM 6 (even 64 bit):
# error "<fts.h> cannot be used with -D_FILE_OFFSET_BITS==64"

# All DSM 6 toolchains (and DSM 7 of comcerto2k) have identical fts.h file (usr/inluce/fts.h) with this guard:
#  /* The fts interface is incompatible with the LFS interface which
#     transparently uses the 64-bit file access functions.  */
#  #ifdef __USE_FILE_OFFSET64
#  # error "<fts.h> cannot be used with -D_FILE_OFFSET_BITS==64"
#  #endif

DEPENDS = cross/ncursesw cross/readline

# compiler too old (-std=c11 required)
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)
# comcerto2k is not supported on DSM 6 and DSM 7
UNSUPPORTED_ARCHS += comcerto2k

# 32 bit archs require DSM >= 7
include ../../mk/spksrc.common.mk
ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
UNSUPPORTED_ARCHS += $(32bit_ARCHS)
endif

HOMEPAGE = https://github.com/jarun/nnn
COMMENT  = n³ The unorthodox terminal file manager.
LICENSE  = 2-clause BSD

CONFIGURE_TARGET = nop
INSTALL_MAKE_OPTIONS = install DESTDIR=$(INSTALL_DIR) PREFIX=$(INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk
