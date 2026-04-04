PKG_NAME = nodejs
# https://github.com/nodejs/release#release-schedule
# v18 is Maintenance Version "Hydrogen" since 2023-10-18 with EOL at 2025-04-30
# v20 is Maintenance Version "Iron" since 2024-10-22 with EOL at 2026-04-30
# v22 is LTS Version "Jod" from 2024-10-29 to 2025-10-21 with EOL at 2027-04-30
PKG_VERS = 22.21.1
PKG_EXT = tar.xz
PKG_DIST_NAME = node-v$(PKG_VERS)-linux-$(PKG_DIST_ARCH).$(PKG_EXT)
PKG_DIST_SITE = https://nodejs.org/dist/v$(PKG_VERS)
PKG_DIR = node-v$(PKG_VERS)-linux-$(PKG_DIST_ARCH)

HOMEPAGE = https://nodejs.org/
COMMENT  = JavaScript runtime built on Chrome's V8 JavaScript engine.
LICENSE  = https://github.com/nodejs/node/blob/master/LICENSE

include ../../mk/spksrc.archs.mk

# mostly here to support digesting the right package
PKG_DIST_ARCH_LIST = x64 arm64

# Restore original PKG_DIST_ARCH behavior (based on ARCH only)
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
PKG_DIST_ARCH = x64
else ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
PKG_DIST_ARCH = arm64
endif

# Execute the host-detection block ONLY when CARGO_HOME is not empty (set)
ifneq ($(strip $(CARGO_HOME)),)
	HOST_UNAME := $(shell uname -m 2>/dev/null)

	ifneq (,$(findstring aarch64,$(HOST_UNAME)))
		PKG_DIST_ARCH := arm64
	else ifneq (,$(filter x86_64 amd64 i386 i686,$(HOST_UNAME)))
		PKG_DIST_ARCH := x64
	else
		PKG_DIST_ARCH := $(HOST_UNAME)
	endif
endif

INSTALL_TARGET = nodejs-install

include ../../mk/spksrc.native-install.mk

.PHONY: nodejs-install
nodejs-install:
	@echo "== Environment variables after applying ENV ($(ENV)) =="
	@env $(ENV) sh -lc 'echo "---- Exported environment (env)" ; env | sort'
	@mv -f $(WORK_DIR)/$(PKG_DIR)/ $(WORK_DIR)/node/
