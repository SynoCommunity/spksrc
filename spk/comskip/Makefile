SPK_NAME = comskip
SPK_VERS = 0.83
SPK_REV = 15
SPK_ICON = src/comskip.png

FFMPEG_PACKAGE = ffmpeg8

# ffmpeg8 needs C11 -- gcc 4.9 or newer
MIN_GCC_VERSION = 4.9

# ffmpeg8 is built through the gcc 8.5 overlay wherever the vendor compiler falls short,
# so follow it: same condition, same compiler, one ABI across the chain. Linking an
# overlay-built ffmpeg8 with the vendor gcc fails on std::__cxx11 and CXXABI symbols its
# libstdc++ never had. Recursive (=): TC_GCC does not exist until the include below, and
# overlay.mk's `?=` must still see this assignment.
OVERLAY_GCC = $(if $(call version_lt,$(TC_GCC),$(MIN_GCC_VERSION)),1)

DEPENDS = cross/comskip

STARTABLE = no

MAINTAINER = SynoCommunity
DESCRIPTION = Comskip is a free mpeg commercial detector. Read the wiki on how to use and configure it.
DISPLAY_NAME = Comskip
CHANGELOG = "1. Update to FFMPEG 8.1.2"

HOMEPAGE = https://www.kaashoek.com/comskip/
LICENSE = LGPL
HELPURL = https://docs.synocommunity.com/packages/comskip/

SPK_COMMANDS = bin/comskip

POST_STRIP_TARGET = comskip_extra_install

include ../../mk/spksrc.spk-meta.mk

.PHONY: comskip_extra_install

comskip_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/comskip.ini $(STAGING_DIR)/var/comskip.ini
	install -m 644 src/comskip.dictionary $(STAGING_DIR)/var/comskip.dictionary
