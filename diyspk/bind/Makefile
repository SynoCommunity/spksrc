SPK_NAME = bind
SPK_REV = 1

MAINTAINER = SynoCommunity
DESCRIPTION = BIND \(Berkeley Internet Name Domain\) is a complete, highly portable implementation of the DNS \(Domain Name System\) protocol.
STARTABLE = no

HOMEPAGE = https://www.isc.org/
LICENSE = MPL 2.0

SPK_COMMANDS = bin/arpaname bin/delv bin/dig bin/mdig

include ../../mk/spksrc.common.mk

# The newest bind whose floors the arch meets, as cross/bind picks it: spelled out here,
# where the version it names becomes the package's.
$(call depend,cross/bind-9.20|cross/bind-9.18|cross/bind-9.16)
# Its PKG_VERS, read lazily: spksrc.spk.mk resolves the alternative (depend.mk) before it
# names the package file. 9.20's where no arch is set.
SPK_VERS = $(call read_makefile_var,../../$(or $(firstword $(filter cross/bind-%,$(DEPENDS))),cross/bind-9.20)/Makefile,PKG_VERS)

include ../../mk/spksrc.spk.mk
