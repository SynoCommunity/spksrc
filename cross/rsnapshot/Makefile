PKG_NAME = rsnapshot
PKG_VERS = 1.4.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://rsnapshot.org/downloads
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://rsnapshot.org/
COMMENT  = Rsnapshot is a filesystem snapshot utility. It can take incremental snapshots of local and remote filesystems.
LICENSE  = GPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-perl=/usr/bin/perl --with-rsync=/usr/bin/rsync --with-ssh=/usr/bin/ssh

INSTALL_TARGET = rsnapshot_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: rsnapshot_install
rsnapshot_install:
	@$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)
