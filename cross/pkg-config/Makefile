PKG_NAME = pkg-config
PKG_VERS = 0.29.1
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_SITE = http://pkg-config.freedesktop.org/releases
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)

DEPENDS =

HOMEPAGE = https://www.freedesktop.org/wiki/Software/pkg-config/
COMMENT  = pkg-config is a helper tool used when compiling applications and libraries.
LICENSE  = GPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-internal-glib glib_cv_long_long_format=ll glib_cv_stack_grows=no glib_cv_uscore=no ac_cv_func_posix_getpwuid_r=yes ac_cv_func_posix_getgrgid_r=yes

include ../../mk/spksrc.cross-cc.mk
