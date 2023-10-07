SPK_NAME = demowebservice
SPK_VERS = 1.0
SPK_REV = 1
SPK_ICON = src/demowebservice.png

DEPENDS =

override ARCH=

MAINTAINER = hgy59
DESCRIPTION = Demopackage to show how to create a web service \(web application\)
DISPLAY_NAME = Demo Web Service
CHANGELOG = "Initial package release"

LICENSE = MIT

include ../../mk/spksrc.common.mk
# use the latest php version
ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
PHP_VERSION = 8.2
else
PHP_VERSION = 7.4
endif

# omit dependencies for DSM 5 and SRM
ifeq ($(call version_ge, ${TCVERSION}, 6.0),1)
SPK_DEPENDS = WebStation:PHP$(PHP_VERSION):Apache2.4
endif

WIZARDS_DIR = src/wizard/
SERVICE_WIZARD_SHARENAME = wizard_shared_folder_name

SYSTEM_GROUP = http

DSM_UI_DIR = app
DSM_UI_CONFIG = src/app/config

CONF_DIR = src/conf_php$(PHP_VERSION)/

INSTALL_DEP_SERVICES = apache-web
START_DEP_SERVICES = apache-web
INSTUNINST_RESTART_SERVICES = apache-web

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
STARTABLE = no

COPY_TARGET = demowebservice_install
POST_ICON_TARGET = demowebservice_post_icon

include ../../mk/spksrc.spk.mk

.PHONY: demowebservice_install
# the app/config file must be installed from DSM 6 to show the icon in DSM
# but it must not exist in DSM 7 packages (System error. Unable to perform this operation. Please try again later.)
demowebservice_install:
	@$(MSG) Install app/config and web application
ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
	@install -d -m 755 $(STAGING_DIR)/app/
	@install -m 644 $(DSM_UI_CONFIG) $(STAGING_DIR)/app/config
endif	
	@install -d -m 755 $(STAGING_DIR)/web/$(SPK_NAME)/
	@install -m 755 src/web/index.php $(STAGING_DIR)/web/$(SPK_NAME)/

.PHONY: demowebservice_post_icon
demowebservice_post_icon:
	@$(MSG) Add some package icons to the web application
	@install -d -m 755 $(STAGING_DIR)/web/$(SPK_NAME)/images
	@for image_size in 16 32; do \
	  install -m 755 $(STAGING_DIR)/app/images/$(SPK_NAME)-$${image_size}.png $(STAGING_DIR)/web/$(SPK_NAME)/images/ ; \
	done
