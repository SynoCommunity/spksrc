SPK_NAME = nmap
SPK_VERS = 7.99
SPK_REV = 1
SPK_ICON = src/nmap.png

DEPENDS = cross/nmap

MAINTAINER = SynoCommunity
DESCRIPTION = Nmap \(Network Mapper\) is a free and open source utility for network discovery and security auditing.
DISPLAY_NAME = nmap
STARTABLE = no

HOMEPAGE = https://nmap.org/
LICENSE  = https://svn.nmap.org/nmap/LICENSE

include ../../mk/spksrc.common.mk
ifeq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
SPK_VERS = 7.92
else ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(PPC_ARCHS)),$(ARCH))
SPK_VERS = 7.98
endif

SPK_COMMANDS = bin/ncat bin/nmap bin/nping

include ../../mk/spksrc.spk.mk
