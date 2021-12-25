SPK_NAME = arr-stack
SPK_VERS = 1.0
SPK_REV = 1
SPK_ICON = src/$(SPK_NAME).png

SPK_DEPENDS = "Docker>=18.09.0-1017"
override ARCH=

MAINTAINER = publicarray
DESCRIPTION = Sonarr/Radarr/Bazarr https://hotio.dev/ https://trash-guides.info/ https://github.com/TRaSH-/Guides-Synology-Templates

HOMEPAGE = https://trash-guides.info/
LICENSE  = GPLv3

DISPLAY_NAME = arr-stack
RELOADUI = yes
CHANGELOG = "First version"

# ADMIN_PORT = 7878,8989,6767,32400
SERVICE_PORT_TITLE = $(DISPLAY_NAME)
# SERVICE_PORT = $(ADMIN_PORT)
SERVICE_PORT = 7879,8990,6768,32401
CONF_DIR = src/conf
SSS_SCRIPT = src/service-start-stop.sh
INSTALLER_SCRIPT = src/installer.sh

PRE_COPY_TARGET = arr_stack_pre_copy

include ../../mk/spksrc.spk.mk

.PHONY: arr_stack_pre_copy
# Replace standard copy/install targets, no sources, no content
arr_stack_pre_copy:
	rm -fr $(STAGING_DIR)
	mkdir $(STAGING_DIR)
	mkdir --parents $(STAGING_INSTALL_PREFIX)/var
	touch $(STAGING_INSTALL_PREFIX)/var/.gitkeep
