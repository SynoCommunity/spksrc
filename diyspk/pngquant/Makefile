SPK_NAME = pngquant
SPK_VERS = 3.0.3
SPK_REV = 1


MAINTAINER = SynoCommunity
DESCRIPTION = pngquant is a command-line utility and a library for lossy compression of PNG images.
DISPLAY_NAME = pngquant
STARTABLE = no

HOMEPAGE = https://pngquant.org/
LICENSE = GPL

include ../../mk/spksrc.archs.mk
ifeq ($(findstring $(ARCH),$(OLD_PPC_ARCHS) $(ARMv5_ARCHS)),$(ARCH))
# std=c11 not fully supported
DEPENDS = cross/pngquant2
SPK_VERS = 2.18.0
else
DEPENDS = cross/pngquant3
endif


SPK_COMMANDS = bin/pngquant

include ../../mk/spksrc.spk.mk
