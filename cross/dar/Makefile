PKG_NAME = dar
PKG_VERS = 2.8.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/dar/files/dar/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# error: C++ compiler lack support for c++14 standard
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(OLD_PPC_ARCHS)

DEPENDS  = cross/attr
DEPENDS += cross/argon2
DEPENDS += cross/libgcrypt
DEPENDS += cross/gpgme
DEPENDS += cross/zlib
DEPENDS += cross/bzip2
DEPENDS += cross/lzo
DEPENDS += cross/lz4
DEPENDS += cross/xz
DEPENDS += cross/zstd
DEPENDS += cross/e2fsprogs
DEPENDS += cross/librsync
DEPENDS += cross/curl
DEPENDS += cross/libthreadar
DEPENDS += cross/libssh

HOMEPAGE = http://dar.linux.free.fr/
COMMENT = Disk ARchive - dar is a shell command that backs up from a single file to a whole filesystems, taking care of hard links, Extended Attributes, sparse files, etc.
LICENSE = GPLv3

POST_INSTALL_TARGET = dar_post_install
GNU_CONFIGURE = 1

CONFIGURE_ARGS  = --enable-mode=64
CONFIGURE_ARGS += --disable-static
CONFIGURE_ARGS += --disable-dar-static
CONFIGURE_ARGS += --disable-upx
CONFIGURE_ARGS += --disable-python-binding
CONFIGURE_ARGS += --with-gpgme-prefix=$(STAGING_INSTALL_PREFIX)

ADDITIONAL_CPPFLAGS = -O

include ../../mk/spksrc.cross-cc.mk

.PHONY: dar_post_install
dar_post_install:
	@$(MSG) Install sample config file
	@install -d -m 744 $(STAGING_INSTALL_PREFIX)/var
	@sed -e 's|SOMEPATH|$(INSTALL_PREFIX_VAR)|g' $(WORK_DIR)/$(PKG_DIR)/doc/samples/etc_darrc > $(STAGING_INSTALL_PREFIX)/etc/darrc
