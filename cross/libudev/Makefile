PKG_NAME = systemd
PKG_VERS = 204
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/systemd/systemd/archive/
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libgcrypt cross/dbus cross/libcap cross/glib

HOMEPAGE = https://github.com/systemd/systemd
COMMENT  = The systemd System and Service Manager provides an array of system components for Linux operating systems.
LICENSE  = GPLv2, LGPLv2.1

# Require access to glib-mkenums Python script
ENV += PATH=$(STAGING_INSTALL_PREFIX)/bin:$$PATH

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = udev_pre_configure
POST_INSTALL_TARGET = udev_post_install

CONFIGURE_ARGS = --without-python
CONFIGURE_ARGS += --disable-manpages
CONFIGURE_ARGS += --disable-gudev
CONFIGURE_ARGS += --disable-tests
CONFIGURE_ARGS += --with-dbuspolicydir=$(INSTALL_PREFIX)/share/dbus-1/system.d
CONFIGURE_ARGS += --with-dbussessionservicedir=$(INSTALL_PREFIX)/share/dbus-1/services
CONFIGURE_ARGS += --with-dbussystemservicedir=$(INSTALL_PREFIX)/share/dbus-1/system-services
CONFIGURE_ARGS += --with-dbusinterfacedir=$(INSTALL_PREFIX)/share/dbus-1/interfaces

include ../../mk/spksrc.cross-cc.mk

# Fix for ndefined reference to `rpl_malloc'
ENV += ac_cv_func_malloc_0_nonnull=yes
ENV += ac_cv_func_realloc_0_nonnull=yes

.PHONY: udev_pre_configure
udev_pre_configure:
	$(RUN) ACLOCAL_PATH=$(STAGING_INSTALL_PREFIX)/share/aclocal ./autogen.sh nop
	# gperf >= 3.1 now uses 'size_t' rather than 'unsigned'
	$(RUN) sed -i.bak -e "/journald_gperf_lookup/s/unsigned/size_t/" $(WORK_DIR)/$(PKG_DIR)/src/journal/journald-server.h
	# Modify line after: definition spreads over 2x lines
	$(RUN) sed -i.bak ":1;/lookup_syscall/{n;s/unsigned int/size_t/;b1}" $(WORK_DIR)/$(PKG_DIR)/src/core/syscall-list.c
	$(RUN) sed -i.bak -e "/load_fragment_gperf_lookup/s/unsigned/size_t/" $(WORK_DIR)/$(PKG_DIR)/src/core/load-fragment.h
	$(RUN) sed -i.bak -e "/logind_gperf_lookup/s/unsigned/size_t/" $(WORK_DIR)/$(PKG_DIR)/src/login/logind.h
	$(RUN) sed -i.bak -e "s/SG_FLAG_LUN_INHIBIT/SG_FLAG_UNUSED_LUN_INHIBIT/g" $(WORK_DIR)/$(PKG_DIR)/src/udev/cdrom_id/cdrom_id.c
	$(RUN) sed -i.bak -e "/lookup_key/s/unsigned int/size_t/" $(WORK_DIR)/$(PKG_DIR)/src/udev/keymap/keymap.c
	# include <stdint.h> for missing types for error: unknown type name 'uint32_t' and 'uint8_t'
	$(RUN) sed -i.bak -e "/mtd-user.h/a\$\\#include <stdint.h>" $(WORK_DIR)/$(PKG_DIR)/src/udev/mtd_probe/mtd_probe.h

.PHONY: udev_post_install
udev_post_install:
	@install -m 644 $(WORK_DIR)/$(PKG_DIR)/src/udev/udev.pc $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/
