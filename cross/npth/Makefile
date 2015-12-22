PKG_NAME = npth
PKG_VERS = 1.2
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.gnupg.org/gcrypt/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/gnutls

HOMEPAGE = http://gnupg.org
COMMENT  = nPth is the New GNU Portable Threads Library. This is a library to provide the GNU Pth API and thus a non-preemptive threads implementation.
LICENSE  = LGPL

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
