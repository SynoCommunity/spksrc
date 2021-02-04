SPK_NAME = synokernel-linuxtv
SPK_GIT_HASH = f6e3542
SPK_GIT_DATE = 20210113
SPK_VERS = $(SPK_GIT_DATE)~$(SPK_GIT_HASH)
SPK_REV = 1
SPK_ICON = src/linuxtv.png
CHANGELOG = "1. First experimental linuxtv driver package set for apollolake<br/>2. Add default generic statup scripts for other packages usage"

DEPENDS = cross/linuxtv

MAINTAINER = th0ma7
DESCRIPTION = The LinuxTV community develops and maintains the Linux Kernel Media Subsystems and several libraries and applications.
DESCRIPTION_FRE = La communauté LinuxTV développe et maintient les sous-systèmes multimédia du noyau Linux et plusieurs bibliothèques et applications.

RELOAD_UI = no
STARTABLE = yes
DISPLAY_NAME = SynoKernel LinuxTV media drivers

HOMEPAGE = https://linuxtv.org/
LICENSE  = GPLv2

SPK_DEPENDS = synocli-kernel

SSS_SCRIPT = src/dsm-control.sh
STRIP_TARGET = nop

include ../../mk/spksrc.spk.mk
