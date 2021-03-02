PKG_NAME = linuxtv
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_DIST_SITE = https://git.linuxtv.org/media_build.git
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)
MOD_DIR = /lib/modules

DEPENDS =

HOMEPAGE = https://linuxtv.org/
COMMENT  = The LinuxTV community develops and maintains the Linux Kernel Media Subsystems and several userspace libraries and applications.
LICENSE  = GPLv2

include ../../mk/spksrc.archs.mk

# Currently only build on x64 archs with kernel >= 3.10
UNSUPPORTED_ARCHS = $(ARM_ARCHS) $(i686_ARCHS) $(PPC_ARCHS)

REQUIRE_KERNEL = 1

FIRMWARE_URL = http://www.linuxtv.org/downloads/firmware/
FIRMWARE_PKG = dvb-firmwares.tar.bz2

PRE_PATCH_TARGET = linuxtv_pre_patch
CONFIGURE_TARGET = linuxtv_configure
COMPILE_TARGET = linuxtv_compile
INSTALL_TARGET = linuxtv_install

# Disable all PCI adaptors
include ko-blacklist.mk
# Enable specific USB adaptors
include ko-whitelist.mk

# Blacklist modules that does not compile
BLACKLIST += CONFIG_VIDEO_IVTV

include ../../mk/spksrc.cross-cc.mk

# Specify linux-media driver version
# git hash from	2021-01-13
#   Linux-media patchset and linuxtv git hash must
#   be aligned in date of releases.  Versions post
#   Jan. 2021 only support kernel 4.4+
#   https://linuxtv.org/downloads/drivers/
ifeq ($(call version_lt, ${TC_KERNEL}, 4.4),1)
PKG_VERS = f6e3542
PKG_GIT_HASH = f6e3542673d19355e8e42be40f5fc78431d611c5
MEDIA_VERSION = 2021-01-08-321af22a3d2f
else
# Do not use LATEST by default so
# builds can be reproducible
# git hash from	2021-02-08
PKG_VERS = a236fdd
PKG_GIT_HASH = a236fddff61e8357f3070effdf23e9b5f20b26e6
MEDIA_VERSION = 2021-02-15-8f202f8e9ff3
endif

.PHONY: linuxtv_pre_patch
linuxtv_pre_patch:
	@$(MSG) "TC_KERNEL=$(TC_KERNEL)"
	@$(MSG) "BLACKLIST=$(BLACKLIST)"
	# Set linux-media patchset version to download
	$(RUN) sed -i 's/linux-media-LATEST/linux-media-$(MEDIA_VERSION)/' linux/Makefile
	$(RUN) make release DIR=$(WORK_DIR)/linux
	$(RUN) make -C linux/ download
	$(RUN) make -C linux/ untar
	$(RUN) wget $(FIRMWARE_URL)/$(FIRMWARE_PKG) -O $(FIRMWARE_PKG)
	$(RUN) tar xvfj $(FIRMWARE_PKG) -C v4l

.PHONY: linuxtv_configure
linuxtv_configure:
	# Final preparation for build
	$(RUN) make allyesconfig
	# Disable unneaded modules or that do not compile
	$(RUN) $(foreach kmodule,$(BLACKLIST),sed -i 's/$(kmodule)=m/# $(kmodule) is not set/' v4l/.config ;)
	# Enable modules otherwise disabled
	$(RUN) $(foreach kmodule,$(WHITELIST),sed -i 's/# $(kmodule) is not set/$(kmodule)=m/' v4l/.config ;)

.PHONY: linuxtv_compile
linuxtv_compile:
	$(RUN) LDFLAGS="" make -j`nproc` MAKEFLAGS=
	# Disable depmod call for later install
	$(RUN) sed -i '/depmod/s/^/#/' v4l/Makefile.media

.PHONY: linuxtv_install
linuxtv_install:
	$(RUN) make install DESTDIR=$(INSTALL_DIR)/$(INSTALL_PREFIX)
	# Install firmwares
	$(RUN) tar xvfj $(FIRMWARE_PKG) -C $(INSTALL_DIR)/$(INSTALL_PREFIX)/lib
	# Dynamically create PLIST for driver modules & firmwares
	$(RUN) find $(INSTALL_DIR)/$(INSTALL_PREFIX) -type f -name *.ko | sed -e 's,.*\(module\),\1,g' -e 's,^,lib:lib/,'    > ../PLIST
	$(RUN) find $(INSTALL_DIR)/$(INSTALL_PREFIX) -type f -name *.fw | sed -e 's,.*\(firmware\),\1,g' -e 's,^,lib:lib/,' >> ../PLIST
