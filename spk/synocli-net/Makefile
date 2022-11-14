SPK_NAME = synocli-net
SPK_VERS = 2.2
SPK_REV = 14
SPK_ICON = src/synocli-net.png

DEPENDS = cross/screen cross/tmux cross/nmap cross/links cross/socat
DEPENDS += cross/rsync cross/autossh cross/arp-scan
DEPENDS += cross/mtr
DEPENDS += cross/etherwake
DEPENDS += cross/inetutils

OPTIONAL_DEPENDS = cross/sshfs cross/ser2net cross/bind cross/aria2

include ../../mk/spksrc.common.mk

OPTIONAL_DESC =

ifneq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
DEPENDS += cross/bind
OPTIONAL_DESC := $(OPTIONAL_DESC)", arpaname, delv, dig, mdig"
DEPENDS += cross/ser2net
DEPENDS += cross/sshfs 
OPTIONAL_DESC := $(OPTIONAL_DESC)", sshfs, ser2net"
endif

ifneq ($(findstring $(ARCH),$(OLD_PPC_ARCHS) $(ARMv5_ARCHS)),$(ARCH))
ifneq ($(call version_lt,${TCVERSION},6.0)$(call version_gt,${TCVERSION},2.0),11)
DEPENDS += cross/aria2
OPTIONAL_DESC := $(OPTIONAL_DESC)", aria2c"
endif
endif


MAINTAINER = ymartin59
DESCRIPTION = "SynoCli Network Tools provides a set of small command-line utilities: screen, tmux, socat, nmap, arp-scan, mtr \(My traceroute\), links, rsync, autossh, etherwake, telnet, whois$(OPTIONAL_DESC)."
DISPLAY_NAME = SynoCli Network Tools
STARTABLE = no
CHANGELOG = "1. Update openssl to v1.1.1s.<br/>2. Update bind to v9.16.28.<br/>3. Update screen to v4.9.0.<br/>4. Update links to v2.26.<br/>5. Update mtr to v0.95.<br/>6. Update ser2net to v4.3.10.<br/>7. Update rsync to v3.2.4.<br/>8. Update socat to v1.7.4.4.<br/>9. Update telnet and whois (update inetutils to v2.4)."

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
SPK_COMMANDS += bin/telnet bin/whois
SPK_COMMANDS += bin/arpaname bin/delv bin/dig bin/mdig
SPK_COMMANDS += bin/aria2c

include ../../mk/spksrc.spk.mk
