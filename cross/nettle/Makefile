PKG_NAME = nettle
PKG_VERS = 3.9.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/nettle
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/gmp

HOMEPAGE = https://www.lysator.liu.se/~nisse/nettle/
COMMENT  = Nettle is a cryptographic library that is designed to fit easily in more or less any context.
LICENSE  = LGPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static

include ../../mk/spksrc.common.mk
ifeq ($(call version_lt,${TCVERSION},6.0)$(call version_gt,${TCVERSION},2.0),11) 
# older compilers to not support x86/x64 assembler code
CONFIGURE_ARGS += --disable-assembler
endif

include ../../mk/spksrc.cross-cc.mk
