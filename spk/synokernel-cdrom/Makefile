SPK_NAME = synokernel-cdrom
SPK_VERS = 1.3
SPK_REV = 4
SPK_ICON = src/synokernel-cdrom.png

DEPENDS =

REQUIRE_KERNEL ?= 1
REQUIRE_KERNEL_MODULE = CONFIG_CDROM_PKTCDVD:drivers/cdrom:cdrom
REQUIRE_KERNEL_MODULE += CONFIG_BLK_DEV_SR:drivers/scsi:sr_mod

MAINTAINER = th0ma7
DESCRIPTION = "Provides Synology kernel CD-ROM drivers cdrom.ko and sr_mod.ko."
CHANGELOG = "Add support for Linux 5.x kernels."

UNSUPPORTED_ARCHS = $(PPC_ARCHS)
# we only have ipq806x for SRM 1.2, but this fails with:
# /usr/bin/ld: scripts/dtc/dtc-parser.tab.o:(.bss+0x10): multiple definition of `yylloc'; scripts/dtc/dtc-lexer.lex.o:(.bss+0x0): first defined here
REQUIRED_MIN_SRM = 1.3

STARTABLE = no
DISPLAY_NAME = SynoKernel USB CD-ROM drivers

HOMEPAGE = https://www.kernel.org/
LICENSE  = GPLv2

SPK_DEPENDS = synocli-kernel

STRIP_TARGET = synokernel-cdrom_strip
POST_STRIP_TARGET = synokernel-cdrom_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: synokernel-cdrom_strip
synokernel-cdrom_strip:
	@$(MSG) Strip debug symbols in kernel modules
	find $(STAGING_DIR) -type f -name "*.ko" -exec $(STRIP) --strip-debug {} \;

.PHONY: synokernel-cdrom_extra_install
synokernel-cdrom_extra_install:
	install -m 755 -d $(STAGING_DIR)/etc/
	install -m 644 src/synokernel-cdrom.cfg $(STAGING_DIR)/etc/
