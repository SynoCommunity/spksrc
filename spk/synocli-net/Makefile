SPK_NAME = synocli-net
SPK_VERS = 1.2
SPK_REV = 2
SPK_ICON = src/synocli-net.png

include ../../mk/spksrc.common.mk

DEPENDS = cross/screen cross/tmux cross/nmap cross/sshfs cross/mosh cross/socat
DEPENDS += cross/rsync
OPTIONAL_DEPENDS = cross/fritzctl

OPTIONAL_DESC =

ifneq ($(findstring $(ARCH),$(PPC_ARCHES)),$(ARCH))
DEPENDS += cross/fritzctl
OPTIONAL_DESC := $(OPTIONAL_DESC)", fritzctl"
endif



# Requirement for Mosh
SPK_DEPENDS = "Perl>=5.14"

MAINTAINER = ymartin59
DESCRIPTION = "SynoCli Network Tools provides a set of small command-line utilities: screen, tmux, mosh, socat, nmap, sshfs, rsync$(OPTIONAL_DESC). Credits to Sebastian Schmidt \(publicarray\) for icons"
DISPLAY_NAME = SynoCli Network Tools
STARTABLE = no
CHANGELOG = "1. Add rsync"

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

include ../../mk/spksrc.spk.mk
