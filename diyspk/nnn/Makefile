SPK_NAME = nnn
SPK_VERS = 5.0
SPK_REV = 1
SPK_ICON = src/nnn.png

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

include ../../mk/spksrc.common.mk

ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
ifneq ($(findstring $(ARCH),comcerto2k),$(ARCH))
DEPENDS = cross/nnn
else
# comcerto2k for DSM>=7
DEPENDS = cross/nnn_4.0
SPK_VERS = 4.0
endif
else ifeq ($(findstring $(ARCH),$(64bit_ARCHS)),$(ARCH))
DEPENDS = cross/nnn_4.8
SPK_VERS = 4.8
else
DEPENDS = cross/nnn_4.0
SPK_VERS = 4.0
endif

MAINTAINER = SynoCommunity
DESCRIPTION = n³ The unorthodox terminal file manager.
DISPLAY_NAME = n³
STARTABLE = no

HOMEPAGE = https://github.com/jarun/nnn
LICENSE  = 2-clause BSD

SPK_COMMANDS = bin/nnn

include ../../mk/spksrc.spk.mk
