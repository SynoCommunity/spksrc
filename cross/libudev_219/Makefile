PKG_NAME = libudev_219
PKG_REAL_NAME = systemd
PKG_VERS = 219
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/systemd/systemd/archive
PKG_DIST_FILE = $(PKG_REAL_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_REAL_NAME)-$(PKG_VERS)

DEPENDS = cross/libgcrypt cross/dbus cross/libcap cross/libmount

REQUIRED_MIN_DSM = 7.0

HOMEPAGE = https://github.com/systemd/systemd
COMMENT = The systemd System and Service Manager provides an array of system components for Linux operating systems.
# we take libraries only (tools are GPLv2)
LICENSE = LGPLv2.1

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
CONFIGURE_ARGS += --disable-elfutils
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
CONFIGURE_ARGS += --with-dbuspolicydir=$(INSTALL_PREFIX)/share/dbus-1/system.d
CONFIGURE_ARGS += --with-dbussessionservicedir=$(INSTALL_PREFIX)/share/dbus-1/services
CONFIGURE_ARGS += --with-dbussystemservicedir=$(INSTALL_PREFIX)/share/dbus-1/system-services
CONFIGURE_ARGS += --with-dbusinterfacedir=$(INSTALL_PREFIX)/share/dbus-1/interfaces

ADDITIONAL_CFLAGS = -DSG_FLAG_LUN_INHIBIT=2

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
	@$(RUN) sed -i.bak ":1;/lookup_errno/{n;s/unsigned int/size_t/;b1}" $(WORK_DIR)/$(PKG_DIR)/src/shared/errno-list.c
	@$(RUN) sed -i.bak -e "/lookup_af/s/unsigned int/size_t/" $(WORK_DIR)/$(PKG_DIR)/src/shared/af-list.c
	@$(RUN) sed -i.bak -e "/lookup_arphrd/s/unsigned int/size_t/" $(WORK_DIR)/$(PKG_DIR)/src/shared/arphrd-list.c
	@$(RUN) sed -i.bak -e "/lookup_capability/s/unsigned int/size_t/" $(WORK_DIR)/$(PKG_DIR)/src/shared/cap-list.c
	@$(RUN) sed -i.bak -e "/link_config_gperf_lookup/s/unsigned/size_t/" $(WORK_DIR)/$(PKG_DIR)/src/udev/net/link-config.c
	@$(RUN) sed -i.bak -e "/link_config_gperf_lookup/s/unsigned/size_t/" $(WORK_DIR)/$(PKG_DIR)/src/udev/net/link-config.h
	@$(RUN) sed -i.bak -e "/keyboard_lookup_key/s/unsigned/size_t/" $(WORK_DIR)/$(PKG_DIR)/src/udev/udev-builtin-keyboard.c
	@$(RUN) sed -i.bak -e "/journald_gperf_lookup/s/unsigned/size_t/" $(WORK_DIR)/$(PKG_DIR)/src/journal/journald.c
	@$(RUN) sed -i.bak -e "/journald_gperf_lookup/s/unsigned/size_t/" $(WORK_DIR)/$(PKG_DIR)/src/journal/journald-server.h
	@$(RUN) sed -i.bak -e "/load_fragment_gperf_lookup/s/unsigned/size_t/" $(WORK_DIR)/$(PKG_DIR)/src/core/load-fragment.h
	@$(RUN) sed -i.bak -e "/timesyncd_gperf_lookup/s/unsigned/size_t/" $(WORK_DIR)/$(PKG_DIR)/src/timesync/timesyncd-conf.h
	@$(RUN) sed -i.bak -e "/lookup_dns_type/s/unsigned int/size_t/" $(WORK_DIR)/$(PKG_DIR)/src/resolve/dns-type.c
	@$(RUN) sed -i.bak -e "/resolved_gperf_lookup/s/unsigned/size_t/" $(WORK_DIR)/$(PKG_DIR)/src/resolve/resolved-conf.h
	@$(RUN) sed -i.bak -e "/network_network_gperf_lookup/s/unsigned/size_t/" $(WORK_DIR)/$(PKG_DIR)/src/network/networkd.h
	@$(RUN) sed -i.bak -e "/network_netdev_gperf_lookup/s/unsigned/size_t/" $(WORK_DIR)/$(PKG_DIR)/src/network/networkd-netdev.h
	@$(RUN) sed -i.bak -e "/mtd-user.h/i\$\\#ifndef u_int32_t\ntypedef unsigned int u_int32_t;\n#endif" -e "/mtd-user.h/a\$\\#include <stdint.h>" $(WORK_DIR)/$(PKG_DIR)/src/udev/mtd_probe/mtd_probe.h


.PHONY: libudev_post_install
# copy udev.pc to lib folder, share folder is not recognized by cross/fuse3
libudev_post_install:
	@install -m 644 $(STAGING_INSTALL_PREFIX)/share/pkgconfig/udev.pc $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/
