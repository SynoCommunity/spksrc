PKG_NAME = less
PKG_VERS = 481
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.gnu.org/gnu/less/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncursesw

HOMEPAGE = https://www.gnu.org/software/less/
COMMENT  = Less is a terminal pager.
LICENSE  = GPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-ncursesw=ncursesw --with-regex=gnu

INSTALL_TARGET = myInstall
POST_INSTALL_TARGET = myPostInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)
