PKG_NAME = wireless-regdb
PKG_VERS = 2026.09.03
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.kernel.org/pub/software/network/wireless-regdb
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://wireless.docs.kernel.org/en/latest/en/developers/regulatory/wireless-regdb.html
COMMENT  = The regulatory rules of wireless channels and power, per country.
LICENSE  = ISC

CONFIGURE_TARGET = nop
COMPILE_TARGET   = wireless-regdb_compile
INSTALL_TARGET   = wireless-regdb_install

include ../../mk/spksrc.driver.mk

# Kernels before 4.15 read no regulatory.db: cfg80211 compiles db.txt in, and
# the genregdb.awk of those before 4.4 reads powers in dBm only
INTERNAL_REGDB = $(if $(wildcard $(KERNEL_ROOT)/net/wireless/genregdb.awk),1)
LEGACY_DB_TXT  = $(if $(INTERNAL_REGDB),$(if $(shell grep -l 'log(power)' $(KERNEL_ROOT)/net/wireless/genregdb.awk),,1))

.PHONY: wireless-regdb_compile
wireless-regdb_compile:
ifeq ($(INTERNAL_REGDB),1)
	grep -q "^CONFIG_CFG80211_INTERNAL_REGDB=y" $(KERNEL_ROOT)/.config
ifeq ($(LEGACY_DB_TXT),1)
	awk -f src/db-txt-legacy.awk $(WORK_DIR)/$(PKG_DIR)/db.txt > $(KERNEL_ROOT)/net/wireless/db.txt
else
	install -m 644 $(WORK_DIR)/$(PKG_DIR)/db.txt $(KERNEL_ROOT)/net/wireless/db.txt
endif
	rm -f $(KERNEL_ROOT)/net/wireless/regdb.c
	$(RUN) MAKEFLAGS= LDFLAGS= $(MAKE) -C $(KERNEL_ROOT) M=net/wireless OBJECT_FILES_NON_STANDARD=y \
	  KBUILD_EXTRA_SYMBOLS=$(KERNEL_ROOT)/modules.symvers modules
endif

.PHONY: wireless-regdb_install
wireless-regdb_install:
	install -D -m 644 $(WORK_DIR)/$(PKG_DIR)/regulatory.db $(STAGING_INSTALL_PREFIX)/lib/firmware/regulatory.db
	install -D -m 644 $(WORK_DIR)/$(PKG_DIR)/regulatory.db.p7s $(STAGING_INSTALL_PREFIX)/lib/firmware/regulatory.db.p7s
ifeq ($(INTERNAL_REGDB),1)
	install -m 644 $(KERNEL_ROOT)/net/wireless/cfg80211.ko $(DRIVER_MODULE_DIR)/net/wireless/cfg80211.ko
endif
