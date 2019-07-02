PKG_NAME = openssh
PKG_VERS = 5.9p1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.fr.openbsd.org/pub/OpenBSD/OpenSSH/portable
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/openssl

HOMEPAGE = http://www.openssh.com/
COMMENT  = Open source version of SSH connectivity tools
LICENSE  =

CONFIGURE_ARGS += cross_compiling=yes --disable-lastlog --disable-utmp --disable-utmpx --disable-wtmp --disable-wtmpx
CONFIGURE_ARGS += --disable-strip LD=$$CC

include ../../mk/spksrc.cross-cc.mk
