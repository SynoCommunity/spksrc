SPK_NAME = element
SPK_VERS = 1.11.17
SPK_REV = 1
SPK_ICON = src/element.png
DSM_UI_DIR = app

DEPENDS = cross/element

MAINTAINER = hgy59
DISPLAY_NAME = Element
DESCRIPTION = A glossy Matrix collaboration client for the web.
HOMEPAGE = https://element.io/
LICENSE = Apache 2.0
CHANGELOG = "Initial package version."

include ../../mk/spksrc.common.mk
ifeq ($(call version_ge, ${TCVERSION}, 6.0),1)
SPK_DEPENDS = "WebStation>=2.1.0:Apache2.4>=2.4.0"
CONF_DIR = src/conf
APACHE_VERSION = 2.4
else
APACHE_VERSION = 2.2
endif

SERVICE_USER = auto
SYSTEM_GROUP = http
# force creation of icons without SERVICE_PORT defined
ICON_DIR = $(STAGING_DIR)/$(DSM_UI_DIR)/images

INSTALL_DEP_SERVICES = apache-web
START_DEP_SERVICES = apache-web
INSTUNINST_RESTART_SERVICES = apache-web

SERVICE_SETUP = src/service-setup.sh
# we need a nop sss script to avoid creation of service control.
SSS_SCRIPT = src/dsm-control.sh

POST_STRIP_TARGET = element_extra_install

# Pure javascript package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: element_extra_install
element_extra_install:
	@$(MSG) Install app/config and create link var/config.json into web folder
	@install -d -m 755 $(STAGING_DIR)/app $(STAGING_DIR)/var
	@install -m 644 src/app/config $(STAGING_DIR)/app/
	@cd $(STAGING_DIR)/web && ln -sf /var/packages/element/var/config.json .
