SPK_NAME = kopia
SPK_VERS = 0.13.0
SPK_REV = 1
SPK_ICON = src/kopia.png

DEPENDS = cross/kopia

UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(i686_ARCHS)

MAINTAINER = SynoCommunity
DISPLAY_NAME = Kopia
DESCRIPTION = Kopia is a fast and secure open-source backup/restore tool that allows you to create encrypted snapshots of your data and save the snapshots to remote or cloud storage of your choice, to network-attached storage or server, or locally on your machine.
HOMEPAGE = https://kopia.io/
LICENSE = Apache 2.0
CHANGELOG = "Initial package release"

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 51515
ADMIN_PORT = $(SERVICE_PORT)

SPK_COMMANDS = bin/kopia

include ../../mk/spksrc.spk.mk
