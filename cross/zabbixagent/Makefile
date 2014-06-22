PKG_NAME = zabbixagent
PKG_VERS = 2.2.2
PKG_EXT = tar.gz
PKG_DIST_NAME = zabbix-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://sourceforge.net/projects/zabbix/files/ZABBIX%20Latest%20Stable/$(PKG_VERS)
PKG_DIR = zabbix-$(PKG_VERS)


DEPENDS = 

HOMEPAGE = http://www.zabbix.com/
COMMENT  = The Enterprise-class Monitoring Solution for Everyone
LICENSE  =

PRE_CONFIGURE_TARGET = myPreConfigure
GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-agent --enable-ipv6

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPreConfigure
myPreConfigure:
	cd $(WORK_DIR)/$(PKG_DIR)/src/libs/zbxsysinfo/;ln -s linux $(ARCH)
	sed -i '/$as_echo_n "checking for long long format... " >&6; }/{n; s/yes/maybe/}' $(WORK_DIR)/$(PKG_DIR)/configure
	sed -i '/CFLAGS="-m64"/{n; s/yes/maybe/}' $(WORK_DIR)/$(PKG_DIR)/configure
