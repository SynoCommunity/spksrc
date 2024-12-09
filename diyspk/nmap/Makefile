SPK_NAME = nmap
SPK_VERS = 7.94
SPK_REV = 1
SPK_ICON = src/nmap.png

OPTIONAL_DEPENDS = cross/nmap cross/nmap_7.92

MAINTAINER = SynoCommunity
DESCRIPTION = Nmap \(Network Mapper\) is a free and open source utility for network discovery and security auditing.
DISPLAY_NAME = nmap
STARTABLE = no

HOMEPAGE = https://nmap.org/
LICENSE  = https://svn.nmap.org/nmap/LICENSE

include ../../mk/spksrc.archs.mk
ifeq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
DEPENDS = cross/nmap_7.92
SPK_VERS = 7.92
else
DEPENDS = cross/nmap
endif

SPK_COMMANDS = bin/ncat bin/nmap bin/nping

include ../../mk/spksrc.spk.mk
