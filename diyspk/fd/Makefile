SPK_NAME = fd
SPK_VERS = 10.4.2
SPK_REV = 1

DEPENDS = cross/fd

MIN_GLIBC_VERSION = 2.9

include ../../mk/spksrc.common.mk
ifeq ($(call version_lt,$(TC_RUSTC),1.85),1)
SPK_VERS = 10.3.0
endif

MAINTAINER = SynoCommunity
DESCRIPTION = fd is a program to find entries in your filesystem. It is a simple, fast and user-friendly alternative to find. While it does not aim to support all of find's powerful functionality, it provides sensible (opinionated) defaults for a majority of use cases.
STARTABLE = no

HOMEPAGE = https://github.com/sharkdp/fd
LICENSE = Apache 2.0 / MIT

SPK_COMMANDS = bin/fd

include ../../mk/spksrc.spk.mk
