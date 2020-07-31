PKG_NAME = linuxtv
PKG_VERS = ea2766f
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_GIT_HASH = ea2766f182b3a4e03543be2ded0845fca4d4fa80
PKG_DIST_SITE = http://git.linuxtv.org/cgit.cgi/media_build.git
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)
MOD_DIR = /lib/modules

DEPENDS =

REQ_KERNEL = 1
UNSUPPORTED_KERNEL = 3.10.102+

HOMEPAGE = https://linuxtv.org/
COMMENT  = The LinuxTV community develops and maintains the Linux Kernel Media Subsystems and several userspace libraries and applications.
LICENSE  = GPLv2

#CONFIGURE_ARGS = 

FIRMWARE_URL = http://www.linuxtv.org/downloads/firmware/
FIRMWARE_PKG = dvb-firmwares.tar.bz2

CONFIGURE_TARGET = linuxtv_configure
COMPILE_TARGET = linuxtv_compile
INSTALL_TARGET = linuxtv_install

# (All non-USB modules should be disabled as well)
# Blacklist modules that does not compile
BLACKLIST = CONFIG_VIDEO_IVTV
BLACKLIST += CONFIG_VIDEOBUF_DMA_SG
BLACKLIST += CONFIG_VIDEOBUF2_MEMOPS

include ../../mk/spksrc.cross-cc.mk

# Unsupported kernels
ifeq ($(findstring $(TC_KERNEL),$(UNSUPPORTED_KERNEL)),$(TC_KERNEL))
@$(error Kernel version '$(TC_KERNEL)' unsupported)
endif

# Modules that does not compile under kernel 4.15
ifeq ($(findstring $(TC_KERNEL),4.4.15+),$(TC_KERNEL))
BLACKLIST += CONFIG_VIDEOBUF2_V4L2
endif

.PHONY: linuxtv_configure
linuxtv_configure:
	@$(MSG) "TC_KERNEL=$(TC_KERNEL)"
	@$(MSG) "BLACKLIST=$(BLACKLIST)"
	$(RUN) make release DIR=$(WORK_DIR)/../../../kernel/syno-$(ARCH)-$(TCVERSION)/work/source/linux
	$(RUN) make -C linux/ download
	$(RUN) make -C linux/ untar
	$(RUN) wget $(FIRMWARE_URL)/$(FIRMWARE_PKG) -O $(FIRMWARE_PKG)
	$(RUN) tar xvfj $(FIRMWARE_PKG) -C v4l
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
	$(RUN) find $(INSTALL_DIR)/$(INSTALL_PREFIX) -type f -name *.fw | sed -e 's,.*\(firmware\),\1,g' -e 's,^,bin:lib/,' >> ../PLIST
