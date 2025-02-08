SPK_NAME = demoservice
SPK_VERS = 1.2
SPK_REV = 8
SPK_ICON = src/demoservice.png

override ARCH=noarch

MAINTAINER = ymartin59
DESCRIPTION = Demonstration package to show installer script capabilities when requiring non-root user for background service and show configuration/creation of shared folder for package user.
DISPLAY_NAME = Demo Service
CHANGELOG = "1. Use redesigned shared folder handling.<br>2. Fix service command to work on SRM and DSM 5.<br/>3. Use Pyhton 3 when available in path."

LICENSE = GPLv2

WIZARDS_DIR = src/wizard/

# 'auto' reserved value grabs SPK_NAME (only auto is supported)
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
# The spksrc framework does not parse the service-setup.sh file for valid SERVICE_COMMAND
# so we have to tell it, that the package provides a startable service.
STARTABLE = yes

# New with redesigned shared folder handling:
# The wizard must take a name for the shared folder to use or create
# Entering the full path for shared folders is not supported anymore.
SERVICE_WIZARD_SHARENAME = wizard_shared_folder_name

# Service configuration
SERVICE_PORT = 8888
SERVICE_PORT_TITLE = $(DISPLAY_NAME) (HTTP)
SERVICE_DESC = Demo Service Package

# Admin link (optional)
# Create a link in the package center for this package. 
# Just for demonstration since an app icon in DSM is created with the same target.
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
	@$(MSG) Create dummy file to avoid empty target folder for DSM 7 packages
	mkdir -p $(STAGING_INSTALL_PREFIX)
	echo "dummy file (to avoid empty package)" > $(STAGING_INSTALL_PREFIX)/dummy

.PHONY: demoservice_extra_install
demoservice_extra_install:
	@$(MSG) Install service script
	@install -d -m 777 $(STAGING_DIR)/bin/	
	@install -m 755 src/start.sh $(STAGING_DIR)/bin/	
