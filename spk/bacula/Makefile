SPK_NAME = bacula
SPK_VERS = 5.2.13
SPK_REV = 3
SPK_ICON = src/bacula.png
DSM_UI_DIR = app

DEPENDS = cross/busybox cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = Bacula is a set of Open Source, computer programs that permit you to manage backup, recovery, and verification of computer data across a network of computers. This part is the File Daemon.
ADMIN_PORT =
RELOAD_UI = yes
DISPLAY_NAME = Bacula File Daemon

HOMEPAGE = http://www.bacula.org/
LICENSE  =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

BUSYBOX_CONFIG = usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk
