SPK_NAME = haproxy
SPK_VERS = 2.2.4
SPK_REV = 22
SPK_ICON = src/haproxy.png
DSM_UI_DIR = app
DSM_APP_NAME = SYNOCOMMUNITY.HAProxy.AppInstance

DEPENDS = cross/$(SPK_NAME)
WHEELS = src/requirements.txt
SPK_DEPENDS = "python>2.7.18-25"

MAINTAINER = Diaoul
DESCRIPTION = HAProxy is a free, very fast and reliable solution offering high availability, load balancing, and proxying for TCP and HTTP-based applications.
DESCRIPTION_FRE = HAProxy est un produit libre, performant et fiable qui permet la haute disponibilité, la répartition de charge et le proxy de services TCP ou HTTP.
ADMIN_PORT = 8280
RELOAD_UI = yes
DISPLAY_NAME = HAProxy
CHANGELOG = "1. Update haproxy 2.2.4.<br/>2. Update openssl to 1.1."

HOMEPAGE   = https://haproxy.1wt.eu/
LICENSE    = GPLv2
# this help url does not work anymore!
HELPURL    = https://synocommunity.com/help/haproxy

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc
CONF_DIR         = src/conf/
WIZARDS_DIR      = src/wizard/

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = haproxy_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: haproxy_extra_install
haproxy_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/var/crt
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/haproxy.cfg $(STAGING_DIR)/var/haproxy.cfg.tpl
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 644 src/app/style.css $(STAGING_DIR)/app/style.css
	install -m 644 src/app/haproxy.js $(STAGING_DIR)/app/haproxy.js
	install -m 755 src/app/setup.py $(STAGING_DIR)/app/setup.py
	install -m 755 src/app/haproxy.cgi.py $(STAGING_DIR)/app/haproxy.cgi
	install -m 755 -d $(STAGING_DIR)/app/application
	install -m 644 src/app/application/* $(STAGING_DIR)/app/application/
	install -m 755 -d $(STAGING_DIR)/app/texts
	for language in enu fre; do \
		install -m 755 -d $(STAGING_DIR)/app/texts/$${language}; \
		install -m 644 src/app/texts/$${language}/strings $(STAGING_DIR)/app/texts/$${language}/strings; \
	done
