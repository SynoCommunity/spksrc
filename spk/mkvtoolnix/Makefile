SPK_NAME = mkvtoolnix
SPK_VERS = 53.0.0
SPK_REV = 3
SPK_ICON = src/$(SPK_NAME).png

DEPENDS = cross/$(SPK_NAME)

# mkvtoolnix > 22.x and < 54.x are DSM 7 only
REQUIRED_MIN_DSM = 7.0
# comcerto2k has older toolchain than other DSM 7 archs
UNSUPPORTED_ARCHS = comcerto2k

MAINTAINER = cytec
DESCRIPTION = MKVToolNix is a set of tools to create, alter and inspect Matroska files.
CHANGELOG = "Update to version 53 \(requires DSM 7\)."
DISPLAY_NAME = MKVToolNix
STARTABLE = no

HOMEPAGE = https://mkvtoolnix.download/index.html
LICENSE  = GPLv2

SPK_COMMANDS = bin/mkvextract bin/mkvinfo bin/mkvmerge bin/mkvpropedit

include ../../mk/spksrc.spk.mk
