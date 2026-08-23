SPK_NAME = eza
SPK_VERS = 0.23.5
SPK_REV = 1

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

DEPENDS = cross/eza

include ../../mk/spksrc.common.mk
ifeq ($(call version_ge,$(TC_RUSTC),1.85),1)
DEPENDS = cross/eza-latest
else
SPK_VERS = 0.23.4
endif

MAINTAINER = SynoCommunity
DESCRIPTION = A modern replacement for 'ls'.
STARTABLE = no

HOMEPAGE = https://eza.rocks/
LICENSE = MIT

SPK_COMMANDS = bin/eza

include ../../mk/spksrc.spk.mk
