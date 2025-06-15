SPK_NAME = gnupg
SPK_VERS = 2.4.2
SPK_REV = 6
SPK_ICON = src/gnupg.png

DEPENDS = cross/gnupg

MAINTAINER = SynoCommunity
DESCRIPTION = GnuPG allows to encrypt and sign your data and communication, features a versatile key management system as well as access modules for all kinds of public key directories.
STARTABLE = no
DISPLAY_NAME = GnuPG
CHANGELOG = "1. Update gnupg to 2.4.2<br/>2. Update shared libraries.<br/>3. Fix key generation for aarch64 on DSM 6."

HOMEPAGE = https://www.gnupg.org/
LICENSE  = GPLv3

SPK_COMMANDS = bin/gpg
SPK_COMMANDS += bin/gpg-agent
SPK_COMMANDS += bin/gpg-card
SPK_COMMANDS += bin/gpg-connect-agent
SPK_COMMANDS += bin/gpgconf
SPK_COMMANDS += bin/gpgsm
SPK_COMMANDS += bin/gpgscm
SPK_COMMANDS += bin/gpgtar
SPK_COMMANDS += bin/gpgsplit
SPK_COMMANDS += bin/gpgparsemail
SPK_COMMANDS += bin/gpgv
SPK_COMMANDS += bin/gpg-error
SPK_COMMANDS += bin/gpg-wks-client
SPK_COMMANDS += bin/gpg-wks-server
SPK_COMMANDS += bin/kbxutil
SPK_COMMANDS += bin/watchgnupg

include ../../mk/spksrc.spk.mk
