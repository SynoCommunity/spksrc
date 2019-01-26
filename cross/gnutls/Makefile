PKG_NAME = gnutls
PKG_VERS_SHORT = 3.6
PKG_VERS = $(PKG_VERS_SHORT).4
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.gnupg.org/ftp/gcrypt/$(PKG_NAME)/v$(PKG_VERS_SHORT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libunistring cross/libtasn1 cross/nettle cross/zlib

HOMEPAGE = http://www.gnu.org/software/gnutls/
COMMENT  = GnuTLS is a secure communications library implementing the SSL, TLS and DTLS protocols and technologies around them
LICENSE  = LGPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-doc --without-p11-kit --disable-nls gl_cv_func_gettimeofday_clobber=no gl_cv_func_signbit_gcc=no
CONFIGURE_ARGS += --prefix=$(INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk
