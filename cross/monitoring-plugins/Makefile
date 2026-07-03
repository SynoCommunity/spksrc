PKG_NAME = monitoring-plugins
PKG_VERS = 2.4.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/monitoring-plugins/monitoring-plugins/archive/refs/tags/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://www.monitoring-plugins.org
COMMENT  = Standard plugins for Icinga, Naemon, Nagios, Shinken, Sensu, and other monitoring applications.
LICENSE  = GPLv3

GNU_CONFIGURE = 1

CONFIGURE_ARGS  = --disable-static
CONFIGURE_ARGS += --without-openssl
CONFIGURE_ARGS += --libexecdir=$(INSTALL_PREFIX)/bin
CONFIGURE_ARGS += --with-sudo-command=/bin/sudo
CONFIGURE_ARGS += --with-rpcinfo-command=/sbin/rpcinfo
CONFIGURE_ARGS += --with-smbclient-command=/bin/smbclient
CONFIGURE_ARGS += --without-apt-get-command

PRE_CONFIGURE_TARGET = monitoring_plugins_autogen

include ../../mk/spksrc.cross-cc.mk

.PHONY: monitoring_plugins_autogen
monitoring_plugins_autogen:
	cd $(WORK_DIR)/$(PKG_DIR) && autoreconf -fiv
