PKG_NAME = gnupg
PKG_VERS = 2.2.27
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gnupg.org/ftp/gcrypt/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS  = cross/libgpg-error cross/libgcrypt cross/gnutls cross/libassuan
DEPENDS += cross/libksba cross/npth cross/pinentry

HOMEPAGE = https://www.gnupg.org/
COMMENT  = GnuPG allows to encrypt and sign your data and communication, features a versatile key management system as well as access modules for all kinds of public key directories.
LICENSE  = GPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-gpg-error-prefix=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-libgcrypt-prefix=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-libassuan-prefix=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-ksba-prefix=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-npth-prefix=$(STAGING_INSTALL_PREFIX)

ADDITIONAL_CPPFLAGS = -O

include ../../mk/spksrc.archs.mk

ifeq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
# kernel before 2.6.36 do not support inotify
CONFIGURE_ARGS += ac_cv_func_inotify_init=no
endif

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
# use clock_gettime of librt
ADDITIONAL_LDFLAGS = -lrt
endif

include ../../mk/spksrc.cross-cc.mk
