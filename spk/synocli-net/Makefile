SPK_NAME = synocli-net
SPK_VERS = 10.0
SPK_REV = 23
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
DEPENDS += cross/sshfs
DEPENDS += cross/nmap

OPTIONAL_DEPENDS  = cross/screen cross/screen5
OPTIONAL_DEPENDS += cross/ser2net
OPTIONAL_DEPENDS += cross/bind_9.20 cross/bind_9.18 cross/bind_9.16
OPTIONAL_DEPENDS += cross/aria2

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
endif
else
# DSM 6
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
DEPENDS += cross/bind_9.16
else ifeq ($(ARCH)-$(TCVERSION),x86-5.2)
DEPENDS += cross/bind_9.16
else
DEPENDS += cross/bind_9.18
endif
endif
endif


ifneq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
DEPENDS += cross/ser2net
OPTIONAL_DESC := $(OPTIONAL_DESC)", ser2net"
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

DOCS_URL = "\<a target=\"_blank\" href=\"https://docs.synocommunity.com/packages/synocli-net/\"\>SynoCli Network Tools\</a\>"

CHANGELOG  = "1. Fix sshd, which could not start: install the sshd-session and sshd-auth helpers that OpenSSH has required since v9.8. <br/>"
CHANGELOG += "<br/>For package details and specific licences see $(DOCS_URL)".


HOMEPAGE = https://docs.synocommunity.com/packages/synocli-net/
LICENSE = Each tool is licensed under it\'s respective license.

SPK_COMMANDS  = bin/screen
SPK_COMMANDS += bin/tmux
SPK_COMMANDS += bin/nmap bin/nping bin/ncat
SPK_COMMANDS += bin/arp-scan bin/arp-fingerprint
SPK_COMMANDS += bin/links
SPK_COMMANDS += bin/sshfs
SPK_COMMANDS += bin/socat bin/socat1 bin/procan bin/filan
SPK_COMMANDS += bin/socat-broker.sh bin/socat-chain.sh bin/socat-mux.sh
SPK_COMMANDS += bin/rsync
SPK_COMMANDS += bin/xxh128sum bin/xxh32sum bin/xxh64sum bin/xxhsum
SPK_COMMANDS += bin/autossh
SPK_COMMANDS += bin/scp bin/sftp bin/slogin bin/ssh bin/ssh-add bin/ssh-agent bin/ssh-keygen bin/ssh-keyscan
SPK_USR_LOCAL_LINKS += bin:libexec/sftp-server bin:libexec/ssh-keysign bin:libexec/ssh-pkcs11-helper bin:libexec/ssh-sk-helper
SPK_USR_LOCAL_LINKS += bin:libexec/sshd-auth bin:libexec/sshd-session
SPK_COMMANDS += sbin/sshd
SPK_COMMANDS += sbin/ser2net bin/gensiot bin/gsh bin/gtlssh bin/gtlssh-keygen
SPK_COMMANDS += sbin/mtr sbin/mtr-packet
SPK_COMMANDS += bin/etherwake
SPK_COMMANDS += bin/telnet bin/whois
SPK_COMMANDS += bin/arpaname bin/delv bin/dig bin/mdig
SPK_COMMANDS += bin/aria2c
SPK_COMMANDS += bin/nc bin/netcat
SPK_COMMANDS += bin/imapfilter

include ../../mk/spksrc.spk.mk
