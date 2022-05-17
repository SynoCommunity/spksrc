PKG_NAME = docker-tvheadend
# git hash from April 22nd 2022
PKG_VERS = 8d64a8b94105530c1e149b3973a66da9299c20dd
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/linuxserver/docker-tvheadend/archive
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = https://github.com/linuxserver/docker-tvheadend
COMMENT  = LinuxServer.io team supporting tvheadend docker container image
LICENSE  = GPL-3.0

INSTALL_TARGET = docker-tvheadend_install

include ../../mk/spksrc.install-resources.mk

.PHONY: docker-tvheadend_install
docker-tvheadend_install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/root/usr/bin/tv_grab_file $(STAGING_INSTALL_PREFIX)/bin
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/root/usr/bin/tv_grab_url $(STAGING_INSTALL_PREFIX)/bin
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/root/usr/bin/tv_grab_wg $(STAGING_INSTALL_PREFIX)/bin
