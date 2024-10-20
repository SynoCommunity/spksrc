SPK_NAME = image-optim
SPK_VERS = 1.0
SPK_REV = 1

# pngquant (pngquant3) must be built first
OPTIONAL_DEPENDS = cross/pngquant
include ../../mk/spksrc.archs.mk
ifneq ($(findstring $(ARCH), $(OLD_PPC_ARCHS)),$(ARCH))
DEPENDS = cross/pngquant
endif

DEPENDS += cross/jpegoptim cross/pngcrush cross/advancecomp

MAINTAINER = SynoCommunity
DESCRIPTION = Several utilities for image optimization \(pngquant, jpegoptim, pngcrush, advancecomp\)
DISPLAY_NAME = Image Optimizers
STARTABLE = no

LICENSE = GPLv3

SPK_COMMANDS = bin/pngquant bin/jpegoptim bin/pngcrush bin/advmng bin/advpng

include ../../mk/spksrc.spk.mk
