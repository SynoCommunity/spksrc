SPK_NAME = demowebservice
SPK_VERS = 1.0
SPK_REV = 1
SPK_ICON = src/demowebservice.png

DEPENDS =

override ARCH=noarch

MAINTAINER = hgy59
DESCRIPTION = Demopackage to show how to create a web service \(web application\)
DISPLAY_NAME = Demo Web Service
CHANGELOG = "Initial package release"

LICENSE = MIT

include ../../mk/spksrc.common.mk
# use the latest php version
ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
PHP_VERSION = 8.2
endif

# only for DSM 7 we have dedicated dependencies (must match the configuration in conf/resource)
ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
SPK_DEPENDS = WebStation:PHP$(PHP_VERSION):Apache2.4
else ifeq ($(call version_ge, ${TCVERSION}, 6.0),1)
# on DSM 6 the default web server and PHP version are used
SPK_DEPENDS = WebStation
endif

WIZARDS_DIR = src/wizard/
SERVICE_WIZARD_SHARENAME = wizard_shared_folder_name

SYSTEM_GROUP = http

DSM_UI_DIR = app
DSM_UI_CONFIG = src/app/config
ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
# webservice resource definition is for DSM 7 only
CONF_DIR = src/conf_php$(PHP_VERSION)/
# The app/config file is not used on DSM 7 for web services, the app icon is created based on the resources in CONF_DIR only.
# With app/config on DSM 7 (sometimes) an error occurred: System error. Unable to perform this operation. Please try again later.
# Disable the creation of app/config file:
NO_SERVICE_SHORTCUT = y
# create firewall rules, since we add a port based "Web Portal"
SERVICE_PORT = 8889
endif

# apache-web dependency is not used:
# on DSM 7 the settings are ignored as dependency is defined in conf/resource
# on DSM 6 the package runs under the active web server (apache or nginx)
#INSTALL_DEP_SERVICES = apache-web
#START_DEP_SERVICES = apache-web
#INSTUNINST_RESTART_SERVICES = apache-web

SERVICE_SETUP = src/service-setup.sh
STARTABLE = no

COPY_TARGET = demowebservice_install
POST_ICON_TARGET = demowebservice_post_icon

include ../../mk/spksrc.spk.mk

.PHONY: demowebservice_install
demowebservice_install:
	@$(MSG) Install the web application
	@install -d -m 755 $(STAGING_DIR)/web/$(SPK_NAME)/
	@install -m 755 src/web/index.php $(STAGING_DIR)/web/$(SPK_NAME)/

.PHONY: demowebservice_post_icon
demowebservice_post_icon:
	@$(MSG) Add some package icons to the web application
	@install -d -m 755 $(STAGING_DIR)/web/$(SPK_NAME)/images
	@for image_size in 16 32; do \
	  install -m 755 $(STAGING_DIR)/app/images/$(SPK_NAME)-$${image_size}.png $(STAGING_DIR)/web/$(SPK_NAME)/images/ ; \
	done
