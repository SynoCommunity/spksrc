SPK_NAME = synokernel-cdrom
SPK_VERS = 1.0
SPK_REV = 1
#SPK_ICON = src/$(SPK_NAME).png
CHANGELOG = "1. Synology Kernel CD-ROM drivers"

DEPENDS = 

REQUIRE_KERNEL ?= 1
REQUIRE_KERNEL_MODULE  = CONFIG_CDROM_PKTCDVD:drivers/cdrom:cdrom
REQUIRE_KERNEL_MODULE += CONFIG_BLK_DEV_SR:drivers/scsi:sr_mod

MAINTAINER = th0ma7
DESCRIPTION = "1. Includes cdrom.ko and sr_mod.ko"

UNSUPPORTED_ARCHS = $(PPC_ARCHS)

RELOAD_UI = no
STARTABLE = no
DISPLAY_NAME = SynoKernel USB CD-ROM drivers

HOMEPAGE = https://www.kernel.org/
LICENSE  = GPLv2

SPK_DEPENDS = synocli-kernel

STRIP_TARGET = nop

include ../../mk/spksrc.spk.mk
