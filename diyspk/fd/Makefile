SPK_NAME = fd
SPK_VERS = 10.3.0
SPK_REV = 1

DEPENDS = cross/fd

UNSUPPORTED_ARCHS  = $(OLD_PPC_ARCHS)
UNSUPPORTED_ARCHS += $(ARMv5_ARCHS)
UNSUPPORTED_ARCHS += $(ARMv7L_ARCHS)

MAINTAINER = SynoCommunity
DESCRIPTION = fd is a program to find entries in your filesystem. It is a simple, fast and user-friendly alternative to find. While it does not aim to support all of find's powerful functionality, it provides sensible (opinionated) defaults for a majority of use cases.
STARTABLE = no

HOMEPAGE = https://github.com/sharkdp/fd
LICENSE = Apache 2.0 / MIT

SPK_COMMANDS = bin/fd

include ../../mk/spksrc.spk.mk
