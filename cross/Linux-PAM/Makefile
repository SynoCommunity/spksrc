PKG_NAME = Linux-PAM
PKG_VERS = 1.1.8
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.linux-pam.org/library/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/flex

HOMEPAGE = http://www.linux-pam.org/
COMMENT  = 
LICENSE  = 


GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --enable-db=no

include ../../mk/spksrc.cross-cc.mk


