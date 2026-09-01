SPK_NAME = sd
SPK_VERS = 1.1.0
SPK_REV = 1

DEPENDS = cross/sd

include ../../mk/spksrc.common.mk
ifeq ($(call version_lt,$(TC_RUSTC),1.85),1)
SPK_VERS = 1.0.0
endif

MAINTAINER = SynoCommunity
DESCRIPTION = Intuitive find & replace CLI \(sed alternative)\.
STARTABLE = no

HOMEPAGE = https://github.com/chmln/sd#readme
LICENSE = MIT

SPK_COMMANDS = bin/sd

include ../../mk/spksrc.spk.mk
