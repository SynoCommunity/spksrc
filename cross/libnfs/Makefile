PKG_NAME = libnfs
PKG_VERS = 1.9.8
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = https://sites.google.com/site/$(PKG_NAME)tarballs/li

HOMEPAGE = https://github.com/sahlberg/libnfs
COMMENT  = Client library for accessing NFS shares over a network
LICENSE  = 

CONFIGURE_ARGS = --disable-static $(TC_CONFIGURE_ARGS)

include ../../mk/spksrc.cross-cc.mk

