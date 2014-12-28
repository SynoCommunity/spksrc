PKG_NAME = zabbix
PKG_VERS = 2.2.2
PKG_EXT = tar.gz
PKG_DIST_NAME = zabbix-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://sourceforge.net/projects/zabbix/files/ZABBIX%20Latest%20Stable/$(PKG_VERS)
PKG_DIR = zabbix-$(PKG_VERS)

DEPENDS = cross/zlib cross/net-snmp cross/libmysql cross/mysqlODBC5 cross/libssh2 cross/curl cross/libxml2 cross/openipmi cross/iksemel cross/fping

HOMEPAGE = http://www.zabbix.com/
COMMENT  = The Enterprise-class Monitoring Solution for Everyone
LICENSE  =

PRE_CONFIGURE_TARGET = myPreConfigure
POST_INSTALL_TARGET = myPostInstall
GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-server --enable-proxy --enable-agent --with-unixodbc --enable-ipv6 --with-net-snmp=$(STAGING_INSTALL_PREFIX)/bin/net-snmp-config --with-ssh2=$(STAGING_INSTALL_PREFIX) --with-jabber=$(STAGING_INSTALL_PREFIX) --with-openipmi=$(STAGING_INSTALL_PREFIX) --with-libcurl=$(STAGING_INSTALL_PREFIX)/bin/curl-config --with-mysql=$(STAGING_INSTALL_PREFIX)/bin/mysql_config --with-libxml2=$(STAGING_INSTALL_PREFIX)/bin/xml2-config

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPreConfigure
myPreConfigure:
	cd $(WORK_DIR)/$(PKG_DIR)/src/libs/zbxsysinfo/;ln -s linux $(ARCH)
	sed -i '/$as_echo_n "checking for long long format... " >&6; }/{n; s/yes/maybe/}' $(WORK_DIR)/$(PKG_DIR)/configure
	sed -i '/CFLAGS="-m64"/{n; s/yes/maybe/}' $(WORK_DIR)/$(PKG_DIR)/configure


.PHONY: myPostInstall
myPostInstall:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/zabbix
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/database
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR)/frontends/php . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/zabbix
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR)/database/mysql . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/database