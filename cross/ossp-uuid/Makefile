PKG_NAME = ossp-uuid
PKG_VERS = 1.6.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)_$(PKG_VERS).orig.$(PKG_EXT)
PKG_DIST_SITE = https://deb.debian.org/debian/pool/main/o/ossp-uuid
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-UUID_$(subst .,_,$(PKG_VERS))

DEPENDS = cross/openssl3

HOMEPAGE = http://www.ossp.org/pkg/lib/uuid/
COMMENT  = OSSP UUID is a ISO-C:1999 API for generating unique identifiers.
LICENSE  = MIT

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-shared --enable-static --with-pic
CONFIGURE_ARGS += LIBS="-lcrypto"
ENV += ac_cv_func_SHA1Final=yes
# Disable getentropy detection (requires kernel 3.17+). Braswell uses kernel
# 3.10 where the getrandom syscall is unavailable. Fall back to /dev/urandom.
ENV += ac_cv_func_getentropy=no
PRE_CONFIGURE_TARGET = ossp_uuid_pre_configure

include ../../mk/spksrc.cross-cc.mk

.PHONY: ossp_uuid_pre_configure
ossp_uuid_pre_configure:
	cd $(WORK_DIR)/$(PKG_DIR) && autoreconf -fi
