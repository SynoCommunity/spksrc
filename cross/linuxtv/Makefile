PKG_NAME = linuxtv
PKG_VERS = ea2766f
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_GIT_HASH = ea2766f182b3a4e03543be2ded0845fca4d4fa80
PKG_DIST_SITE = http://git.linuxtv.org/cgit.cgi/media_build.git
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)
MOD_DIR = /lib/modules

REQ_KERNEL = 1
DEPENDS =

HOMEPAGE = https://linuxtv.org/
COMMENT  = The LinuxTV community develops and maintains the Linux Kernel Media Subsystems and several userspace libraries and applications.
LICENSE  = GPLv2

#CONFIGURE_ARGS = 

FIRMWARE_URL = http://www.linuxtv.org/downloads/firmware/
FIRMWARE_PKG = dvb-firmwares.tar.bz2

CONFIGURE_TARGET = linuxtv_configure
COMPILE_TARGET = linuxtv_compile

include ../../mk/spksrc.cross-cc.mk

.PHONY: linuxtv_configure
linuxtv_configure:
	$(RUN) make release DIR=$(WORK_DIR)/../../../kernel/syno-$(ARCH)-$(TCVERSION)/work/source/linux
	$(RUN) make -C linux/ download
	$(RUN) make -C linux/ untar
	$(RUN) wget $(FIRMWARE_URL)/$(FIRMWARE_PKG) -O $(FIRMWARE_PKG)
	$(RUN) tar xvfj $(FIRMWARE_PKG) -C v4l
	# Final preparation for build
	$(RUN) make allyesconfig
	# Disable modules that do not compile
	$(RUN) sed -i 's/CONFIG_VIDEOBUF_DMA_SG=m/# CONFIG_VIDEOBUF_DMA_SG is not set/' v4l/.config
#	$(RUN) sed -i 's/CONFIG_VIDEOBUF2_V4L2=m/# CONFIG_VIDEOBUF2_V4L2 is not set/' v4l/.config
#	$(RUN) sed -i 's/CONFIG_VIDEOBUF2_MEMOPS=m/# CONFIG_VIDEOBUF2_MEMOPS is not set/' v4l/.config
	$(RUN) sed -i 's/CONFIG_VIDEO_IVTV=m/# CONFIG_VIDEO_IVTV is not set/' v4l/.config

.PHONY: linuxtv_compile
linuxtv_compile:
	$(RUN) make -j`nproc` MAKEFLAGS=
	# Disable depmod call for later install
	$(RUN) sed -i '/depmod/s/^/#/' v4l/Makefile.media
