SPK_NAME = mediainfo
SPK_VERS = 18.08.1
SPK_REV = 7
SPK_ICON = src/mediainfo.png

DEPENDS  = cross/$(SPK_NAME)

RELOAD_UI = yes
STARTABLE = no

MAINTAINER = cytec
DESCRIPTION = "MediaInfo is a convenient unified display of the most relevant technical and tag data for video and audio files."
DISPLAY_NAME = MediaInfo

HOMEPAGE   = http://sourceforge.net/projects/mediainfo/
LICENSE    =

POST_STRIP_TARGET = mediainfo_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: mediainfo_extra_install
mediainfo_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
