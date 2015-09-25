PKG_NAME = darkstat
PKG_VERS = 3.0.719
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://unix4lyfe.org/darkstat
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/libpcap

HOMEPAGE = http://unix4lyfe.org/darkstat
COMMENT  = Captures network traffic, calculates statistics about usage, and serves reports over HTTP
LICENSE  =

ENV += HOSTCC=gcc HOSTCFLAGS=
GNU_CONFIGURE = 1


include ../../mk/spksrc.cross-cc.mk
