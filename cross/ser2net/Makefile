PKG_NAME = ser2net
PKG_VERS = 4.1.6
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/cminyard/$(PKG_NAME)/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/gensio cross/libyaml

HOMEPAGE = https://sourceforge.net/projects/ser2net/
COMMENT  = Serial port to network proxy.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = ser2net_pre_configure
POST_INSTALL_TARGET = ser2net_post_install


include ../../mk/spksrc.cross-cc.mk

.PHONY: ser2net_pre_configure
ser2net_pre_configure:
	$(RUN) ; ./reconf

.PHONY: ser2net_post_install
ser2net_post_install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/etc
	install -m 644 $(WORK_DIR)/$(PKG_DIR)/ser2net.yaml $(STAGING_INSTALL_PREFIX)/etc/ser2net.yaml
