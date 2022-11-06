SPK_NAME = demoservice
SPK_VERS = 1.2
SPK_REV = 9
SPK_ICON = src/demoservice.png

# force noarch target
override ARCH=

MAINTAINER = ymartin59
DESCRIPTION = Demonstration package to show installer script capabilities when requiring non-root user for background service. Further more this package creates a demo MySQL database. Upon deinstallation the demo database and/or user can be kept or droped.
DISPLAY_NAME = Demo Service
CHANGELOG = "1. Update with new installer logs.<br/>2. Update for DSM7.<br/>3. Add db creation demo."

LICENSE = GPLv2

WIZARDS_DIR = src/wizard/

# The demo database is created by definitions in conf/resource and controlled by wizard variables.
CONF_DIR = src/conf/

# 'auto' reserved value grabs SPK_NAME
SERVICE_USER = auto
SERVICE_WIZARD_GROUP = wizard_group
SERVICE_WIZARD_SHARE = wizard_data_folder
USE_DATA_SHARE_WORKER = yes
SERVICE_SETUP = src/service-setup.sh
STARTABLE = yes

# Service configuration
SERVICE_PORT = 8888
SERVICE_PORT_TITLE = Demo Service (HTTP)

# Admin link
ADMIN_PORT = $(SERVICE_PORT)

PRE_COPY_TARGET = demoservice_pre_copy

include ../../mk/spksrc.spk.mk

.PHONY: demoservice_install
# Replace standard copy/install targets, no sources, no content
demoservice_pre_copy:
	@rm -rf $(STAGING_INSTALL_PREFIX)
	@mkdir --parents $(STAGING_INSTALL_PREFIX)/var
	@echo -e "dummy file to avoid empty package.\n" > $(STAGING_INSTALL_PREFIX)/dummy.txt
	@echo "<h3>Demo Service</h3>"                                                      >  $(STAGING_INSTALL_PREFIX)/var/readme.html
	@echo "<p>DemoService is a package without further files.<p><p/>"                  >> $(STAGING_INSTALL_PREFIX)/var/readme.html
	@echo "<p>A demo MySQL/MariaDB database is created.<br/>"                          >> $(STAGING_INSTALL_PREFIX)/var/readme.html
	@echo "Database credentials are stored in <code>var/demoservice.ini</code/>.</p>"  >> $(STAGING_INSTALL_PREFIX)/var/readme.html
