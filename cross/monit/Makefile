PKG_NAME = monit
PKG_VERS = 5.17.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://mmonit.com/monit/dist
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl

HOMEPAGE = http://mmonit.com/monit/
COMMENT  = Monit is a small Open Source utility for managing and monitoring Unix systems. Monit conducts automatic maintenance and repair and can execute meaningful causal actions in error situations.
LICENSE  = AGPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --without-pam libmonit_cv_setjmp_available=yes libmonit_cv_vsnprintf_c99_conformant=yes --with-ssl-incl-dir=$(STAGING_INSTALL_PREFIX)/include

include ../../mk/spksrc.cross-cc.mk
