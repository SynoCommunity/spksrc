PKG_NAME = subversion
PKG_VERS = 1.7.8
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://mir2.ovh.net/ftp.apache.org/dist/subversion
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/apr cross/apr-util cross/sqlite cross/expat cross/neon

HOMEPAGE = http://subversion.apache.org/
COMMENT  = Subversion is an open source version control system
LICENSE  = 

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-apr=$(STAGING_INSTALL_PREFIX) --with-apr-util=$(STAGING_INSTALL_PREFIX) --with-neon=$(STAGING_INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk
