SPK_NAME = synokernel-cdrom
SPK_VERS = 1.3
SPK_REV = 3
SPK_ICON = src/$(SPK_NAME).png

DEPENDS = 

REQUIRE_KERNEL ?= 1
REQUIRE_KERNEL_MODULE  = CONFIG_CDROM_PKTCDVD:drivers/cdrom:cdrom
REQUIRE_KERNEL_MODULE += CONFIG_BLK_DEV_SR:drivers/scsi:sr_mod

MAINTAINER = th0ma7
DESCRIPTION = "Provides Synology kernel CD-ROM drivers cdrom.ko and sr_mod.ko"
CHANGELOG = "1. Support DSM-7.1 and DSM-7.2"

UNSUPPORTED_ARCHS = $(PPC_ARCHS) epyc7002 rtd1619b

STARTABLE = no
DISPLAY_NAME = SynoKernel USB CD-ROM drivers

HOMEPAGE = https://www.kernel.org/
LICENSE  = GPLv2

SPK_DEPENDS = synocli-kernel

STRIP_TARGET = nop
POST_STRIP_TARGET = synokernel-cdrom_extra-install

include ../../mk/spksrc.spk.mk

.PHONY: synokernel-cdrom_extra-install
synokernel-cdrom_extra-install:
	install -m 755 -d $(STAGING_DIR)/etc/
	install -m 644 src/synokernel-cdrom.cfg $(STAGING_DIR)/etc/
