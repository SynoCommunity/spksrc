PKG_NAME = sysstat
PKG_VERS = 11.3.5
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://pagesperso-orange.fr/sebastien.godard/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://sebastien.godard.pagesperso-orange.fr/
COMMENT  = The sysstat utilities are a collection of performance monitoring tools for Linux.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-nls --disable-man-group --enable-collect-all
ENV += sa_dir=${INSTALL_PREFIX}/var/log/sa
ENV += conf_dir=${INSTALL_PREFIX}/etc/sysstat
ENV += rcdir=${INSTALL_PREFIX}/etc

include ../../mk/spksrc.cross-cc.mk
