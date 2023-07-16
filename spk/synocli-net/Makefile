SPK_NAME = synocli-net
SPK_VERS = 2.3
SPK_REV = 17
SPK_ICON = src/synocli-net.png

DEPENDS = cross/screen cross/tmux cross/links cross/socat
DEPENDS += cross/rsync cross/autossh cross/arp-scan
DEPENDS += cross/mtr
DEPENDS += cross/etherwake
DEPENDS += cross/inetutils
DEPENDS += cross/netcat

OPTIONAL_DEPENDS = cross/sshfs2 cross/sshfs3 cross/ser2net cross/bind cross/aria2 cross/nmap cross/nmap_7.92

include ../../mk/spksrc.common.mk

OPTIONAL_DESC =

ifneq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
DEPENDS += cross/bind
OPTIONAL_DESC := $(OPTIONAL_DESC)", arpaname, delv, dig, mdig"
DEPENDS += cross/ser2net
OPTIONAL_DESC := $(OPTIONAL_DESC)", ser2net"
DEPENDS += cross/nmap
else
DEPENDS += cross/nmap_7.92
endif

ifeq ($(call version_lt,${TCVERSION},6.0)$(call version_ge,${TCVERSION},3.0),11)
# DSM 3.x - 5.x
DEPENDS += cross/sshfs2
else ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
# qoriq DSM 6.x
DEPENDS += cross/sshfs2
else
DEPENDS += cross/sshfs3
endif

ifneq ($(findstring $(ARCH),$(OLD_PPC_ARCHS) $(ARMv5_ARCHS)),$(ARCH))
ifneq ($(call version_lt,${TCVERSION},6.0)$(call version_ge,${TCVERSION},3.0),11)
DEPENDS += cross/aria2
OPTIONAL_DESC := $(OPTIONAL_DESC)", aria2c"
endif
endif


MAINTAINER = ymartin59
DESCRIPTION = "SynoCli Network Tools provides a set of small command-line utilities: screen, tmux, socat, nmap, arp-scan, mtr \(My traceroute\), links, rsync, autossh \(including openssh, sftp and scp\), etherwake, telnet, whois, sshfs$(OPTIONAL_DESC)."
DISPLAY_NAME = SynoCli Network Tools
STARTABLE = no
CHANGELOG = "1. Add netcat.<br/>2. Update openssl to v1.1.1u.<br/>3. Update nmap to v7.94 and include ncat (latest nmap for old ppc archs is v7.92).<br/>4. Update ser2net to v4.3.12."

HOMEPAGE = https://github.com/SynoCommunity/spksrc/wiki/FAQ-SynoCliNet
LICENSE  = Each tool is licensed under it\'s respective license.

SPK_COMMANDS = bin/screen
SPK_COMMANDS += bin/tmux
SPK_COMMANDS += bin/nmap bin/nping bin/ndiff bin/ncat
SPK_COMMANDS += bin/arp-scan bin/arp-fingerprint bin/get-iab bin/get-oui
SPK_COMMANDS += bin/links
SPK_COMMANDS += bin/sshfs
SPK_COMMANDS += bin/fusermount bin/fusermount3
SPK_COMMANDS += sbin/mount.fuse sbin/mount.fuse3
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
SPK_COMMANDS += bin/nc bin/netcat

include ../../mk/spksrc.spk.mk
