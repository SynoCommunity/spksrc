PKG_NAME = git
PKG_VERS = 1.7.10
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://git-core.googlecode.com/files

DEPENDS = cross/expat cross/zlib cross/openssl cross/curl

HOMEPAGE = http://git-scm.com/
COMMENT  = Git is a free & open source, distributed version control system designed to handle everything from small to very large projects with speed and efficiency.
LICENSE  = GPLv2

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --libexecdir=$(STAGING_INSTALL_PREFIX)/lib ac_cv_fread_reads_directories=yes ac_cv_snprintf_returns_bogus=no

include ../../mk/spksrc.cross-cc.mk

