PKG_NAME = rsnapshot
PKG_VERS = 1.4.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://rsnapshot.org/downloads
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://rsnapshot.org/
COMMENT  = A tool for backing up your data using rsync.
LICENSE  = GPL

GNU_CONFIGURE = 1

# use tools provided by DSM to keep this a pure perl package.
CONFIGURE_ARGS  = ac_cv_path_RSYNC=/bin/rsync
CONFIGURE_ARGS += ac_cv_path_PERL=/bin/perl
CONFIGURE_ARGS += ac_cv_path_SSH=/bin/ssh
# use var folder for config file
CONFIGURE_ARGS += --sysconfdir=$(INSTALL_PREFIX)/var

include ../../mk/spksrc.cross-cc.mk
