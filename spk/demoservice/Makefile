SPK_NAME = demoservice
SPK_VERS = 1.2
SPK_REV = 6
SPK_ICON = src/demoservice.png

override ARCH=

MAINTAINER = ymartin59
DESCRIPTION = Demonstration package to show installer script capabilities when requiring non-root user for background service
RELOAD_UI = yes
DISPLAY_NAME = DemoService
CHANGELOG = "Initial version"

LICENSE  = GPLv2

WIZARDS_DIR      = src/wizard/

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

PRE_COPY_TARGET = demoservice_install

include ../../mk/spksrc.spk.mk

.PHONY: demoservice_install
# Replace standard copy/install targets, no sources, no content
demoservice_install:
	rm -fr $(STAGING_DIR)
	mkdir $(STAGING_DIR)
	mkdir --parents $(STAGING_INSTALL_PREFIX)
	echo "No files package" > $(STAGING_INSTALL_PREFIX)/README

