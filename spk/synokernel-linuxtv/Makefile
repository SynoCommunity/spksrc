SPK_NAME = synokernel-linuxtv
SPK_VERS = 20220605
SPK_REV = 13
SPK_ICON = src/synokernel-linuxtv.png

DEPENDS  = driver/linuxtv
# Firmware: the LinuxTV set, then the newer and larger one of LibreELEC
DEPENDS += driver/dvb-firmwares
DEPENDS += driver/dvb-firmwares-libreelec

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

STARTABLE = no
WIZARDS_DIR = src/wizard/
DISPLAY_NAME = SynoKernel LinuxTV media drivers

HOMEPAGE = https://linuxtv.org/
LICENSE  = GPLv2

# The device profiles moved to synocli-kernel 2.0
SPK_DEPENDS = "synocli-kernel>=2.0"

include ../../mk/spksrc.spk.mk
