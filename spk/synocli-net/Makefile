SPK_NAME = synocli-net
SPK_VERS = 2.0
SPK_REV = 10
SPK_ICON = src/synocli-net.png

DEPENDS = cross/screen cross/tmux cross/nmap cross/links cross/socat
DEPENDS += cross/rsync cross/autossh cross/arp-scan
DEPENDS += cross/mtr
DEPENDS += cross/etherwake

OPTIONAL_DEPENDS = cross/sshfs cross/ser2net

include ../../mk/spksrc.archs.mk

OPTIONAL_DESC =

ifneq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
DEPENDS += cross/ser2net
DEPENDS += cross/sshfs 
OPTIONAL_DESC := $(OPTIONAL_DESC)", sshfs, ser2net"
endif

MAINTAINER = ymartin59
DESCRIPTION = "SynoCli Network Tools provides a set of small command-line utilities: screen, tmux, socat, nmap, arp-scan, mtr \(My traceroute\), links, sshfs, rsync, autossh, etherwake$(OPTIONAL_DESC). Credits to Sebastian Schmidt \(publicarray\) for icons."
DISPLAY_NAME = SynoCli Network Tools
STARTABLE = no
CHANGELOG = "Remove fritzctl because it is unsupported on golang 1.16."

HOMEPAGE = https://github.com/SynoCommunity/spksrc/wiki/FAQ-SynoCliNet
LICENSE  = Each tool is licensed under it\'s respective license.

SPK_COMMANDS = bin/screen
SPK_COMMANDS += bin/tmux
SPK_COMMANDS += bin/nmap bin/nping bin/ndiff
SPK_COMMANDS += bin/arp-scan bin/arp-fingerprint bin/get-iab bin/get-oui
SPK_COMMANDS += bin/links
SPK_COMMANDS += bin/sshfs
SPK_COMMANDS += bin/fusermount
SPK_COMMANDS += bin/socat bin/procan bin/filan
SPK_COMMANDS += bin/rsync
SPK_COMMANDS += bin/autossh
SPK_COMMANDS += bin/scp bin/sftp bin/slogin bin/ssh bin/ssh-add bin/ssh-agent bin/ssh-keygen bin/ssh-keyscan
SPK_COMMANDS += libexec/sftp-server libexec/ssh-keysign libexec/ssh-pkcs11-helper libexec/ssh-sk-helper
SPK_COMMANDS += sbin/sshd
SPK_COMMANDS += sbin/ser2net
SPK_COMMANDS += sbin/mtr sbin/mtr-packet
SPK_COMMANDS += bin/etherwake

include ../../mk/spksrc.spk.mk
