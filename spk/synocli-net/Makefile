SPK_NAME = synocli-net
SPK_VERS = 1.1
SPK_REV = 3
SPK_ICON = src/synocli-net.png

include ../../mk/spksrc.common.mk

DEPENDS = cross/screen cross/tmux cross/nmap cross/sshfs cross/mosh cross/socat
ifneq ($(findstring $(ARCH),$(PPC_ARCHES)),$(ARCH))
DEPENDS += cross/fritzctl
endif

# Requirement for Mosh
SPK_DEPENDS = "Perl>=5.14"

MAINTAINER = ymartin59
DESCRIPTION = "SynoCli Network Tools provides a set of small command-line utilities: screen, tmux, mosh, socat, nmap, sshfs, fritzctl. Credits to Sebastian Schmidt \(publicarray\) for icons"
DISPLAY_NAME = SynoCli Network Tools
STARTABLE = no
CHANGELOG = "fritzctl built with go 1.13.1"

HOMEPAGE   = https://github.com/SynoCommunity/spksrc/wiki/FAQ-SynoCliNet
LICENSE    = Each tool is licensed unter its respective license.

SERVICE_SETUP = src/service-setup.sh

include ../../mk/spksrc.spk.mk
