PKG_NAME = rsnapshot
PKG_VERS = 1.4.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://rsnapshot.org/downloads
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://rsnapshot.org/
COMMENT  = Rsnapshot is a filesystem snapshot utility. It can take incremental snapshots of local and remote filesystems.
LICENSE  = GPL

GNU_CONFIGURE = 1

CONFIGURE_ARGS = ac_cv_path_RSYNC=/bin/rsync ac_cv_path_PERL=/bin/perl ac_cv_path_SSH=/bin/ssh

INSTALL_TARGET = rsnapshot_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: rsnapshot_install
rsnapshot_install:
	@$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)
