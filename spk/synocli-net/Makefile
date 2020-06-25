SPK_NAME = synocli-net
SPK_VERS = 1.4
SPK_REV = 4
SPK_ICON = src/synocli-net.png

DEPENDS = cross/screen cross/tmux cross/nmap cross/sshfs cross/mosh cross/socat
DEPENDS += cross/rsync cross/autossh

# Requirement for Mosh
SPK_DEPENDS = "Perl>=5.14"

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
DESCRIPTION = "SynoCli Network Tools provides a set of small command-line utilities: screen, tmux, mosh, socat, nmap, sshfs, rsync, autossh$(OPTIONAL_DESC). Credits to Sebastian Schmidt \(publicarray\) for icons"
DISPLAY_NAME = SynoCli Network Tools
STARTABLE = no
CHANGELOG = "1. Add autossh"

HOMEPAGE = https://github.com/SynoCommunity/spksrc/wiki/FAQ-SynoCliNet
LICENSE  = Each tool is licensed under it\'s respective license.

SPK_COMMANDS = bin/screen
SPK_LINKS = /usr/local/bin/tmux:bin/tmux-utf8
SPK_COMMANDS += bin/nmap bin/nping bin/ndiff
SPK_COMMANDS += bin/sshfs
SPK_COMMANDS += bin/fusermount
SPK_COMMANDS += bin/mosh bin/mosh-client bin/mosh-server
SPK_COMMANDS += bin/socat bin/procan bin/filan
SPK_COMMANDS += bin/fritzctl
SPK_COMMANDS += bin/rsync
SPK_COMMANDS += bin/autossh
SPK_COMMANDS += sbin/ser2net

include ../../mk/spksrc.spk.mk
