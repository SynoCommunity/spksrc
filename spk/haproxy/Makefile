SPK_NAME = haproxy
SPK_VERS = 1.5-dev11
SPK_REV = 2
SPK_ICON = src/haproxy.png
BETA = 1

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = HAProxy is a free, very fast and reliable solution offering high availability, load balancing, and proxying for TCP and HTTP-based applications.
DESCRIPTION_FRE = HAProxy est un produit libre, performant et fiable qui permet la haute disponibilité, la répartition de charge et le proxy de services TCP ou HTTP.
RELOAD_UI = no
DISPLAY_NAME = HAProxy

HOMEPAGE   = http://haproxy.1wt.eu/
LICENSE    = GPL v2

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/start-stop-status
ADDITIONAL_SCRIPTS = 

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = haproxy_install

include ../../mk/spksrc.spk.mk

.PHONY: haproxy_install
haproxy_install: 
	pwd
	install -m 777 -d $(STAGING_DIR)/var
	install -m 500 -d $(STAGING_DIR)/chroot
	install -m 644 src/var/haproxy.conf $(STAGING_DIR)/var/haproxy.conf
