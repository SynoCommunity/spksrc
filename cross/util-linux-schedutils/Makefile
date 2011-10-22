
PKG_NAME = util-linux-schedutils
PKG_VERS = 2.20
PKG_EXT = tar.bz2
PKG_DIST_NAME = util-linux-$(PKG_VERS).$(PKG_EXT)
#PKG_DIST_SITE = ftp://ftp.kernel.org/pub/linux/utils/util-linux
PKG_DIST_SITE = http://mirror.be.gbxs.net/pub/linux/utils/util-linux/v$(PKG_VERS)
PKG_DIR = util-linux-$(PKG_VERS)

DEPENDS = 

MAINTAINER=	superzebulon@superzebulon.org
HOMEPAGE=	http://kernel.org/~kzak/util-linux/
COMMENT=	Random collection of Linux utilities
LICENSE=	GPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-nls --disable-shared --without-ncurses \
                 --disable-use-tty-group --disable-makeinstall-chown \
                 --disable-makeinstall-setuid

COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

myCompile:
	$(RUN) make -C schedutils

myInstall:
	$(RUN) make -C schedutils install prefix=$(STAGING_INSTALL_PREFIX)
