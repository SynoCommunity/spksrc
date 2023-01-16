SPK_NAME = demoservice
SPK_VERS = 1.2
SPK_REV = 8
SPK_ICON = src/demoservice.png

override ARCH=

MAINTAINER = ymartin59
DESCRIPTION = Demonstration package to show installer script capabilities when requiring non-root user for background service
DISPLAY_NAME = DemoService
CHANGELOG = "1. Update with new installer logs<br/>2. Update for DSM7"

LICENSE = GPLv2

WIZARDS_DIR = src/wizard/

# 'auto' reserved value grabs SPK_NAME
SERVICE_USER = auto
SERVICE_WIZARD_GROUP = wizard_group

include ../../mk/spksrc.common.mk
ifneq ($(call version_ge, ${TCVERSION}, 7.0),1)
# SERVICE_WIZARD_SHARE is not supported for DSM7 yet
SERVICE_WIZARD_SHARE = wizard_download_dir
endif

SERVICE_SETUP = src/service-setup.sh
STARTABLE = yes

# Service configuration
SERVICE_PORT = 8888
SERVICE_PORT_TITLE = DemoService (HTTP)

# Admin link
ADMIN_PORT = $(SERVICE_PORT)

PRE_COPY_TARGET = demoservice_pre_copy

include ../../mk/spksrc.spk.mk

.PHONY: demoservice_install
# Replace standard copy/install targets, no sources, no content
demoservice_pre_copy:
	@$(MSG) Create README and dummy file
	rm -fr $(STAGING_DIR)
	mkdir $(STAGING_DIR)
	mkdir --parents $(STAGING_INSTALL_PREFIX_VAR)
	echo "Test file for $(INSTALL_PREFIX_VAR)" > $(STAGING_INSTALL_PREFIX_VAR)/README
	# create dummy file (avoid empty target folder for DSM 7 packages)
	mkdir -p $(STAGING_INSTALL_PREFIX)
	echo "dummy file (to avoid empty package)" > $(STAGING_INSTALL_PREFIX)/dummy
