PKG_NAME = boxbackup
PKG_VERS = 0.11.1
PKG_EXT = tgz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.boxbackup.org/export/3180/box/packages
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl cross/readline cross/berkeleydb

HOMEPAGE = http://www.boxbackup.org/
COMMENT  = Box Backup is an open source, completely automatic, on-line backup system
LICENSE  = BSD/GPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-random=/dev/urandom --enable-gnu-readline box_cv_have_large_file_support=yes

INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) install-backup-client DESTDIR=$(INSTALL_DIR)
	$(RUN) $(MAKE) install-backup-server DESTDIR=$(INSTALL_DIR)
