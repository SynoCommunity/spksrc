SPK_NAME = synokernel-linuxtv
SPK_VERS = 1.0
SPK_REV = 1
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
# SRM 1.2 takes the 3.10 version for its gcc, whose backports miss the
# get_user_pages of its vanilla 4.4 kernel
REQUIRED_MIN_SRM = 1.3

STARTABLE = no
WIZARDS_DIR = src/wizard/
DISPLAY_NAME = SynoKernel LinuxTV media drivers

HOMEPAGE = https://linuxtv.org/
LICENSE  = GPLv2

# The device profiles moved to synocli-kernel 2.0
SPK_DEPENDS = "synocli-kernel>=2.0"

include ../../mk/spksrc.spk.mk
