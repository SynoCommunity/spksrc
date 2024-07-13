SPK_NAME = qemu-ga
SPK_VERS = 9.0.1
SPK_REV = 1
SPK_ICON = src/qemu.png

DEPENDS = cross/qemu

REQUIRED_MIN_DSM = 7.1
include ../../mk/spksrc.common.mk
ifneq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
UNSUPPORTED_ARCHS = $(ARCH)
endif

MAINTAINER = hgy59
DISPLAY_NAME = QEMU Guest Agent
DESCRIPTION = Support for QMP commands and events that terminate and originate respectively within the guest using an agent built as part of QEMU.

HOMEPAGE = https://wiki.qemu.org/Features/GuestAgent
LICENSE  = GPLv2

WIZARDS_DIR = src/wizard/
SYSTEM_GROUP = system
STARTABLE = yes
SERVICE_SETUP = src/service-setup.sh

SPK_COMMANDS = bin/qemu-ga

include ../../mk/spksrc.spk.mk
