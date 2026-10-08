PKG_NAME = nettle
PKG_VERS = 4.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/nettle
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/gmp

# Floor aligns with gnutls-latest (gcc >= 4.9), not nettle's own C11 floor (gcc >= 4.7):
# the frozen gnutls-3.7 line has no nettle-4 support, so arches it serves (gcc < 4.9)
# must resolve here to 3.10 as well, or 3.7 would meet nettle 4 (e.g. x64-5.2).
MIN_GCC_VERSION = 4.9

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

ADDITIONAL_CFLAGS = -O2

include ../../mk/spksrc.cross-cc.mk
