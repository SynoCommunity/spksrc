SPK_NAME = synocli-net
SPK_VERS = 1.1
SPK_REV = 2
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
CHANGELOG = "3. Build sshfs 2.10 with fuse updated to v2.9.9"

HOMEPAGE   = https://github.com/SynoCommunity/spksrc/wiki/FAQ-SynoCliNet
LICENSE    = Mixed

SERVICE_SETUP = src/service-setup.sh

include ../../mk/spksrc.spk.mk
