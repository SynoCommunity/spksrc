SPK_NAME = ps3netsrv
SPK_VERS = 1.47.08
SPK_REV = 0
SPK_ICON = src/ps3netsrv.png

REQUIRED_DSM = 6.0
UNSUPPORTED_ARCHS = $(PPC_ARCHES)

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = Cobra/Deank
DESCRIPTION = Allows PS3 content to be loaded from network
RELOAD_UI = yes
STARTABLE = yes
DISPLAY_NAME = ps3netsrv
CHANGELOG =

HOMEPAGE = https://github.com/aldostools/webMAN-MOD
LICENSE  = GPL

WIZARDS_DIR = src/wizard/

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

STRIP_TARGET = nop # TODO: maybe not needed
POST_STRIP_TARGET = ps3netsrv_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: ps3netsrv_extra_install
ps3netsrv_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/ps3netsrv.conf $(STAGING_DIR)/var/ps3netsrv.conf
