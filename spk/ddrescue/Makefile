SPK_NAME = ddrescue
SPK_VERS = 1
SPK_REV = 21
SPK_ICON = src/gnu.png
DSM_UI_DIR = app

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = GNU ddrescue is a data recovery tool. It copies data from one file or block device i.e. hard disc, cdrom, etc to another, trying to rescue the good parts first in case of read errors
RELOAD_UI = no
DISPLAY_NAME = ddrescue
STARTABLE = no
BETA = 1
CHANGELOG = Updating to 1.21

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

HOMEPAGE = https://www.gnu.org/software/ddrescue/ddrescue.html
LICENSE  = GPLv2/GPLv3

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

include ../../mk/spksrc.spk.mk

