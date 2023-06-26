PKG_NAME = njmon
PKG_VERS = v81
PKG_EXT = zip
PKG_DIST_NAME = $(PKG_NAME)_linux_code_$(PKG_VERS).$(PKG_EXT)
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
VERSION_CFLAGS = -DOSNAME=\"Synology\" -DOSVERSION=\"$(TC_VERS)\" -DHW=\"$(ARCH)\"

include ../../mk/spksrc.cross-cc.mk

# HINT:
# When building in spksrc/cross/njmon, the variable $(CC) might evaluate to "cc" instead ofthe cross compiler 
# of the toolchain.
# You will get compiler errors about invalid flags (like cc: error: unrecognized command-line option ‘-mfloat-abi=hard’ for comcerto2k-7.1)
# or targets are built for x86_64.
# Building in spksrc/diyspk/njmon or spksrc/spk/synocli-monitor works as expected.
.PHONY: njmon_compile
njmon_compile:
	@$(RUN) $(CC) $(FILE) $(CFLAGS) $(VERSION_CFLAGS)

.PHONY: njmon_install
njmon_install:
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin
	@install -m 755 $(WORK_DIR)/$(PKG_DIR)/$(PKG_NAME) $(STAGING_INSTALL_PREFIX)/bin/
