PKG_NAME = linuxtv
PKG_VERS = 20180808
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_DIST_SITE = https://git.linuxtv.org/media_build.git
PKG_GIT_HASH = baf45935ffad914f33faf751ad9f4d0dd276c021
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

DEPENDS = cross/linux-media-2018.08.07

HOMEPAGE = https://linuxtv.org/
COMMENT  = LinuxTV media_build: the media drivers of Linux 4.19-rc built out of tree, for kernels 3.2 to 3.9.
LICENSE  = GPLv2

# media_build while its old kernel backports were maintained: lgdt3306a builds
# for 3.2 from 2018-04, the Request API of 2018-09 no longer builds before 3.7,
# and the 2.6.32 backports no longer apply
DRIVER_KERNEL_MIN = 3.2

# Left packed in the same WORK_DIR by cross/linux-media-2018.08.07
MEDIA_TARBALL = $(WORK_DIR)/linux-media-2018.08.07/linux-media.tar.bz2

CONFIGURE_TARGET = linuxtv_configure
COMPILE_TARGET   = linuxtv_compile
INSTALL_TARGET   = linuxtv_install

# PCI adapters left out where the platform has no PCIe slot, and drivers these
# kernels cannot build or load
include ko-blacklist.mk

include ../../mk/spksrc.driver.mk

.PHONY: linuxtv_configure
linuxtv_configure:
	cp $(MEDIA_TARBALL) $(WORK_DIR)/$(PKG_DIR)/linux/ && cd $(WORK_DIR)/$(PKG_DIR)/linux && $(MAKE) untar
	@# GNU make 4.4 no longer remakes the phony .version media_build includes
	$(RUN) CROSS_COMPILE=y $(MAKE) -C v4l .version DIR=$(KERNEL_ROOT)
	$(RUN) CROSS_COMPILE=y $(MAKE) allyesconfig
	$(RUN) sed -i $(foreach k,$(BLACKLIST),-e 's/^$(k)=[my]/# $(k) is not set/') v4l/.config

.PHONY: linuxtv_compile
linuxtv_compile:
	@# OBJECT_FILES_NON_STANDARD: no objtool, which spksrc.kernel/module.mk does not build
	$(RUN) MAKEFLAGS= LDFLAGS= CROSS_COMPILE=y OBJECT_FILES_NON_STANDARD=y $(MAKE) -j$(NCPUS)

.PHONY: linuxtv_install
linuxtv_install:
	install -d -m 755 $(DRIVER_MODULE_DIR)/drivers/media
	install -m 644 $(WORK_DIR)/$(PKG_DIR)/v4l/*.ko $(DRIVER_MODULE_DIR)/drivers/media/
