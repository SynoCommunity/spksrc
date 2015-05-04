SPK_NAME = imagemagick
SPK_VERS = 6.9.0
SPK_REV = 1
SPK_ICON = src/imagemagick.png
DSM_UI_DIR = app
CHANGELOG =

BETA = 1

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = cytec
DESCRIPTION = ImageMagick is a software suite to create, edit, compose, or convert bitmap images.
RELOAD_UI = yes
DISPLAY_NAME = ImageMagick

STARTABLE = no

HOMEPAGE = http://www.imagemagick.org/
LICENSE  = Apache 2.0

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS =

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = imagemagick_extra_install


include ../../mk/spksrc.spk.mk

.PHONY: imagemagick_extra_install
ntop_extra_install:
	install -m 755 -d $(STAGING_DIR)/app
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
