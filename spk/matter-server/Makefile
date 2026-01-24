SPK_NAME = matter-server
SPK_VERS = 8.1.2
SPK_REV = 1
SPK_ICON = src/matter.png

# home-assistant-chip-core requires "glibc >= 2.34"
# Despite home-assistant-chip-core wheel is provided as manylinux_2_31, it requires glibc 2.34 and not 2.31
REQUIRED_MIN_DSM = 7.2

# 64-bit OS supported only
# and therefore home-assistant-chip-core is only available for x64 and aarch64
UNSUPPORTED_ARCHS = $(32bit_ARCHS)

SPK_DEPENDS = "python312"

MAINTAINER = hgy59
DESCRIPTION = The Open Home Foundation Matter Server is an officially certified Software Component to create a Matter controller. It serves as the foundation to provide Matter support to Home Assistant but its universal approach makes it suitable to be used in other projects too. This package conains a custom library for home-assistant-chip-core to allow definition of config data path.
DISPLAY_NAME = Python Matter Server
CHANGELOG = "1. Initial package with custom build of home_assistant_chip_core==2025.7.0"

HOMEPAGE = https://github.com/home-assistant-libs/python-matter-server
LICENSE  = Apache 2.0

STARTABLE = yes
SERVICE_SETUP = src/service-setup.sh

FWPORTS = src/matter-server.sc
SERVICE_PORT = 5580

USE_ALTERNATE_TMPDIR = 1

PRE_COPY_TARGET = matter-server_extra_install

# This package depends on python, but does not build any wheel,
# so python is not required to build the package.

include ../../mk/spksrc.spk.mk

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
CUSTOM_CHIP_WHEELS_DIR = src/custom_wheels/x64
else ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
CUSTOM_CHIP_WHEELS_DIR = src/custom_wheels/aarch64
endif

.PHONY: matter-server_extra_install
matter-server_extra_install:
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/share/wheelhouse
	@install -m 644 $(CUSTOM_CHIP_WHEELS_DIR)/* $(STAGING_INSTALL_PREFIX)/share/wheelhouse/
	@install -m 755 -d $(STAGING_DIR)/share
	@install -m 644 src/requirements-crossenv.txt $(STAGING_DIR)/share/
	@install -m 644 src/requirements-pure.txt $(STAGING_DIR)/share/
