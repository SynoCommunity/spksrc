SPK_NAME = kopia
SPK_VERS = 0.19.0
SPK_REV = 3
SPK_ICON = src/kopia.png

DEPENDS = cross/kopia

UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(i686_ARCHS)

MAINTAINER = SynoCommunity
DISPLAY_NAME = Kopia
DESCRIPTION = Kopia is a fast and secure open-source backup/restore tool that allows you to create encrypted snapshots of your data and save the snapshots to remote or cloud storage of your choice, to network-attached storage or server, or locally on your machine.
HOMEPAGE = https://kopia.io/
LICENSE = Apache 2.0
CHANGELOG = "Kopia updated to 0.19.0<br/>Changelog: <a target=\"_blank\" href=\"https://github.com/kopia/kopia/releases/tag/v0.19.0\">https://github.com/kopia/kopia/releases/tag/v0.19.0</a>"

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 51515
SERVICE_PORT_PROTOCOL = https
ADMIN_PORT = $(SERVICE_PORT)
ADMIN_PROTOCOL = https
WIZARDS_DIR = src/wizard/

POST_STRIP_TARGET = kopia_extra_install

SPK_COMMANDS = bin/kopia

include ../../mk/spksrc.spk.mk

.PHONY: kopia_extra_install
kopia_extra_install:
	@$(MSG) Create config folders under var
	@install -d $(STAGING_DIR)/var/config $(STAGING_DIR)/var/cache
