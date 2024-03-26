SPK_NAME = bind
SPK_VERS = 9.16.28
SPK_REV = 1

DEPENDS = cross/bind

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

MAINTAINER = SynoCommunity
DESCRIPTION = BIND (Berkeley Internet Name Domain) is a complete, highly portable implementation of the DNS (Domain Name System) protocol.
STARTABLE = no

HOMEPAGE = https://www.isc.org/
LICENSE = MPL 2.0

SPK_COMMANDS = bin/arpaname bin/delv bin/dig bin/mdig
SPK_COMMANDS += sbin/getcap sbin/getpcaps sbin/capsh sbin/setcap

include ../../mk/spksrc.spk.mk
