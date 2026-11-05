SPK_NAME = gpac
SPK_VERS = 26.07.0
SPK_REV = 3
SPK_ICON = src/gpac.png

DEPENDS = cross/gpac

# quickjs-libc includes stdatomic.h unconditionally, which needs GCC >= 4.9.
MIN_GCC_VERSION = 4.9
# The PPC toolchain headers lack SYS_DVBT2.
UNSUPPORTED_ARCHS = $(PPC_ARCHS)
UNSUPPORTED_ARCHS_REASON = PPC toolchain headers lack SYS_DVBT2

MAINTAINER = wmanth
DESCRIPTION = GPAC is an open-source multimedia framework for rich-media and broadcast technologies. It features the MP4 reference muxer MP4Box.
DISPLAY_NAME = GPAC
CHANGELOG = "Update to v26.07.0."

HOMEPAGE = https://gpac.io
LICENSE  = LGPLv2

STARTABLE = no
SPK_COMMANDS = bin/gpac bin/MP4Box

include ../../mk/spksrc.spk.mk
