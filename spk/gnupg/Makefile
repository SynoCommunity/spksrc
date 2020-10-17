SPK_NAME = gnupg
SPK_VERS = 2.2.23
SPK_REV = 3
SPK_ICON = src/gnupg.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = GnuPG allows to encrypt and sign your data and communication, features a versatile key management system as well as access modules for all kinds of public key directories.
STARTABLE = no
DISPLAY_NAME = GnuPG
CHANGELOG = "1. Update gnupg to 2.2.23<br/>2. Update libgcrypt to 1.8.6<br/>3. Update gnutls to 3.6<br/>4. update libgpg-error to 1.39"
BETA = 1

HOMEPAGE = http://www.gnupg.org/
LICENSE  = GNU General Public License

UNSUPPORTED_ARCHS = $(ARM5_ARCHES) powerpc ppc824x ppc853x ppc854x

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

include ../../mk/spksrc.spk.mk
