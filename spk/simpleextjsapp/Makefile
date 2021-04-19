SPK_NAME = simpleextjsapp
SPK_VERS = 0.1
SPK_REV = 1
SPK_ICON = src/simpleextjsapp.png
DSM_UI_DIR = app

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = DigitalBox
DESCRIPTION = Simple Ext JS Application demo
RELOAD_UI = yes
STARTABLE = no
DISPLAY_NAME = SimpleExtJSApp

HOMEPAGE = https://github.com/DigitalBox98/SimpleExtJSApp

SERVICE_USER   = auto
SERVICE_SETUP  = src/service-setup.sh

POST_STRIP_TARGET = simpleextjsapp_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: simpleextjsapp_extra_install
simpleextjsapp_extra_install:
	install -m 755 -d $(STAGING_DIR)/app/
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 644 src/app/simpleextjsapp.js $(STAGING_DIR)/app/simpleextjsapp.js
	install -m 644 src/app/helptoc.conf $(STAGING_DIR)/app/helptoc.conf
	install -m 755 -d $(STAGING_DIR)/app/help
	for language in enu fre; do \
		install -m 755 -d $(STAGING_DIR)/app/help/$${language}; \
		install -m 644 src/app/help/$${language}/simpleapp_index.html $(STAGING_DIR)/app/help/$${language}/simpleapp_index.html; \
	done
	install -m 755 -d $(STAGING_DIR)/app/texts
	for language in enu fre; do \
		install -m 755 -d $(STAGING_DIR)/app/texts/$${language}; \
		install -m 644 src/app/texts/$${language}/strings $(STAGING_DIR)/app/texts/$${language}/strings; \
	done
