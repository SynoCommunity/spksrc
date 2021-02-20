SPK_NAME = synocli-net
SPK_VERS = 1.6
SPK_REV = 8
SPK_ICON = src/synocli-net.png

DEPENDS = cross/screen cross/tmux cross/nmap cross/links cross/sshfs cross/socat
DEPENDS += cross/rsync cross/autossh cross/arp-scan
DEPENDS += cross/imapfilter

OPTIONAL_DEPENDS = cross/fritzctl cross/ser2net

include ../../mk/spksrc.archs.mk

OPTIONAL_DESC =

ifneq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
DEPENDS += cross/fritzctl
OPTIONAL_DESC := $(OPTIONAL_DESC)", fritzctl"
endif

ifneq ($(findstring $(ARCH),$(OLD_PCC_ARCHS)),$(ARCH))
DEPENDS += cross/ser2net
OPTIONAL_DESC := $(OPTIONAL_DESC)", ser2net"
endif

MAINTAINER = ymartin59
DESCRIPTION = "SynoCli Network Tools provides a set of small command-line utilities: screen, tmux, socat, nmap, arp-scan, links, sshfs, rsync, autossh, IMAPFilter$(OPTIONAL_DESC). Credits to Sebastian Schmidt \(publicarray\) for icons"
DISPLAY_NAME = SynoCli Network Tools
STARTABLE = no
CHANGELOG = "Add IMAPFilter v2.7.5"

HOMEPAGE = https://github.com/SynoCommunity/spksrc/wiki/FAQ-SynoCliNet
LICENSE  = Each tool is licensed under it\'s respective license.

SPK_COMMANDS = bin/screen
SPK_LINKS = /usr/local/bin/tmux:bin/tmux-utf8
SPK_COMMANDS += bin/nmap bin/nping bin/ndiff
SPK_COMMANDS += bin/arp-scan bin/arp-fingerprint bin/get-iab bin/get-oui
SPK_COMMANDS += bin/links
SPK_COMMANDS += bin/sshfs
SPK_COMMANDS += bin/fusermount
SPK_COMMANDS += bin/socat bin/procan bin/filan
SPK_COMMANDS += bin/fritzctl
SPK_COMMANDS += bin/rsync
SPK_COMMANDS += bin/autossh
SPK_COMMANDS += bin/scp bin/sftp bin/slogin bin/ssh bin/ssh-add bin/ssh-agent bin/ssh-keygen bin/ssh-keyscan
SPK_COMMANDS += libexec/sftp-server libexec/ssh-keysign libexec/ssh-pkcs11-helper libexec/ssh-sk-helper
SPK_COMMANDS += sbin/sshd
SPK_COMMANDS += sbin/ser2net

SPK_COMMANDS += bin/imapfilter
SPK_LINKS += /usr/local/share/imapfilter:share/imapfilter

include ../../mk/spksrc.spk.mk
