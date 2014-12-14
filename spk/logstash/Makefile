SPK_NAME = logstash
SPK_VERS = 1.4.2
SPK_REV = 8
SPK_ICON = src/logstash.png
DSM_UI_DIR = app

DEPENDS = cross/busybox cross/$(SPK_NAME)

MAINTAINER = AustinSaintAubin
DESCRIPTION = "All your logs from all over your infrastructure in one place - with searching and graphing. logstash is a tool for managing events and logs. You can use it to collect logs, parse them, and store them for later use (like, for searching). Speaking of searching, logstash comes with a web interface for searching and drilling into all of your logs. It is fully free and fully open source. The license is Apache 2.0, meaning you are pretty much free to use it however you want in whatever way. logstash is now a part of the Elasticsearch family! This allows us to build better software much faster as well as offering production support.  NOTE: When starting logstash it might take a minute to a few minutes for it fully spin up, please be patient. This buld includes Logstash, Elasticsearch, and Kibana to give you an all-in-one package that works right out of the box."
ADMIN_URL = /kibana/  # "3rdparty/logstash/kibana/index.html"
ADMIN_PORT = 80  # 500
RELOAD_UI = yes
STARTABLE = yes
DISPLAY_NAME = $(SPK_NAME)
CHANGELOG = "1. Initial Release & DSM 5.0 compatibility"
HELPURL = http://logstash.net/docs/$(SPK_VERS)/

HOMEPAGE = http://logstash.net/
LICENSE  = Apache v2

WIZARDS_DIR = src/wizard/
CONF = nop

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc

INSTALL_DEP_SERVICES = apache-web java
START_DEP_SERVICES = apache-web
INSTUNINST_RESTART_SERVICES = apache-web

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = logstash_extra_install

BUSYBOX_CONFIG = usrmng daemon nice
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: logstash_extra_install
logstash_extra_install: 
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 src/logstash-sample.conf $(STAGING_DIR)/logstash-sample.conf
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 src/var/logstash-java.conf $(STAGING_DIR)/var/logstash-java.conf
	install -m 755 src/var/package.conf $(STAGING_DIR)/var/package.conf
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 64 72 128 256; do \
		convert "src/app/kibana.png" -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/kibana-$${size}.png ; \
	done