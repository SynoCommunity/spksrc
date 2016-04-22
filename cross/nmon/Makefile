PKG_NAME = nmon
PKG_VERS = 16e
PKG_EXT = c
PKG_DIST_NAME = lmon$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://sourceforge.net/projects/nmon/files
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = http://nmon.sourceforge.net
COMMENT  = nmon (Nigel's performance Monitor) is a performance monitoring tool for Linux
LICENSE  = GPLv3

DEPENDS = cross/ncurses

CONFIGURE_TARGET = nope
COMPILE_TARGET = myComp
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

NMON_BIN=nmon.bin

myComp:
	rm -rf $(WORK_DIR)/$(PKG_DIR)
	mkdir -p $(WORK_DIR)/$(PKG_DIR)
	ln -sf $(WORK_DIR)/../../../distrib/$(PKG_DIST_NAME) $(WORK_DIR)/$(PKG_DIR)/$(PKG_DIST_NAME)
	$(RUN) cc -o $(NMON_BIN) lmon16e.c -g -O3 -Wall -D JFS -D GETUSER -D LARGEMEM -lncurses -lm -L$(STAGING_INSTALL_PREFIX)/lib -D KERNEL_2_6_18  -D X86


.PHONY: myInstall
myInstall:
	mkdir -p $(STAGING_INSTALL_PREFIX)/bin
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/$(NMON_BIN) $(STAGING_INSTALL_PREFIX)/bin/
	echo '#!/bin/sh\n\nexport LD_LIBRARY_PATH=/usr/local/nmon/lib\n\n/usr/local/nmon/bin/nmon.bin $$@' > $(STAGING_INSTALL_PREFIX)/bin/nmon
	chmod 755 $(STAGING_INSTALL_PREFIX)/bin/nmon

