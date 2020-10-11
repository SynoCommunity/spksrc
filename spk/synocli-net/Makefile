SPK_NAME = synocli-net
SPK_VERS = 1.5
SPK_REV = 5
SPK_ICON = src/synocli-net.png

DEPENDS = cross/screen cross/tmux cross/nmap cross/links cross/sshfs cross/socat
DEPENDS += cross/rsync cross/autossh cross/arp-scan

OPTIONAL_DEPENDS = cross/fritzctl cross/ser2net

include ../../mk/spksrc.common.mk

OPTIONAL_DESC =

ifneq ($(findstring $(ARCH),$(PPC_ARCHES)),$(ARCH))
DEPENDS += cross/fritzctl
OPTIONAL_DESC := $(OPTIONAL_DESC)", fritzctl"
endif

ifneq ($(findstring $(ARCH), powerpc ppc824x ppc853x ppc854x),$(ARCH))
DEPENDS += cross/ser2net
OPTIONAL_DESC := $(OPTIONAL_DESC)", ser2net"
endif

MAINTAINER = ymartin59
DESCRIPTION = "SynoCli Network Tools provides a set of small command-line utilities: screen, tmux, socat, nmap, arp-scan, links, sshfs, rsync, autossh$(OPTIONAL_DESC). Credits to Sebastian Schmidt \(publicarray\) for icons"
DISPLAY_NAME = SynoCli Network Tools
STARTABLE = no
CHANGELOG = "1. update openssl to 1.1 for dependent packages \(tmux, nmap, socat, autossh, ser2net\).<br/>2. Add autossh<br/>3. Add arp-scan v1.9.7<br/>4. Add links v2.21<br/>5. Update nmap to version 7.80<br/>6. Update screen to version 4.8.0<br/>7. Update socat to version 1.7.3.4<br/>8. Remove mosh and remove dependency of Perl \(mosh is provided as dedicated package now\)"

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
SPK_COMMANDS += sbin/ser2net

include ../../mk/spksrc.spk.mk
