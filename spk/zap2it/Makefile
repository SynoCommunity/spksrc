SPK_NAME = zap2it
SPK_VERS = 20210504
SPK_REV = 1
SPK_ICON = src/zap2it.png
DSM_UI_DIR = app

DEPENDS = cross/$(SPK_NAME)
SPK_DEPENDS = "python3>=3.7.7-15"

MAINTAINER = th0ma7
DESCRIPTION = Takes TV listings from zap2it and convert them to XMLTV for use with applications such as Jellyfin / Emby / TVheadEnd
DESCRIPTION_FRE = Prend la programmation télé de zap2it et la convertis en XMLTV pour une utilisation avec des applications telles que Jellyfin / Emby / TVheadEnd
RELOAD_UI = no
DISPLAY_NAME = zap2it XMLTV Scrapper
CHANGELOG = "Initial package"

STARTABLE = no
HOMEPAGE = https://github.com/daniel-widrick/zap2it-GuideScraping
LICENSE  = MIT

WIZARDS_DIR = src/wizard/

# 'auto' reserved value grabs SPK_NAME
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

POST_STRIP_TARGET = zap2it_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: zap2it_extra_install
zap2it_extra_install:
	install -m 644 src/zap2it.synocron $(STAGING_DIR)/etc/zap2it.synocron
