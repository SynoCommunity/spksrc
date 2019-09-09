PKG_NAME = monitoring-plugins
PKG_VERS = 2.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.monitoring-plugins.org/download/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.monitoring-plugins.org
COMMENT  = Standard plugins for Icinga, Naemon, Nagios, Shinken, Sensu, and other monitoring applications.
LICENSE  = GPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --without-openssl --libexecdir=$(INSTALL_PREFIX)/bin --with-sudo-command=/bin/sudo --with-rpcinfo-command=/sbin/rpcinfo --with-smbclient-command=/bin/smbclient

include ../../mk/spksrc.cross-cc.mk
