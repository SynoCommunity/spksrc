SPK_NAME = wallabag
SPK_VERS = 2.3.8
SPK_REV = 3
SPK_ICON = src/wallabag.png
DSM_UI_DIR = app
BETA = 1

DEPENDS  = cross/$(SPK_NAME)

MAINTAINER = tolkonepiu
DESCRIPTION = Wallabag is a self hostable application allowing you to save an offline copy of your favorite articles. Click, save, read it when you can. It extracts content so that you can read it when you have time.
ADMIN_URL = /wallabag/web/
STARTABLE = no
DISPLAY_NAME = Wallabag
CHANGELOG = "Update to 2.3.8, Update to generic service script"

HOMEPAGE = https://www.wallabag.org/
LICENSE  = MIT

WIZARDS_DIR = src/wizard/
SERVICE_SETUP = src/service-setup.sh
STARTABLE = no

INSTALL_DEP_SERVICES = apache-web mysql
START_DEP_SERVICES = apache-web mysql
INSTUNINST_RESTART_SERVICES = apache-web

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = wallabag_extra_install

# Pure PHP package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: wallabag_extra_install
wallabag_extra_install:
	install -m 644 src/parameters.yml $(STAGING_DIR)/share/${SPK_NAME}/app/config/parameters.yml
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
