SPK_NAME   = octoprint
SPK_VERS   = 1.11.8
SPK_REV    = 16
SPK_ICON   = src/octoprint.png
DSM_UI_DIR = app

PYTHON_PACKAGE = python312

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

# Required for PyYAML
DEPENDS += cross/libyaml

MAINTAINER   = SynoCommunity
DESCRIPTION  = The snappy web interface for your 3D printer.
SERVICE_PORT = 8088
ADMIN_PORT   = $(SERVICE_PORT)

DISPLAY_NAME = OctoPrint
HOMEPAGE     = https://octoprint.org/
LICENSE      = AGPLv3
CHANGELOG    = "Update OctoPrint to v1.11.8."

# SERVICE_COMMAND is in src/service-setup.sh
STARTABLE     = yes
SERVICE_SETUP = src/service-setup.sh
SERVICE_USER  = auto

POST_STRIP_TARGET = octoprint_extra_install

# /tmp might be too small for plugin installation
USE_ALTERNATE_TMPDIR = 1

include ../../mk/spksrc.spk-meta.mk

# argon2-cffi-bindings enables SSE2 by default and its cmake detection
# misses the cross target (x86-only -msse2 breaks non-x86 builds);
# force the portable implementation off-x86 (supported upstream knob)
ifneq ($(findstring $(ARCH),$(x64_ARCHS) $(i686_ARCHS)),$(ARCH))
ENV += ARGON2_CFFI_USE_SSE2=0
endif

.PHONY: octoprint_extra_install
octoprint_extra_install:
	install -m 755 -d $(STAGING_DIR)/var/.octoprint
	install -m 600 src/config.yaml $(STAGING_DIR)/var/.octoprint/config.yaml
