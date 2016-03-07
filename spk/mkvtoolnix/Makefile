SPK_NAME = mkvtoolnix
SPK_VERS = 8.5.2
SPK_REV = 1
SPK_ICON = src/$(SPK_NAME).png
DSM_UI_DIR = app
CHANGELOG = 

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = cytec
DESCRIPTION = MKVToolNix is a set of tools to create, alter and inspect Matroska files under Linux, other Unices and Windows.
RELOAD_UI = yes
DISPLAY_NAME = MKVToolNix
STARTABLE = no
BETA = 1

HOMEPAGE = https://mkvtoolnix.download/index.html
LICENSE  =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = mkvtoolnix_extra_install


include ../../mk/spksrc.spk.mk

.PHONY: mkvtoolnix_extra_install
mkvtoolnix_extra_install:
	install -m 755 -d $(STAGING_DIR)/app
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
