PKG_NAME = gnutls
PKG_VERS = 3.0.19
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.gnu.org/gnu/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/nettle

HOMEPAGE = http://www.gnu.org/software/gnutls/
COMMENT  = GnuTLS is a secure communications library implementing the SSL, TLS and DTLS protocols and technologies around them
LICENSE  = LGPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS = gl_cv_func_gettimeofday_clobber=no


include ../../mk/spksrc.cross-cc.mk

