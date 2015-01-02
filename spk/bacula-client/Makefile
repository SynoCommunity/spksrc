SPK_NAME = bacula-client
SPK_VERS = 7.0.5
SPK_REV = 1
SPK_ICON = src/bacula.png

DEPENDS = cross/bacula

MAINTAINER = S.Falco
DESCRIPTION = Bacula is an open source backup system.  This is the client part of Bacula.
DISPLAY_NAME = Bacula Client

HOMEPAGE = http://bacula.org/
LICENSE  = AGPLv3

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

include ../../mk/spksrc.spk.mk
