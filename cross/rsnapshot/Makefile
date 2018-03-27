PKG_NAME = rsnapshot
PKG_VERS = 1.4.2
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://rsnapshot.org/downloads

HOMEPAGE = http://rsnapshot.org/
COMMENT  = Rsnapshot is a filesystem snapshot utility. It can take incremental snapshots of local and remote filesystems.
LICENSE  = GNU-GPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-perl=/usr/bin/perl --with-rsync=/usr/bin/rsync --with-ssh=/usr/bin/ssh

INSTALL_TARGET = rsnapshot_extra_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: rsnapshot_extra_install
rsnapshot_extra_install:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)
