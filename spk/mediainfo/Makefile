SPK_NAME = mediainfo
SPK_VERS = 26.01
SPK_REV = 15
SPK_ICON = src/mediainfo.png

DEPENDS = cross/mediainfo

# GCC >= 5 required for MediaInfo 26.01 (C++11)
# comcerto2k uses GCC 4.9.3 even on DSM 7.x
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS) comcerto2k
REQUIRED_MIN_DSM = 7.0

MAINTAINER = ymartin59
DESCRIPTION = "MediaInfo is a convenient unified display of the most relevant technical and tag data for video and audio files."
DISPLAY_NAME = MediaInfo
CHANGELOG = "Update to version 26.01."

HOMEPAGE = https://mediaarea.net/en/MediaInfo
LICENSE = 2-Clause BSD

STARTABLE = no

SPK_COMMANDS = bin/mediainfo

include ../../mk/spksrc.spk.mk
