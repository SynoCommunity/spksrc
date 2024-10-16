SPK_NAME = ps3netsrv
SPK_VERS = 1.47.46
SPK_REV = 9
SPK_ICON = src/${SPK_NAME}.png

DEPENDS = cross/ps3netsrv

MAINTAINER = Hirador
# webMAN MOD is a homebrew plugin for PlayStation®3 forked from the original webMAN/sMAN by DeanK with many features added.
DESCRIPTION = Allows PS3 content to be loaded from network. Please edit the default port “38008” to “14167” in your PS3's webMAN MOD Setup 
DESCRIPTION_FRE = Fournit l\'accès par le réseau aux contenus pour PS3. Veuillez modifier le port par défaut de "38008" à "14167" dans PS3 webMAN MOD Setup
DISPLAY_NAME = ps3netsrv
CHANGELOG = "Update to v1.47.46e with ps3netsrv 20240210a."

HOMEPAGE = https://github.com/aldostools/webMAN-MOD
LICENSE  = GPLv3

WIZARDS_DIR = src/wizard

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 14167
SERVICE_PORT_TITLE = $(DISPLAY_NAME)
WIZARDS_DIR = src/wizard/
SERVICE_WIZARD_SHARENAME = wizard_shared_folder_name
SERVICE_COMMAND = $${SYNOPKG_PKGDEST}/ps3netsrv-starter.sh
NO_SERVICE_SHORTCUT = yes

POST_STRIP_TARGET = ps3netsrv_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: ps3netsrv_extra_install
ps3netsrv_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/ps3netsrv.conf $(STAGING_DIR)/var/ps3netsrv.conf
	install -m 755 src/ps3netsrv-starter.sh $(STAGING_DIR)/ps3netsrv-starter.sh
