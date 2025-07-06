PKG_NAME = monit
PKG_VERS = 5.34.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://mmonit.com/monit/dist
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl3

UNSUPPORTED_ARCHS = $(PPC_ARCHS)

HOMEPAGE = https://mmonit.com/monit/
COMMENT  = Monit is a small Open Source utility for managing and monitoring Unix systems. Monit conducts automatic maintenance and repair and can execute meaningful causal actions in error situations.
LICENSE  = AGPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS += --with-ssl-dir=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-zlib=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --without-pam
CONFIGURE_ARGS += --disable-static
CONFIGURE_ARGS += --enable-optimized

include ../../mk/spksrc.cross-cc.mk
