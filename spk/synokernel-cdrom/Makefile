SPK_NAME = synokernel-cdrom
SPK_VERS = 1.3
SPK_REV = 7
SPK_ICON = src/synokernel-cdrom.png

DEPENDS =

REQUIRE_KERNEL ?= 1
REQUIRE_KERNEL_MODULE = CONFIG_CDROM_PKTCDVD:drivers/cdrom:cdrom
REQUIRE_KERNEL_MODULE += CONFIG_BLK_DEV_SR:drivers/scsi:sr_mod

MAINTAINER = th0ma7
DESCRIPTION = "Provides Synology kernel CD-ROM drivers cdrom.ko and sr_mod.ko."
CHANGELOG = "1. Add DSM-7.3 support. <br/>2. Add support for older DSM-7.0 and DSM-6.1<br/>3. Kernel modules stripped by the framework<br/>4. Add qoriq, ipq806x SRM-1.2 and epyc7003 DSM-7.4"

STARTABLE = no
WIZARDS_DIR = src/wizard/
DISPLAY_NAME = SynoKernel USB CD-ROM drivers

HOMEPAGE = https://www.kernel.org/
LICENSE  = GPLv2

# The device profiles moved to synocli-kernel 1.3-11
SPK_DEPENDS = "synocli-kernel>=1.3-11"

include ../../mk/spksrc.spk.mk
