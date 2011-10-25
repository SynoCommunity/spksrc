

PKG_NAME = openssh
PKG_VERS = 5.9p1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.fr.openbsd.org/pub/OpenBSD/OpenSSH/portable/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/openssl

MAINTAINER=	packages@packages.nas-forum.com
HOMEPAGE=	http://www.openssh.com/
COMMENT=	Open source version of SSH connectivity tools
LICENSE=	

GNU_CONFIGURE = 
CONFIGURE_ARGS = 	--disable-lastlog --disable-utmp \
						--disable-utmpx --disable-wtmp --disable-wtmpx \
 						--with-zlib=$(STAGING_INSTALL_PREFIX) \
                 	--with-ssl-dir=$(STAGING_INSTALL_PREFIX)

INSTALL_PREFIX  = /usr/local/$(PKG_NAME)

include ../../mk/spksrc.cross-cc.mk

