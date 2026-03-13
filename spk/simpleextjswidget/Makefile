SPK_NAME = simpleextjswidget
SPK_VERS = 0.1
SPK_REV = 1
SPK_ICON = src/simpleextjswidget.png
WIZARDS_DIR = WIZARD_UIFILES
DSM_UI_DIR = app

DEPENDS =
WHEELS = flask

override ARCH=

MAINTAINER = DigitalBox98

DESCRIPTION = SimpleExtJS Widget demo to illustrate the usage of Syno ExtJS framework for DSM. This package is for experienced users.
STARTABLE = no
DISPLAY_NAME = SimpleExtJSWidget

HOMEPAGE = https://github.com/DigitalBox98/SimpleExtJSApp

POST_STRIP_TARGET = simpleextjswidget_install

include ../../mk/spksrc.spk.mk

.PHONY: simpleextjswidget_install
simpleextjswidget_install:
	install -m 755 -d $(STAGING_DIR)/var/
	install -m 755 -d $(STAGING_DIR)/app/
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 644 src/app/simpleextjswidget.js $(STAGING_DIR)/app/simpleextjswidget.js
	install -m 755 -d $(STAGING_DIR)/app/texts
	for language in enu fre; do \
		install -m 755 -d $(STAGING_DIR)/app/texts/$${language}; \
		install -m 644 src/app/texts/$${language}/strings $(STAGING_DIR)/app/texts/$${language}/strings; \
	done
