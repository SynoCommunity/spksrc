PKG_NAME = zabbixserver
PKG_VERS = 2.2.0
PKG_EXT = tar.gz
PKG_DIST_NAME = zabbix-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://sourceforge.net/projects/zabbix/files/ZABBIX%20Latest%20Stable/$(PKG_VERS)
PKG_DIR = zabbix-$(PKG_VERS)

DEPENDS = cross/mysql cross/curl cross/libxml2 cross/openipmi cross/iksemel   

HOMEPAGE = http://www.zabbix.com/
COMMENT  = The Enterprise-class Monitoring Solution for Everyone
LICENSE  =

PRE_CONFIGURE_TARGET = myConfigure
GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-server --enable-ipv6 --with-jabber=$(STAGING_INSTALL_PREFIX) --with-openipmi=$(STAGING_INSTALL_PREFIX) --with-libcurl=$(STAGING_INSTALL_PREFIX)/bin/curl-config --with-mysql=$(STAGING_INSTALL_PREFIX)/bin/mysql_config --with-libxml2=$(STAGING_INSTALL_PREFIX)/bin/xml2-config

include ../../mk/spksrc.cross-cc.mk

myConfigure:
	cd $(WORK_DIR)/$(PKG_DIR)/src/libs/zbxsysinfo/;ln -s linux $(ARCH)
