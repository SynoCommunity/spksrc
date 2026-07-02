PKG_NAME = njmon
PKG_VERS = v90
PKG_EXT = zip
PKG_DIST_NAME = $(PKG_NAME)_linux_$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/nmon/files
EXTRACT_PATH = $(WORK_DIR)/$(PKG_NAME)-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://nmon.sourceforge.net
COMMENT  = nmon (Nigel's performance Monitor) is a performance monitoring tool for Linux. njmon outputs JSON format that a lot of tools use these days. It integrates well with saving data directly to InfluxDB and graphing with Grafana.
LICENSE  = GPLv3

CONFIGURE_TARGET = nop
COMPILE_TARGET = njmon_compile
INSTALL_TARGET = njmon_install

FILE = njmon_linux_$(PKG_VERS).c
ADDITIONAL_CFLAGS = -g -O4 -lm -o $(PKG_NAME)
# provide custom info for version string
VERSION_CFLAGS = -DOSNAME=\"Synology\" -DOSVERSION=\"$(TC_VERS)\" -DHW=\"$(ARCH)\" -DNJMONVERSION=\"$(subst v,,$(PKG_VERS))\"

include ../../mk/spksrc.cross-cc.mk

# HINT:
# The variable $(CC) evaluates to "cc" instead of gcc of the toolchain
# since CC is a builtin make variable.
# It works in shell when using $$CC instead of $(CC)
.PHONY: njmon_compile
njmon_compile:
	@$(RUN) sh -c '$$CC $(FILE) $$CFLAGS $(VERSION_CFLAGS)'

.PHONY: njmon_install
njmon_install:
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin
	@install -m 755 $(WORK_DIR)/$(PKG_DIR)/$(PKG_NAME) $(STAGING_INSTALL_PREFIX)/bin/
