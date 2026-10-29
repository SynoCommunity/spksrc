SPK_NAME = synokernel-cdrom
SPK_VERS = 2.0
SPK_REV = 8
SPK_ICON = src/synokernel-cdrom.png

DEPENDS =

REQUIRE_KERNEL ?= 1
REQUIRE_KERNEL_MODULE = CONFIG_CDROM_PKTCDVD:drivers/cdrom:cdrom
REQUIRE_KERNEL_MODULE += CONFIG_BLK_DEV_SR:drivers/scsi:sr_mod

MAINTAINER = th0ma7
DESCRIPTION = "Provides Synology kernel CD-ROM drivers cdrom.ko and sr_mod.ko."
CHANGELOG = "1. Modules loaded by device profile with synocli-kernelmodule 2.0"

STARTABLE = no
WIZARDS_DIR = src/wizard/
DISPLAY_NAME = SynoKernel USB CD-ROM drivers

HOMEPAGE = https://www.kernel.org/
LICENSE  = GPLv2

# The device profiles moved to synocli-kernel 2.0
SPK_DEPENDS = "synocli-kernel>=2.0"

include ../../mk/spksrc.spk.mk
