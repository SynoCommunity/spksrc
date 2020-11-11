SPK_NAME = gnupg
SPK_VERS = 2.2.23
SPK_REV = 3
SPK_ICON = src/gnupg.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = GnuPG allows to encrypt and sign your data and communication, features a versatile key management system as well as access modules for all kinds of public key directories.
STARTABLE = no
DISPLAY_NAME = GnuPG
CHANGELOG = "1. Update gnupg to 2.2.23<br/>2. Update shared libraries"

HOMEPAGE = https://www.gnupg.org/
LICENSE  = GPLv3

SPK_COMMANDS = bin/gpg
SPK_COMMANDS += bin/gpg-agent
SPK_COMMANDS += bin/gpg-connect-agent
SPK_COMMANDS += bin/gpgconf
SPK_COMMANDS += bin/gpgsm
SPK_COMMANDS += bin/gpgscm
SPK_COMMANDS += bin/gpgtar
SPK_COMMANDS += bin/gpgsplit
SPK_COMMANDS += bin/gpgparsemail
SPK_COMMANDS += bin/gpgv
SPK_COMMANDS += bin/gpg-error
SPK_COMMANDS += bin/gpg-wks-server
SPK_COMMANDS += bin/kbxutil
SPK_COMMANDS += bin/watchgnupg

include ../../mk/spksrc.spk.mk
