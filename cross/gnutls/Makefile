PKG_NAME = gnutls
PKG_VERS_SHORT = 3.2
PKG_VERS = $(PKG_VERS_SHORT).17
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.gnutls.org/gcrypt/$(PKG_NAME)/v$(PKG_VERS_SHORT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/nettle cross/zlib

HOMEPAGE = http://www.gnu.org/software/gnutls/
COMMENT  = GnuTLS is a secure communications library implementing the SSL, TLS and DTLS protocols and technologies around them
LICENSE  = LGPL

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

CONFIGURE_ARGS = --disable-nls gl_cv_func_gettimeofday_clobber=no gl_cv_func_signbit_gcc=no
ifeq ($(findstring $(ARCH),$(ARM5_ARCHES)),$(ARCH))
CONFIGURE_ARGS += gl_cv_socket_ipv6=no
endif

