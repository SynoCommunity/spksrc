PKG_NAME = monitoring-plugins
PKG_VERS = 3.0.2
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/monitoring-plugins/monitoring-plugins/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://www.monitoring-plugins.org
COMMENT  = Standard plugins for Icinga, Naemon, Nagios, Shinken, Sensu, and other monitoring applications.
LICENSE  = GPLv3

DEPENDS = cross/openssl3

GNU_CONFIGURE = 1

CONFIGURE_ARGS  = --disable-static
CONFIGURE_ARGS += --with-openssl=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --libexecdir=$(INSTALL_PREFIX)/bin
CONFIGURE_ARGS += --with-sudo-command=/bin/sudo
CONFIGURE_ARGS += --with-ssh-command=/bin/ssh
CONFIGURE_ARGS += --with-rpcinfo-command=/sbin/rpcinfo
CONFIGURE_ARGS += --with-smbclient-command=/bin/smbclient
CONFIGURE_ARGS += --without-apt-get-command
CONFIGURE_ARGS += --with-ping-command="/bin/ping -c %d %s"
CONFIGURE_ARGS += --with-ping6-command="/bin/ping6 -c %d %s"

PRE_CONFIGURE_TARGET = monitoring_plugins_autogen

include ../../mk/spksrc.cross-cc.mk

.PHONY: monitoring_plugins_autogen
monitoring_plugins_autogen:
	cd $(WORK_DIR)/$(PKG_DIR) && autoreconf -fiv
