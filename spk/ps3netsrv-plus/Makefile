SPK_NAME = ps3netsrv-plus
SPK_VERS = 2.3.1
SPK_REV = 1
SPK_ICON = src/ps3netsrv-plus.png
SPK_NAME_ARCH = v1000
SPK_PACKAGE_ARCHS = v1000

DEPENDS = cross/ps3netsrv-plus

REQUIRED_MIN_DSM = 7.3
UNSUPPORTED_ARCHS = $(ARM_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)

MAINTAINER = nathanchere
MAINTAINER_URL = https://nathanchere.com.au
DESCRIPTION = Read-only NETISO server and DSM management interface for PlayStation 3 media.
DISPLAY_NAME = ps3netsrv-plus
CHANGELOG = "1. Forked build for publishing to synocommunity.com. <br/>2. Renamed DSM package to ps3netsrv-plus to avoid a package name conflict. <br/>3. Update ps3netsrv-go to v0.5.0."
HOMEPAGE = https://nathanchere.com.au/projects/ps3netsrv-plus
LICENSE = Apache-2.0 AND MIT AND BSD-3-Clause AND OFL-1.1

STARTABLE = yes
SERVICE_USER = auto
SYSTEM_GROUP = http
SERVICE_SETUP = src/service-setup.sh
SERVICE_COMMAND = $${SYNOPKG_PKGDEST}/bin/ps3netsrv-plus serve

WIZARDS_DIR = $(WORK_DIR)/wizard
SERVICE_WIZARD_SHARENAME = wizard_shared_folder_name

DSM_UI_DIR = app
DSM_UI_CONFIG = src/app/config
DSM_APP_NAME = SYNO.SDS.ps3netsrvplus.Application
DSM_APP_LAUNCH_NAME = SYNO.SDS.ps3netsrvplus.Application

POST_STRIP_TARGET = ps3netsrv_plus_extra_install
POST_SERVICE_TARGET = ps3netsrv_plus_resource

include ../../mk/spksrc.spk.mk

.PHONY: ps3netsrv_plus_extra_install
ps3netsrv_plus_extra_install:
	install -m 755 $(STAGING_DIR)/bin/ps3netsrv-plus $(STAGING_DIR)/app/index.cgi
	install -m 755 src/app/launcher.cgi $(STAGING_DIR)/app/
	install -m 755 src/app/launcher.cgi $(STAGING_DIR)/app/launcher-v29.cgi
	install -m 644 src/app/launcher.js $(STAGING_DIR)/app/

.PHONY: ps3netsrv_plus_resource
ps3netsrv_plus_resource:
	install -m 644 src/conf/resource $(DSM_CONF_DIR)/resource

.PHONY: ps3netsrv_plus_wizard
wizards: ps3netsrv_plus_wizard
ps3netsrv_plus_wizard:
	install -m 755 -d $(WIZARDS_DIR)
	jq --rawfile script src/wizard/folder-picker.js '.[0].activeate = $$script' src/wizard/install_uifile > $(WIZARDS_DIR)/install_uifile
