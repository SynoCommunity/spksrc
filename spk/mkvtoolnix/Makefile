SPK_NAME = mkvtoolnix
SPK_VERS = 103.0
SPK_REV = 1
SPK_ICON = src/mkvtoolnix.png

DEPENDS = cross/mkvtoolnix

MAINTAINER = cytec
DESCRIPTION = MKVToolNix - Ultimate Tool for Editing and Merging MKV Files. MKVToolNix is a powerful tool for editing, merging, and splitting MKV files. Easily manage video, audio, and subtitles, extract tracks, and modify metadata.
CHANGELOG = "Update to version 103.0 (Qt 6, requires DSM 7.2)."
DISPLAY_NAME = MKVToolNix
STARTABLE = no

# prepare.sh classifies CI builds by REQUIRED_MIN_DSM in spk/*/Makefile;
# keep this at 7.2 so the package is included in the DSM 7.2 matrix.
REQUIRED_MIN_DSM = 7.2
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(PPC_ARCHS) $(OLD_PPC_ARCHS)

HOMEPAGE = https://mkvtoolnix.org/
LICENSE  = GPLv2

SPK_COMMANDS = bin/mkvextract bin/mkvinfo bin/mkvmerge bin/mkvpropedit

include ../../mk/spksrc.spk.mk
