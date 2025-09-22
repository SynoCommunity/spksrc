SPK_NAME = synokernel-cdrom
SPK_VERS = 1.3
SPK_REV = 3
SPK_ICON = src/synokernel-cdrom.png

DEPENDS =

REQUIRE_KERNEL ?= 1
REQUIRE_KERNEL_MODULE  = CONFIG_CDROM_PKTCDVD:drivers/cdrom:cdrom
REQUIRE_KERNEL_MODULE += CONFIG_BLK_DEV_SR:drivers/scsi:sr_mod

MAINTAINER = th0ma7
DESCRIPTION = "Provides Synology kernel CD-ROM drivers cdrom.ko and sr_mod.ko"
CHANGELOG = "1. Support DSM-7.1 and DSM-7.2"

UNSUPPORTED_ARCHS = $(PPC_ARCHS)
# archs with kernel 5.x fail to build
# error: Cannot generate ORC metadata for CONFIG_UNWINDER_ORC=y, please install libelf-dev, libelf-devel or elfutils-libelf-devel
# with installation of elfutils and libelf-dev to the development environment,
# it further fails with error: pointer may be used after ‘realloc’ [-Werror=use-after-free]
UNSUPPORTED_ARCHS += epyc7002 rtd1619b
# we only have ipq806x for SRM 1.2, but this fails with:
# /usr/bin/ld: scripts/dtc/dtc-parser.tab.o:(.bss+0x10): multiple definition of `yylloc'; scripts/dtc/dtc-lexer.lex.o:(.bss+0x0): first defined here
REQUIRED_MIN_SRM = 1.3

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
