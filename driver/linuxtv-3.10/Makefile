PKG_NAME = linuxtv
PKG_VERS = 20210113
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_DIST_SITE = https://git.linuxtv.org/media_build.git
PKG_GIT_HASH = f6e3542673d19355e8e42be40f5fc78431d611c5
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

DEPENDS = cross/linux-media-2021.01.08

HOMEPAGE = https://linuxtv.org/
COMMENT  = LinuxTV media_build: the media drivers of Linux 5.11 built out of tree, for kernels 3.10 to 4.3.
LICENSE  = GPLv2

# The last media_build before it dropped kernels older than 4.4; its 5.11 media
# tree needs gcc 4.9, which also makes it the one for 4.4 kernels on gcc 4.9
DRIVER_KERNEL_MIN = 3.10
DRIVER_GCC_MIN = 4.9

# Left packed in the same WORK_DIR by cross/linux-media-2021.01.08
MEDIA_TARBALL = $(WORK_DIR)/linux-media-2021.01.08/linux-media.tar.bz2

CONFIGURE_TARGET = linuxtv_configure
COMPILE_TARGET   = linuxtv_compile
INSTALL_TARGET   = linuxtv_install

# PCI adapters left out where the platform has no PCIe slot, and drivers these
# kernels cannot build or load
include ko-blacklist.mk
# Adapters allyesconfig leaves out that build on 4.4 kernels
include ko-whitelist.mk

include ../../mk/spksrc.driver.mk

.PHONY: linuxtv_configure
linuxtv_configure:
	cp $(MEDIA_TARBALL) $(WORK_DIR)/$(PKG_DIR)/linux/ && cd $(WORK_DIR)/$(PKG_DIR)/linux && $(MAKE) untar
	@# GNU make 4.4 no longer remakes the phony .version media_build includes
	$(RUN) CROSS_COMPILE=y $(MAKE) -C v4l .version DIR=$(KERNEL_ROOT)
	$(RUN) CROSS_COMPILE=y $(MAKE) allyesconfig
	$(RUN) sed -i $(foreach k,$(BLACKLIST),-e 's/^$(k)=[my]/# $(k) is not set/') v4l/.config
ifeq ($(call version_ge,$(DRIVER_KERNEL),4.4),1)
	$(RUN) sed -i $(foreach k,$(WHITELIST),-e 's/^# $(k) is not set/$(k)=m/') v4l/.config
endif

.PHONY: linuxtv_compile
linuxtv_compile:
	@# OBJECT_FILES_NON_STANDARD: no objtool, which spksrc.kernel/module.mk does not build
	$(RUN) MAKEFLAGS= LDFLAGS= CROSS_COMPILE=y OBJECT_FILES_NON_STANDARD=y $(MAKE) -j$(NCPUS)

.PHONY: linuxtv_install
linuxtv_install:
	install -d -m 755 $(DRIVER_MODULE_DIR)/drivers/media
	install -m 644 $(WORK_DIR)/$(PKG_DIR)/v4l/*.ko $(DRIVER_MODULE_DIR)/drivers/media/
