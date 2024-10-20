SPK_NAME = bind
SPK_VERS = 9.17.22
SPK_REV = 1

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

OPTIONAL_DEPENDS = cross/bind cross/bind_9.16

MAINTAINER = SynoCommunity
DESCRIPTION = BIND \(Berkeley Internet Name Domain\) is a complete, highly portable implementation of the DNS \(Domain Name System\) protocol.
STARTABLE = no

HOMEPAGE = https://www.isc.org/
LICENSE = MPL 2.0

SPK_COMMANDS = bin/arpaname bin/delv bin/dig bin/mdig

include ../../mk/spksrc.spk.mk

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
DEPENDS += cross/bind_9.16
SPK_VERS = 9.16.45
else
DEPENDS += cross/bind
endif
