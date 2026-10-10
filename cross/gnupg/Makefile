PKG_NAME = gnupg
PKG_VERS = 2.5.24
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gnupg.org/ftp/gcrypt/gnupg
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS  = cross/libgpg-error
DEPENDS += cross/libgcrypt
DEPENDS += cross/gnutls
DEPENDS += cross/libassuan
DEPENDS += cross/libksba
DEPENDS += cross/npth
DEPENDS += cross/pinentry
DEPENDS += cross/bzip2

HOMEPAGE = https://www.gnupg.org/
COMMENT  = GnuPG allows to encrypt and sign your data and communication, features a versatile key management system as well as access modules for all kinds of public key directories.
LICENSE  = GPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-libgpg-error-prefix=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-libgcrypt-prefix=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-libassuan-prefix=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-libksba-prefix=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-npth-prefix=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += GPGRT_CONFIG=$(STAGING_INSTALL_PREFIX)/bin/gpgrt-config
# Docs are not packaged (PLIST); 2.5 no longer ships prebuilt man pages and
# generating them needs yat2m, unavailable when cross-compiling.
CONFIGURE_ARGS += --disable-doc

ADDITIONAL_CPPFLAGS = -O

include ../../mk/spksrc.common.mk

ifeq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
# kernel before 2.6.36 do not support inotify
CONFIGURE_ARGS += ac_cv_func_inotify_init=no
endif

include ../../mk/spksrc.cross-cc.mk
