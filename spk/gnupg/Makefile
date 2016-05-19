SPK_NAME = gnupg
SPK_VERS = 2.1.6
SPK_REV = 2
SPK_ICON = src/gnupg.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = GnuPG allows to encrypt and sign your data and communication, features a versatile key management system as well as access modules for all kinds of public key directories.
STARTABLE = no
DISPLAY_NAME = GnuPG
CHANGELOG = Add pinentry dependency
BETA = 1

HOMEPAGE = http://www.gnupg.org/
LICENSE  = GNU General Public License

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

include ../../mk/spksrc.spk.mk
