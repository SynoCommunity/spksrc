SPK_NAME = gpac
SPK_VERS = 26.02.0
SPK_REV = 2
SPK_ICON = src/gpac.png

DEPENDS = cross/gpac

# Toolchains lacking atomic support
UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS)

MAINTAINER = wmanth
DESCRIPTION = GPAC is an open-source multimedia framework for rich-media and broadcast technologies. It features the MP4 reference muxer MP4Box.
DISPLAY_NAME = GPAC
CHANGELOG = "Update to v26.02.0 with HTTP/3, WebAssembly support, IAMF, AC-4, AVS3 codecs, and many improvements."

HOMEPAGE = https://gpac.io
LICENSE  = LGPLv2

STARTABLE = no
SPK_COMMANDS = bin/gpac bin/MP4Box

include ../../mk/spksrc.spk.mk
