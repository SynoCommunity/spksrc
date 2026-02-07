SPK_NAME = haproxy
SPK_VERS = 3.0.15
SPK_REV = 23
SPK_ICON = src/haproxy.png

DEPENDS = cross/haproxy

PYTHON_PACKAGE = python312
SPK_DEPENDS = "$(PYTHON_PACKAGE)"
WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

MAINTAINER = Diaoul
DESCRIPTION = HAProxy is a free, very fast and reliable solution offering high availability, load balancing, and proxying for TCP and HTTP-based applications.
DESCRIPTION_FRE = HAProxy est un produit libre, performant et fiable qui permet la haute disponibilité, la répartition de charge et le proxy de services TCP ou HTTP.
DISPLAY_NAME = HAProxy
CHANGELOG = "1. Major update to HAProxy 3.0.15. <br/>2. Modernize for DSM 7. <br/>3. Update to OpenSSL 3. <br/>4. Add haproxy-dashboard web UI on port 8281."

HOMEPAGE   = https://haproxy.1wt.eu/
LICENSE    = GPLv2

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8281
SERVICE_PORT_PROTOCOL = https
SERVICE_PORT_TITLE = HAProxy Dashboard

ADMIN_PORT = $(SERVICE_PORT)
ADMIN_PROTOCOL = https

FWPORTS = src/${SPK_NAME}.sc
WIZARDS_DIR = src/wizard/

POST_STRIP_TARGET = haproxy_extra_install

include ../../mk/spksrc.python.mk

.PHONY: haproxy_extra_install
haproxy_extra_install:
	install -m 755 -d $(STAGING_DIR)/share
	install -m 644 src/haproxy.cfg $(STAGING_DIR)/share/haproxy.cfg.tpl
	install -m 755 -d $(STAGING_DIR)/share/haproxy-dashboard
	cp -R src/haproxy-dashboard/* $(STAGING_DIR)/share/haproxy-dashboard/
