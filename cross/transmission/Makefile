

PKG_NAME = transmission
PKG_VERS = 2.42
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://download.transmissionbt.com/files
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/openssl cross/curl cross/libevent

MAINTAINER = superzebulon@superzebulon.org
HOMEPAGE   = http://www.transmissionbt.com/
COMMENT    = A Fast, Easy, and Free BitTorrent Client
LICENSE    =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = ac_cv_prog_cxx_g=no ac_cv_prog_cc_g=no \
                 --enable-daemon --disable-gtk --disable-nls\
                 --with-zlib=$(STAGING_INSTALL_PREFIX)

INSTALL_PREFIX  = /usr/local/transmission

include ../../mk/spksrc.cross-cc.mk
