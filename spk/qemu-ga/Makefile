SPK_NAME = qemu-ga
SPK_VERS = 9.0.1
SPK_REV = 1
SPK_ICON = src/qemu.png

include ../../mk/spksrc.common.mk
ifneq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
UNSUPPORTED_ARCHS = $(ARCH)
endif

REQUIRED_MIN_DSM = 7.1

DEPENDS = cross/qemu

MAINTAINER = hgy59
HOMEPAGE = https://wiki.qemu.org/Features/GuestAgent
DISPLAY_NAME = QEMU Guest Agent
DESCRIPTION = Support for QMP commands and events that terminate and originate respectively within the guest using an agent built as part of QEMU.
LICENSE  = GPLv2

STARTABLE = no

SPK_COMMANDS = bin/qemu-ga

include ../../mk/spksrc.spk.mk
