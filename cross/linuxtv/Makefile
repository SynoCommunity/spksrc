PKG_NAME = linuxtv
PKG_VERS = f6e3542
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
# git hash from	2021-01-13
PKG_GIT_HASH = 	f6e3542673d19355e8e42be40f5fc78431d611c5
PKG_DIST_SITE = https://git.linuxtv.org/media_build.git
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)
MOD_DIR = /lib/modules

# Specify linux-media driver version
#   Linux-media patchset and linuxtv git hash must
#   be aligned in date of releases.  Versions post
#   Jan. 2021 only support kernel 4.4+
#   https://linuxtv.org/downloads/drivers/
MEDIA_VERSION = 2021-01-08-321af22a3d2f

DEPENDS =

# archs where kernel is too old (2.6 and 3.2)
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(i686_ARCHS) $(PPC_ARCHS) armada370 armada375 armadaxp comcerto2k
# Currently fails to build - Error
#UNSUPPORTED_ARCHS += alpine armada380 cedarview monaco
# Currently fails to build - ld.bfd unrecognized option '-Wl,--rpath-link,...
#UNSUPPORTED_ARCHS += armada37xx rtd1296

REQUIRE_KERNEL = 1
UNSUPPORTED_KERNEL = 2.6.32
UNSUPPORTED_KERNEL += 3.2.40

HOMEPAGE = https://linuxtv.org/
COMMENT  = The LinuxTV community develops and maintains the Linux Kernel Media Subsystems and several userspace libraries and applications.
LICENSE  = GPLv2

FIRMWARE_URL = http://www.linuxtv.org/downloads/firmware/
FIRMWARE_PKG = dvb-firmwares.tar.bz2

PRE_PATCH_TARGET = linuxtv_pre_patch
CONFIGURE_TARGET = linuxtv_configure
COMPILE_TARGET = linuxtv_compile
INSTALL_TARGET = linuxtv_install

# Disable all PCI adapters
include blacklist.mk

# Blacklist modules that does not compile
BLACKLIST += CONFIG_VIDEO_IVTV

include ../../mk/spksrc.cross-cc.mk

# Unsupported kernels
ifeq ($(findstring $(TC_KERNEL),$(UNSUPPORTED_KERNEL)),$(TC_KERNEL))
  ifneq (,$(BUILD_UNSUPPORTED_FILE))
    $(shell echo $(date --date=now +"%Y.%m.%d %H:%M:%S") - $(NAME): Kernel version '$(TC_KERNEL)' is not supported >> $(BUILD_UNSUPPORTED_FILE))
  endif
  @$(error Kernel version '$(TC_KERNEL)' is not supported)
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
	# Disable modules that do not compile
	$(RUN) $(foreach kmodule,$(BLACKLIST),sed -i 's/$(kmodule)=m/# $(kmodule) is not set/' v4l/.config ;)

.PHONY: linuxtv_compile
linuxtv_compile:
	$(RUN) make -j`nproc` MAKEFLAGS=
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
