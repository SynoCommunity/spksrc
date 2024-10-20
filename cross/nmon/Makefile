PKG_NAME = nmon
PKG_VERS = 16q
PKG_EXT = c
PKG_DIST_NAME = lmon$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/nmon/files
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncursesw

HOMEPAGE = http://nmon.sourceforge.net
COMMENT  = nmon (Nigel's performance Monitor) is a performance monitoring tool for Linux.
LICENSE  = GPLv3

CONFIGURE_TARGET = nmon_configure
COMPILE_TARGET = nmon_compile
INSTALL_TARGET = nmon_install

NMON_TARGET = $(PKG_NAME)

ADDITIONAL_CFLAGS = -g -O3 -Wall -D JFS -D GETUSER -D LARGEMEM -lncursesw -lm -o $(NMON_TARGET)

include ../../mk/spksrc.cross-cc.mk

.PHONY: nmon_configure
nmon_configure:
	@rm -rf $(WORK_DIR)/$(PKG_DIR)
	@mkdir -p $(WORK_DIR)/$(PKG_DIR)
	@cp $(DISTRIB_DIR)/$(PKG_DIST_NAME) $(WORK_DIR)/$(PKG_DIR)

# HINT:
# When building in spksrc/cross/nmon, the variable $(CC) might evaluate to "cc" instead of the cross compiler 
# of the toolchain.
# You will get compiler errors about invalid flags (like cc: error: unrecognized command-line option ‘-mfloat-abi=hard’ for comcerto2k-7.1)
# or targets are built for x86_64.
# Building in spksrc/diyspk/nmon or spksrc/spk/synocli-monitor works as expected.
.PHONY: nmon_compile
nmon_compile:
	@$(RUN) $(CC) $(PKG_DIST_NAME) $(CFLAGS) $(LDFLAGS)

.PHONY: nmon_install
nmon_install:
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin
	@install -m 755 $(WORK_DIR)/$(PKG_DIR)/$(NMON_TARGET) $(STAGING_INSTALL_PREFIX)/bin/
