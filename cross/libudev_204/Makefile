PKG_NAME = libudev_204
PKG_REAL_NAME = systemd
PKG_VERS = 204
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/systemd/systemd/archive
PKG_DIST_FILE = $(PKG_REAL_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_REAL_NAME)-$(PKG_VERS)

DEPENDS = cross/libgcrypt cross/dbus
OPTIONAL_DEPENDS = cross/libcap cross/libcap_2.51

# unable to find "library containing cap_init..."
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)


HOMEPAGE = https://github.com/systemd/systemd
COMMENT = The systemd System and Service Manager provides an array of system components for Linux operating systems.
# we take libraries only (tools are GPLv2)
LICENSE = LGPLv2.1

include ../../mk/spksrc.archs.mk
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
DEPENDS += cross/libcap_2.51
else
DEPENDS += cross/libcap
endif

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = libudev_pre_configure
POST_CONFIGURE_TARGET = libudev_post_configure
POST_INSTALL_TARGET = libudev_post_install

# disable as much as possible...
CONFIGURE_ARGS  = --without-python
CONFIGURE_ARGS += --disable-manpages
CONFIGURE_ARGS += --disable-tests
CONFIGURE_ARGS += --disable-gudev
CONFIGURE_ARGS += --disable-ima
CONFIGURE_ARGS += --disable-chkconfig
CONFIGURE_ARGS += --disable-selinux
CONFIGURE_ARGS += --disable-xz
CONFIGURE_ARGS += --disable-tcpwrap
CONFIGURE_ARGS += --disable-pam
CONFIGURE_ARGS += --disable-acl
CONFIGURE_ARGS += --disable-xattr
CONFIGURE_ARGS += --disable-gcrypt
CONFIGURE_ARGS += --disable-audit
CONFIGURE_ARGS += --disable-libcryptsetup
CONFIGURE_ARGS += --disable-qrencode
CONFIGURE_ARGS += --disable-microhttpd
CONFIGURE_ARGS += --disable-binfmt
CONFIGURE_ARGS += --disable-vconsole
CONFIGURE_ARGS += --disable-readahead
CONFIGURE_ARGS += --disable-bootchart
CONFIGURE_ARGS += --disable-quotacheck
CONFIGURE_ARGS += --disable-randomseed
CONFIGURE_ARGS += --disable-logind
CONFIGURE_ARGS += --disable-hostnamed
CONFIGURE_ARGS += --disable-timedated
CONFIGURE_ARGS += --disable-localed
CONFIGURE_ARGS += --disable-coredump
CONFIGURE_ARGS += --disable-polkit
CONFIGURE_ARGS += --disable-efi
CONFIGURE_ARGS += --disable-myhostname
CONFIGURE_ARGS += --disable-keymap
CONFIGURE_ARGS += --with-dbuspolicydir=/usr/share/dbus-1/system.d
CONFIGURE_ARGS += --with-dbussessionservicedir=/usr/share/dbus-1/services
CONFIGURE_ARGS += --with-dbussystemservicedir=/usr/share/dbus-1/system-services
CONFIGURE_ARGS += --with-dbusinterfacedir=/usr/share/dbus-1/interfaces

include ../../mk/spksrc.cross-cc.mk

.PHONY: libudev_pre_configure
libudev_pre_configure:
	@$(RUN) ACLOCAL_PATH=$(STAGING_INSTALL_PREFIX)/share/aclocal ./autogen.sh nop

.PHONY: libudev_post_configure
# patch some files generated during configure with gperf
# gperf >= 3.1 now uses 'size_t' rather than 'unsigned'
# mtd_probe.h:
# include <stdint.h> for missing 'uint32_t' and 'uint8_t'
# and define 'u_int32_t' missing for some archs and required by <mtd-user.h>
libudev_post_configure:
	@$(MSG) Patching some files created with gperf while autogen...
	@$(RUN) sed -i.bak -e "/journald_gperf_lookup/s/unsigned/size_t/" $(WORK_DIR)/$(PKG_DIR)/src/journal/journald-server.h
	@$(RUN) sed -i.bak ":1;/lookup_syscall/{n;s/unsigned int/size_t/;b1}" $(WORK_DIR)/$(PKG_DIR)/src/core/syscall-list.c
	@$(RUN) sed -i.bak -e "/load_fragment_gperf_lookup/s/unsigned/size_t/" $(WORK_DIR)/$(PKG_DIR)/src/core/load-fragment.h
	@$(RUN) sed -i.bak -e "/logind_gperf_lookup/s/unsigned/size_t/" $(WORK_DIR)/$(PKG_DIR)/src/login/logind.h
	@$(RUN) sed -i.bak -e "s/SG_FLAG_LUN_INHIBIT/SG_FLAG_UNUSED_LUN_INHIBIT/g" $(WORK_DIR)/$(PKG_DIR)/src/udev/cdrom_id/cdrom_id.c
	@$(RUN) sed -i.bak -e "/lookup_key/s/unsigned int/size_t/" $(WORK_DIR)/$(PKG_DIR)/src/udev/keymap/keymap.c
	@$(RUN) sed -i.bak -e "/mtd-user.h/i\$\\#ifndef u_int32_t\ntypedef unsigned int u_int32_t;\n#endif" -e "/mtd-user.h/a\$\\#include <stdint.h>" $(WORK_DIR)/$(PKG_DIR)/src/udev/mtd_probe/mtd_probe.h

.PHONY: libudev_post_install
# copy udev.pc to lib folder, share folder is not recognized by cross/fuse3
libudev_post_install:
	@install -m 644 $(STAGING_INSTALL_PREFIX)/share/pkgconfig/udev.pc $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/
