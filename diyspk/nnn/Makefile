SPK_NAME = nnn
SPK_VERS = 5.1
SPK_REV = 1
SPK_ICON = src/nnn.png

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

DEPENDS = cross/nnn

include ../../mk/spksrc.common.mk
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
ifeq ($(findstring $(ARCH),$(64bit_ARCHS)),$(ARCH))
SPK_VERS = 4.8
else
SPK_VERS = 4.0
endif
endif

MAINTAINER = SynoCommunity
DESCRIPTION = n³ The unorthodox terminal file manager.
DISPLAY_NAME = n³
STARTABLE = no

HOMEPAGE = https://github.com/jarun/nnn
LICENSE = 2-clause BSD

SPK_COMMANDS = bin/nnn

include ../../mk/spksrc.spk.mk
