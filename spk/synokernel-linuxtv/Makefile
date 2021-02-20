SPK_NAME = synokernel-linuxtv
SPK_VERS = $(SPK_GIT_DATE)~$(SPK_GIT_HASH)
SPK_REV = 1
SPK_ICON = src/linuxtv.png
CHANGELOG = "1. First experimental linuxtv driver package set for apollolake<br/>2. Backport of MYGICA T230A driver for 4.4.59 kernel"

DEPENDS = cross/linuxtv

MAINTAINER = th0ma7
DESCRIPTION = The LinuxTV community develops and maintains the Linux Kernel Media Subsystems and several libraries and applications.
DESCRIPTION_FRE = La communauté LinuxTV développe et maintient les sous-systèmes multimédia du noyau Linux et plusieurs bibliothèques et applications.

RELOAD_UI = no
STARTABLE = yes
DISPLAY_NAME = SynoKernel LinuxTV media drivers

WIZARDS_DIR = src/wizard/

HOMEPAGE = https://linuxtv.org/
LICENSE  = GPLv2

SPK_DEPENDS = synocli-kernel

SSS_SCRIPT = src/dsm-control.sh
STRIP_TARGET = nop
POST_STRIP_TARGET = linuxtv_extra_install

include ../../mk/spksrc.spk.mk

# Set package version based on kernel
ifeq ($(call version_lt, ${TC_KERNEL}, 4.4),1)
SPK_GIT_HASH = f6e3542
SPK_GIT_DATE = 20210113
else
SPK_GIT_HASH = a236fdd
SPK_GIT_DATE = 20210208
fi

.PHONY: linuxtv_extra_install
linuxtv_extra_install:
        install -m 755 -d $(STAGING_DIR)/etc
        install -m 644 src/$(SPK_NAME).cfg $(STAGING_DIR)/etc/$(SPK_NAME).cfg
