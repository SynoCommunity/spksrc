SPK_NAME = mediainfo
SPK_VERS = 0.7.72
SPK_REV = 1
SPK_ICON = src/mediainfo.png

DEPENDS  = cross/$(SPK_NAME)

RELOAD_UI = yes
STARTABLE = no

MAINTAINER = SynoCommunity
DESCRIPTION = "MediaInfo is a convenient unified display of the most relevant technical and tag data for video and audio files."
DISPLAY_NAME = MediaInfo

HOMEPAGE   = http://sourceforge.net/projects/mediainfo/
LICENSE    =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = mediainfo_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: mediainfo_extra_install
mediainfo_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/app
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
