PKG_NAME = libgcrypt
PKG_VERS = 1.12.4
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gnupg.org/ftp/gcrypt/libgcrypt
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libgpg-error

HOMEPAGE = https://gnupg.org/related_software/libgcrypt/
COMMENT  = This is a general purpose cryptographic library based on the code from GnuPG.
LICENSE  = LGPLv2.1+

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --with-libgpg-error-prefix=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --disable-doc

# error "The CPU Jitter random number generator must not be compiled with optimizations. 
# See documentation. Use the compiler switch -O0 for compiling jitterentropy.c.
#CONFIGURE_ARGS += --disable-jent-support

# use -O0 (disable optimization) or -O3 
# otherwise builds for 32-bit intel (i686, evansport) will fail with asm code
# ec-inline.h:666:5: error: 'asm' operand has impossible constraints
ADDITIONAL_CFLAGS = -O3

include ../../mk/spksrc.common.mk

# avoid key generation failure for aarch64 (#5150)
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --disable-arm-crypto-support
endif
# libgcrypt 1.12 builds crc-intel-pclmul.c with EVEX vpclmulqdq forms that
# binutils paired with gcc < 7 cannot assemble (4.7.3/4.9.3 fail, 7.5+ OK);
# upstream's configure probe only tests a VEX form and misses it.
ifeq ($(call version_lt,$(TC_GCC),7),1)
CONFIGURE_ARGS += --disable-pclmul-support
endif

include ../../mk/spksrc.cross-cc.mk

