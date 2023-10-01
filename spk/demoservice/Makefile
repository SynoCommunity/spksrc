SPK_NAME = demoservice
SPK_VERS = 1.2
SPK_REV = 8
SPK_ICON = src/demoservice.png

override ARCH=

MAINTAINER = ymartin59
DESCRIPTION = Demonstration package to show installer script capabilities when requiring non-root user for background service and show configuration/creation of shared folder for package user.
DISPLAY_NAME = DemoService
CHANGELOG = "1. Use redesigned shared folder handling.<br>2. Fix service command to work on SRM and DSM 5 too.<br/>3. Use Pyhton 3 when available in path."

LICENSE = GPLv2

WIZARDS_DIR = src/wizard/

# 'auto' reserved value grabs SPK_NAME
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
STARTABLE = yes

SERVICE_WIZARD_SHARENAME = wizard_shared_folder_name

# Service configuration
SERVICE_PORT = 8888
SERVICE_PORT_TITLE = DemoService (HTTP)

# Admin link
ADMIN_PORT = $(SERVICE_PORT)

PRE_COPY_TARGET = demoservice_pre_copy
POST_STRIP_TARGET = demoservice_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: demoservice_pre_copy
# Replace standard copy/install targets, no sources, no content
demoservice_pre_copy:
	@$(MSG) Create README and dummy files
	mkdir -p $(STAGING_INSTALL_PREFIX_VAR)
	echo "Test file for /var/packages/$(SPK_NAME)/var/README"  > $(STAGING_INSTALL_PREFIX_VAR)/README
	echo "INSTALL_PREFIX_VAR     = $(INSTALL_PREFIX_VAR)"      >> $(STAGING_INSTALL_PREFIX_VAR)/README
	echo "STAGING_INSTALL_PREFIX = $(STAGING_INSTALL_PREFIX)"  >> $(STAGING_INSTALL_PREFIX_VAR)/README
	# create dummy file (avoid empty target folder for DSM 7 packages)
	mkdir -p $(STAGING_INSTALL_PREFIX)
	echo "dummy file (to avoid empty package)" > $(STAGING_INSTALL_PREFIX)/dummy

.PHONY: demoservice_extra_install
demoservice_extra_install:
	@$(MSG) Install service script
	@install -d -m 777 $(STAGING_DIR)/bin/	
	@install -m 755 src/start.sh $(STAGING_DIR)/bin/	
