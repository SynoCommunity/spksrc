PKG_NAME = BoxBackup
PKG_VERS = 0.12
PKG_VERS_DATE = 200326
PKG_VERS_BRANCH = master
PKG_VERS_COMMIT = 8e8b63c
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_VERS_BRANCH).$(PKG_VERS_DATE).$(PKG_VERS_COMMIT).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/boxbackup/boxbackup/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = boxbackup-$(PKG_NAME)-$(PKG_VERS).$(PKG_VERS_BRANCH).$(PKG_VERS_DATE).$(PKG_VERS_COMMIT)

DEPENDS = cross/openssl cross/berkeleydb

HOMEPAGE = https://www.boxbackup.org/
COMMENT  = Box Backup is an open source, completely automatic, on-line backup system
LICENSE  = BSD/GPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-random=/dev/urandom box_cv_have_large_file_support=yes

PRE_CONFIGURE_TARGET = boxbackup_pre_configure

INSTALL_MAKE_OPTIONS = install-backup-client install-backup-server DESTDIR=$(INSTALL_DIR)

include ../../mk/spksrc.cross-cc.mk

.PHONY: boxbackup_pre_configure
boxbackup_pre_configure:
	$(RUN) ./bootstrap
