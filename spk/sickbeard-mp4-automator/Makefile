SPK_NAME = sickbeard-mp4-automator
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 0
SPK_ICON = src/sickbeard-custom.png
DSM_UI_DIR = app

DEPENDS  =
SPK_DEPENDS = "python>2.7.3-3:git:sickbeard-custom:ffmpeg"
BETA = 1

MAINTAINER = Phtagn
DESCRIPTION = Sickbeard MP4 Automator enables to automatically transcode or repackage any video file in an mp4 container. It is made by mdhiggins and available on github. Once installed, you need to add sickbeard-mp4-automator/postConversion.py in the extra-script field in the postconversion tab. You also need to edit autoProcess.ini to set your defaults. It is automatically added to Config File Editor if you have it. If not, ssh into the machine and it can be found under /usr/local/sickbeard-mp4-automator/var.

RELOAD_UI = yes
DISPLAY_NAME = SickBeard MP4 Automator
CHANGELOG = "First release"

HOMEPAGE   = https://github.com/mdhiggins/sickbeard_mp4_automator
LICENSE    = GPL

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh


INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = sickbeard-custom_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: sickbeard-custom_extra_install
sickbeard-custom_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
