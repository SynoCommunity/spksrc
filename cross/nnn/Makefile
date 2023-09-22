PKG_NAME = nnn
PKG_VERS = 4.8
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/jarun/nnn/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# REMARKGS:
# currently stay on version 4.8
# version 4.9 fails with the error for all DSM 6 (even 64 bit):
# error "<fts.h> cannot be used with -D_FILE_OFFSET_BITS==64"
# we will have to decide whether we 
# - fall back to version 4.0 for all packages with DSM < 7
# - keep nnn version 4.8 for DSM 6 and x64, x86 and aarch64
# - patch version > 4.8 for DSM 6 and x64, x86 and aarch64 to remove the definition of _FILE_OFFSET_BITS==64
#   (but we have to verify that 64 bit/largefile support is working when built without -D_FILE_OFFSET_BITS==64)
# 

DEPENDS = cross/ncursesw cross/readline

# compiler too old (-std=c11 required)
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS)

# 32 bit archs require DSM >= 7
# error "<fts.h> cannot be used with -D_FILE_OFFSET_BITS==64"
include ../../mk/spksrc.common.mk
ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
UNSUPPORTED_ARCHS += $(32bit_ARCHS)
else
# comcerto2k is not even supported on DSM>=7
UNSUPPORTED_ARCHS += comcerto2k
endif

HOMEPAGE = https://github.com/jarun/nnn
COMMENT  = n³ The unorthodox terminal file manager.
LICENSE  = 2-clause BSD

CONFIGURE_TARGET = nop
INSTALL_MAKE_OPTIONS = install DESTDIR=$(INSTALL_DIR) PREFIX=$(INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk
