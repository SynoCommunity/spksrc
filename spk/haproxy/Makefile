SPK_NAME = haproxy
SPK_VERS = 1.5.14
SPK_REV = 19
SPK_ICON = src/haproxy.png
DSM_UI_DIR = app

DEPENDS = cross/$(SPK_NAME)
WHEELS = pyextdirect==0.3.1 flask Werkzeug Jinja2 itsdangerous
SPK_DEPENDS = "python>2.7.3-3"

MAINTAINER = Diaoul
DESCRIPTION = HAProxy is a free, very fast and reliable solution offering high availability, load balancing, and proxying for TCP and HTTP-based applications.
DESCRIPTION_FRE = HAProxy est un produit libre, performant et fiable qui permet la haute disponibilité, la répartition de charge et le proxy de services TCP ou HTTP.
ADMIN_PORT = 8280
RELOAD_UI = yes
DISPLAY_NAME = HAProxy
CHANGELOG = "1. Update to 1.5.14<br>2. Added gzip compression support<br>3. Fix listening on <1024 ports"

HOMEPAGE   = http://haproxy.1wt.eu/
LICENSE    = GNU GPL 2
HELPURL    = http://synocommunity.com/help/haproxy

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = haproxy_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: haproxy_extra_install
haproxy_extra_install:
	install -m 755 -d ${STAGING_DIR}/share/wheelhouse
	install -m 644 ${WORK_DIR}/wheelhouse/* ${STAGING_DIR}/share/wheelhouse/
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
	install -m 755 -d $(STAGING_DIR)/app/images
	install -m 644 src/app/images/*.png $(STAGING_DIR)/app/images/
	for size in 16 24 32 48 72; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
