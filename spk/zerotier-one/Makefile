SPK_NAME = zerotier-one
SPK_VERS = 1.16.2
SPK_REV = 1
SPK_ICON = src/zerotier-one.png

DEPENDS = cross/zerotier

REQUIRED_MIN_DSM = 7.0

MAINTAINER = MTSistemi
DESCRIPTION = ZeroTier One: join this NAS to your ZeroTier networks. Runs without root, needs no other package and restarts itself if it stops. The install wizard sets everything up.
DESCRIPTION_ITA = ZeroTier One: collega il NAS alle reti ZeroTier. Gira senza root, non richiede altri pacchetti e riparte da solo se si ferma. La procedura di installazione configura tutto.
DISPLAY_NAME = ZeroTier
CHANGELOG = "Initial release: ZeroTier One 1.16.2. Runs as the package user, never as root; the install wizard creates the boot-up task that grants the network capability, and a supervisor restarts the service if it stops. Takes over the node identity of a previous ZeroTier package. A DSM app for administrators shows the node and joins or leaves networks."
HOMEPAGE = https://www.zerotier.com
LICENSE = MPL-2.0
STARTABLE = yes

WIZARDS_DIR = src/wizard/

# DSM app (main menu, administrators only): generated into src/app by generate.ts.
DSM_UI_DIR = app
DSM_APP_NAME = SynoCommunity.ZeroTierOne.Instance

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
FWPORTS = src/zerotier-one.sc

SPK_COMMANDS = bin/zerotier-cli

POST_STRIP_TARGET = zerotier-one_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: zerotier-one_extra_install
zerotier-one_extra_install:
	install -m 755 -d $(STAGING_DIR)/bin
	install -m 755 src/zerotier-cli $(STAGING_DIR)/bin/zerotier-cli
	install -m 755 src/zerotier-one-supervise $(STAGING_DIR)/bin/zerotier-one-supervise
	install -m 755 src/zerotier-one-guard $(STAGING_DIR)/bin/zerotier-one-guard
	install -m 755 -d $(STAGING_DIR)/$(DSM_UI_DIR)
	cp -R src/app/. $(STAGING_DIR)/$(DSM_UI_DIR)/
	chmod -R u=rwX,go=rX $(STAGING_DIR)/$(DSM_UI_DIR)
	chmod 755 $(STAGING_DIR)/$(DSM_UI_DIR)/cgi/api.cgi
