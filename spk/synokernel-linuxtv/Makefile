SPK_NAME = synokernel-linuxtv

# Set package version based on kernel
# kernel < 4.4 is frozon at version f6e3542
# and too early in the build process to use
# version_lt from spksrc.common.mk
ifeq ($(findstring $(ARCH),avoton braswell broadwell bromolow dockerx64 grantley),$(ARCH))
SPK_GIT_HASH = f6e3542
SPK_GIT_DATE = 20210113
else
SPK_GIT_HASH = 70188fd
SPK_GIT_DATE = 20210323
endif

SPK_VERS = $(SPK_GIT_DATE)~$(SPK_GIT_HASH)
SPK_REV = 12
SPK_ICON = src/linuxtv.png
CHANGELOG = "1. First experimental linuxtv driver package set for apollolake<br/>2. Backport of MYGICA T230A driver for 4.4.59 kernel"

DEPENDS = driver/linuxtv

ifeq ($(strip $(TC_TYPE)),DSM)
REQUIRED_DSM = 6.2.3
else ifeq ($(strip $(TC_TYPE)),SRM)
REQUIRED_SRM = 1.2
endif

REQUIRE_KERNEL = 1
REQUIRE_KERNEL_MODULE = CONFIG_REGMAP_I2C:drivers/base/regmap:regmap-i2c

MAINTAINER = th0ma7
DESCRIPTION = The LinuxTV community develops and maintains the Linux Kernel Media Subsystems and several libraries and applications.
DESCRIPTION_FRE = La communauté LinuxTV développe et maintient les sous-systèmes multimédia du noyau Linux et plusieurs bibliothèques et applications.

RELOAD_UI = no
STARTABLE = yes
DISPLAY_NAME = SynoKernel LinuxTV media drivers

WIZARDS_DIR = src/wizard/

HOMEPAGE = https://linuxtv.org/
LICENSE  = GPLv2

SPK_DEPENDS = synocli-kernel synocli-monitor

SSS_SCRIPT        = src/dsm-control.sh
SERVICE_SETUP     = src/service-setup.sh
# LinuxTV media-build does the strip at install time
STRIP_TARGET      = nop
POST_STRIP_TARGET = linuxtv_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: linuxtv_extra_install
linuxtv_extra_install:
	install -m 755 -d $(STAGING_DIR)/etc
	install -m 644 src/$(SPK_NAME).cfg $(STAGING_DIR)/etc/$(SPK_NAME).cfg
