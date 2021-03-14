SPK_NAME = demoservice
SPK_VERS = 1.2
SPK_REV = 9
SPK_ICON = src/demoservice.png

# force noarch target
override ARCH=

MAINTAINER = ymartin59
DESCRIPTION = Demonstration package to show installer script capabilities when requiring non-root user for background service. <br>Further more this package creates a demo MySQL database. Upon deinstallation the demo database and/or user can be kept or droped.
DISPLAY_NAME = DemoService
CHANGELOG = "1. Update with new installer logs<br/>2. Update for DSM7.<br/>3. Add db creation demo."

LICENSE = GPLv2

WIZARDS_DIR = src/wizard/
# The demo database is created by definitions in conf/resource and controlled by wizard variables.
CONF_DIR    = src/conf/

# 'auto' reserved value grabs SPK_NAME
SERVICE_USER         = auto
SERVICE_WIZARD_GROUP = wizard_group
SERVICE_WIZARD_SHARE = wizard_download_dir
SERVICE_SETUP        = src/service-setup.sh
STARTABLE            = yes

# Service configuration
SERVICE_PORT = 8888
SERVICE_PORT_TITLE = DemoService(HTTP)

# Admin link
ADMIN_PORT = $(SERVICE_PORT)

PRE_COPY_TARGET = demoservice_pre_copy

include ../../mk/spksrc.spk.mk

.PHONY: demoservice_install
# Replace standard copy/install targets, no sources, no content
demoservice_pre_copy:
	rm -rf $(STAGING_DIR)
	mkdir $(STAGING_DIR)
	mkdir --parents $(STAGING_INSTALL_PREFIX)/var
	echo "No files package with MySQL DB creation." > $(STAGING_INSTALL_PREFIX)/var/README

