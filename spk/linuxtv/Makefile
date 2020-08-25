SPK_NAME = linuxtv
SPK_GIT_HASH = ce09077
SPK_GIT_DATE = 20200719
SPK_VERS = $(SPK_GIT_DATE)~$(SPK_GIT_HASH)
SPK_REV = 1
SPK_ICON = src/linuxtv.png
CHANGELOG = "1. First experimental linuxtv driver package set for apollolake<br/>2. Add default generic statup scripts for other packages usage"

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = th0ma7
DESCRIPTION = The LinuxTV community develops and maintains the Linux Kernel Media Subsystems and several libraries and applications.
DESCRIPTION_FRE = La communauté LinuxTV développe et maintient les sous-systèmes multimédia du noyau Linux et plusieurs bibliothèques et applications.
DISPLAY_NAME = linuxtv

STARTABLE = yes
SSS_SCRIPT = src/dsm-control.sh

HOMEPAGE = https://linuxtv.org/
LICENSE  = GPLv2

STRIP_TARGET = nop
POST_STRIP_TARGET = linuxtv_extra_install

include ../../mk/spksrc.spk.mk

include ../../mk/spksrc.spk.mk

.PHONY: linuxtv_extra_install
linuxtv_extra_install:
	install -m 755 src/linuxtv.sh $(STAGING_DIR)/bin/
