
PKG_NAME = util-linux
PKG_VERS = 2.20
PKG_EXT = tar.bz2
PKG_REV = 1
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
#PKG_DIST_SITE = ftp://ftp.kernel.org/pub/linux/utils/$(PKG_NAME)
PKG_DIST_SITE = http://mirror.be.gbxs.net/pub/linux/utils/$(PKG_NAME)/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

MAINTAINER=	superzebulon@superzebulon.org
HOMEPAGE=	http://kernel.org/~kzak/util-linux/
COMMENT=	Random collection of Linux utilities
LICENSE=	GPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-nls --disable-shared --without-ncurses \
                 --disable-use-tty-group --disable-makeinstall-chown \
                 --disable-makeinstall-setuid

include ../../mk/spksrc.cross-cc.mk
