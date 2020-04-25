SPK_NAME = ps3netsrv
SPK_VERS = 1.47.15
SPK_REV = 4
SPK_ICON = src/${SPK_NAME}.png

REQUIRED_DSM = 5.0

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = Anonym-tsk
# From Cobra/Deank
DESCRIPTION = Allows PS3 content to be loaded from network
DESCRIPTION_FRE = Fournit l\'accès par le réseau aux contenus pour PS3
RELOAD_UI = yes
STARTABLE = yes
DISPLAY_NAME = ps3netsrv
CHANGELOG =

HOMEPAGE = https://github.com/aldostools/webMAN-MOD
LICENSE  = GPL

WIZARDS_DIR = src/wizard/

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_WIZARD_SHARE = wizard_dir
SERVICE_PORT = 38008
SERVICE_COMMAND = $${SYNOPKG_PKGDEST}/ps3netsrv-starter.sh
NO_SERVICE_SHORTCUT = yes

POST_STRIP_TARGET = ps3netsrv_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: ps3netsrv_extra_install
ps3netsrv_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/ps3netsrv.conf $(STAGING_DIR)/var/ps3netsrv.conf
	install -m 755 src/ps3netsrv-starter.sh $(STAGING_DIR)/ps3netsrv-starter.sh
