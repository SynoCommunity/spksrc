SPK_NAME = synokernel-linuxtv
SPK_VERS = 20220605
SPK_REV = 13
SPK_ICON = src/synokernel-linuxtv.png

DEPENDS  = driver/linuxtv
DEPENDS += cross/dvb-firmwares

REQUIRE_KERNEL ?= 1
# regmap-i2c builds on the regmap core, which some kernels do not have
REQUIRE_KERNEL_MODULE = CONFIG_REGMAP_I2C:drivers/base/regmap:regmap-i2c:CONFIG_REGMAP

MAINTAINER = th0ma7
DESCRIPTION = LinuxTV media drivers for USB TV tuners and capture devices, with their firmware, built for each Synology kernel.
DESCRIPTION_FRE = Pilotes multimédia LinuxTV pour tuners TV et périphériques de capture USB, avec leurs micrologiciels, compilés pour chaque noyau Synology.
CHANGELOG = "1. LinuxTV media_build frozen per kernel version, built for every Synology kernel."

# The oldest media_build that still builds, driver/linuxtv-3.2, no longer
# applies its 2.6.32 backports (88f6281, qoriq)
MIN_KERNEL_VERSION = 3.2

# we only have ipq806x for SRM 1.2, but this fails with:
# /usr/bin/ld: scripts/dtc/dtc-parser.tab.o:(.bss+0x10): multiple definition of `yylloc'; scripts/dtc/dtc-lexer.lex.o:(.bss+0x0): first defined here
REQUIRED_MIN_SRM = 1.3

# epyc7003-7.3 toolchain exists but kernel sources are not provided yet.
UNSUPPORTED_ARCHS += epyc7003

STARTABLE = no
DISPLAY_NAME = SynoKernel LinuxTV media drivers

HOMEPAGE = https://linuxtv.org/
LICENSE  = GPLv2

SPK_DEPENDS = synocli-kernel

POST_STRIP_TARGET = synokernel-linuxtv_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: synokernel-linuxtv_extra_install
synokernel-linuxtv_extra_install:
	install -m 755 -d $(STAGING_DIR)/etc
	install -m 644 src/$(SPK_NAME).cfg $(STAGING_DIR)/etc/$(SPK_NAME).cfg
