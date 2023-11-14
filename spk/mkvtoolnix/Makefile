SPK_NAME = mkvtoolnix
SPK_VERS = 58.0.0
SPK_REV = 4
SPK_ICON = src/mkvtoolnix.png

DEPENDS = cross/mkvtoolnix

# mkvtoolnix > 53.x and <= 58.x are DSM 7.1 only
REQUIRED_MIN_DSM = 7.1
# comcerto2k has older toolchain than other DSM 7 archs
UNSUPPORTED_ARCHS = comcerto2k

MAINTAINER = cytec
DESCRIPTION = MKVToolNix is a set of tools to create, alter and inspect Matroska files.
CHANGELOG = "Update to version 58 (requires DSM 7.1)."
DISPLAY_NAME = MKVToolNix
STARTABLE = no

HOMEPAGE = https://mkvtoolnix.download/index.html
LICENSE  = GPLv2

SPK_COMMANDS = bin/mkvextract bin/mkvinfo bin/mkvmerge bin/mkvpropedit

include ../../mk/spksrc.spk.mk
