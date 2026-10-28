PKG_NAME = linuxtv
PKG_VERS = 20220524
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_DIST_SITE = https://git.linuxtv.org/media_build.git
PKG_GIT_HASH = 0fe857b86addf382f6fd383948bd7736a3201403
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

DEPENDS = driver/linux-media-2022.06.05

HOMEPAGE = https://linuxtv.org/
COMMENT  = LinuxTV media_build: the media drivers of Linux 5.19-rc1 built out of tree, for kernels 4.4 and newer.
LICENSE  = GPLv2

# The last media_build code change; its 5.19 media tree needs gcc 5.1, for the
# __builtin_*_overflow of include/linux/overflow.h
DRIVER_KERNEL_MIN = 4.4
DRIVER_GCC_MIN = 5.1

# Left packed, per kernel, by driver/linux-media-2022.06.05
MEDIA_TARBALL = $(WORK_DIR)/linux-media-2022.06.05$(ARCH_SUFFIX)/linux-media-2022.06.05/linux-media.tar.bz2

CONFIGURE_TARGET = linuxtv_configure
COMPILE_TARGET   = linuxtv_compile
INSTALL_TARGET   = linuxtv_install

# PCI adapters left out where the platform has no PCIe slot, and drivers these
# kernels cannot build or load
include ko-blacklist.mk
# Adapters allyesconfig leaves out that build here
include ko-whitelist.mk

include ../../mk/spksrc.driver.mk

.PHONY: linuxtv_configure
linuxtv_configure:
	cp $(MEDIA_TARBALL) $(WORK_DIR)/$(PKG_DIR)/linux/ && cd $(WORK_DIR)/$(PKG_DIR)/linux && $(MAKE) untar
	@# GNU make 4.4 no longer remakes the phony .version media_build includes
	$(RUN) CROSS_COMPILE=y $(MAKE) -C v4l .version DIR=$(KERNEL_ROOT)
	$(RUN) CROSS_COMPILE=y $(MAKE) allyesconfig
	$(RUN) sed -i $(foreach k,$(BLACKLIST),-e 's/^$(k)=[my]/# $(k) is not set/') v4l/.config
	$(RUN) sed -i $(foreach k,$(WHITELIST),-e 's/^# $(k) is not set/$(k)=m/') v4l/.config

.PHONY: linuxtv_compile
linuxtv_compile:
	@# OBJECT_FILES_NON_STANDARD: no objtool, which spksrc.kernel/module.mk does not build
	$(RUN) MAKEFLAGS= LDFLAGS= CROSS_COMPILE=y OBJECT_FILES_NON_STANDARD=y $(MAKE) -j$(NCPUS)

.PHONY: linuxtv_install
linuxtv_install:
	install -d -m 755 $(DRIVER_MODULE_DIR)/drivers/media
	install -m 644 $(WORK_DIR)/$(PKG_DIR)/v4l/*.ko $(DRIVER_MODULE_DIR)/drivers/media/
