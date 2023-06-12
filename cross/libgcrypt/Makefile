PKG_NAME = libgcrypt
PKG_VERS = 1.10.2
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gnupg.org/ftp/gcrypt/libgcrypt
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libgpg-error

HOMEPAGE = https://gnupg.org/related_software/libgcrypt/
COMMENT  = This is a general purpose cryptographic library based on the code from GnuPG.
LICENSE  = LGPLv2.1+

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --with-gpg-error-prefix=$(STAGING_INSTALL_PREFIX)

# error "The CPU Jitter random number generator must not be compiled with optimizations. 
# See documentation. Use the compiler switch -O0 for compiling jitterentropy.c.
ADDITIONAL_CPPFLAGS = -O
CONFIGURE_ARGS += --disable-jent-support

include ../../mk/spksrc.cross-cc.mk

# key generation fails on DSM 6 for aarch64 (#5150)
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
ifeq ($(call version_lt, ${TC_GCC}, 5.0),1)
CONFIGURE_ARGS += --disable-arm-crypto-support
endif
endif
