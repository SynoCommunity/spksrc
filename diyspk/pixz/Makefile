SPK_NAME = pixz
SPK_VERS = 1.0.7
SPK_REV = 1
#SPK_ICON = src/pixz.png

#DISPLAY_NAME = pixz
DESCRIPTION = Parallel, indexed xz compressor
HOMEPAGE = https://github.com/vasi/$(SPK_NAME)
LICENSE = 2-Clause BSD
MAINTAINER = dotysan

# blindly disabling hi3535-6.2.4 build that fails
UNSUPPORTED_ARCHS = $(ARMv7L_ARCHS)

DEPENDS = cross/$(SPK_NAME)

STARTABLE = no
SPK_COMMANDS = bin/$(SPK_NAME)

include ../../mk/spksrc.spk.mk
