SPK_NAME = synocli-net
SPK_VERS = 2.6
SPK_REV = 21
SPK_ICON = src/synocli-net.png

DEPENDS  = cross/tmux
DEPENDS += cross/links
DEPENDS += cross/socat
DEPENDS += cross/rsync
DEPENDS += cross/autossh
DEPENDS += cross/arp-scan
DEPENDS += cross/mtr
DEPENDS += cross/etherwake
DEPENDS += cross/inetutils
DEPENDS += cross/netcat
DEPENDS += cross/imapfilter

OPTIONAL_DEPENDS  = cross/screen cross/screen5
OPTIONAL_DEPENDS += cross/sshfs2 cross/sshfs3 
OPTIONAL_DEPENDS += cross/ser2net
OPTIONAL_DEPENDS += cross/bind_9.20 cross/bind_9.18 cross/bind_9.16
OPTIONAL_DEPENDS += cross/aria2
OPTIONAL_DEPENDS += cross/nmap cross/nmap_7.92

include ../../mk/spksrc.common.mk

OPTIONAL_DESC =

ifeq ($(call version_lt,${TCVERSION},7.0),1)
DEPENDS += cross/screen
else ifeq ($(findstring $(ARCH),comcerto2k),$(ARCH))
DEPENDS += cross/screen
else
DEPENDS += cross/screen5
endif


ifneq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
# tools of cross/bind (v9.16, v9.18, v9.20)
OPTIONAL_DESC := $(OPTIONAL_DESC)", arpaname, delv, dig, mdig"
ifeq ($(call version_ge,${TCVERSION},7.0),1)
# DSM 7
ifneq ($(findstring $(ARCH),comcerto2k),$(ARCH))
DEPENDS += cross/bind_9.20
else
DEPENDS += cross/bind_9.18
SPK_VERS = 9.18.38
endif
else
# DSM 6
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
DEPENDS += cross/bind_9.16
SPK_VERS = 9.16.50
else ifeq ($(ARCH)-$(TCVERSION),x86-5.2)
DEPENDS += cross/bind_9.16
SPK_VERS = 9.16.50
else
DEPENDS += cross/bind_9.18
SPK_VERS = 9.18.38
endif
endif
endif


ifneq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))

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
DESCRIPTION = "SynoCli Network Tools provides a set of small command-line utilities: screen, tmux, socat, nmap, arp-scan, mtr \(My traceroute\), links, rsync, xxhsum, autossh \(including openssh, sftp and scp\), etherwake, telnet, whois, sshfs, IMAPFilter$(OPTIONAL_DESC)."
DISPLAY_NAME = SynoCli Network Tools
STARTABLE = no
CHANGELOG  = "1. Add IMAPFilter v2.8.3. <br/>"
CHANGELOG += "2. Update bind to v9.20.11 (DSM 7); v9.18.38 (DSM 6); v9.16.50 (armv5 and armv7l). <br/>"
CHANGELOG += "3. Update inetutils from v2.5 to v2.6. <br/>"
CHANGELOG += "4. Update mtr from v0.95 to v0.96. <br/>"
CHANGELOG += "5. Update nmap from v7.95 to v7.97. <br/>"
CHANGELOG += "6. Update screen to v5.0.1 (DSM 7 only). <br/>"
CHANGELOG += "7. Update ser2net from v4.6.3 to v4.6.5. <br/>"
CHANGELOG += "8. Update socat from v1.8.0.2 to v1.8.0.3."


HOMEPAGE = https://github.com/SynoCommunity/spksrc/wiki/FAQ-SynoCliNet
LICENSE  = Each tool is licensed under it\'s respective license.

SPK_COMMANDS  = bin/screen
SPK_COMMANDS += bin/tmux
SPK_COMMANDS += bin/nmap bin/nping bin/ncat
SPK_COMMANDS += bin/arp-scan bin/arp-fingerprint
SPK_COMMANDS += bin/links
SPK_COMMANDS += bin/sshfs
SPK_COMMANDS += bin/fusermount bin/fusermount3
SPK_COMMANDS += sbin/mount.fuse sbin/mount.fuse3
SPK_COMMANDS += bin/socat bin/socat1 bin/procan bin/filan
SPK_COMMANDS += bin/socat-broker.sh bin/socat-chain.sh bin/socat-mux.sh
SPK_COMMANDS += bin/rsync
SPK_COMMANDS += bin/xxh128sum bin/xxh32sum bin/xxh64sum bin/xxhsum
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
SPK_COMMANDS += bin/imapfilter

include ../../mk/spksrc.spk.mk
