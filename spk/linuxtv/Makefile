SPK_NAME = linuxtv
SPK_GIT_HASH = ce09077
SPK_GIT_DATE = 20200719
SPK_VERS = $(SPK_GIT_DATE)~$(SPK_GIT_HASH)
SPK_REV = 1
SPK_ICON = src/linuxtv.png
CHANGELOG = "1. First experimental linuxtv driver package set for apollolake<br/>2. More to come..."

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = th0ma7
DESCRIPTION = The LinuxTV community develops and maintains the Linux Kernel Media Subsystems and several libraries and applications.
DESCRIPTION_FRE = La communauté LinuxTV développe et maintient les sous-systèmes multimédia du noyau Linux et plusieurs bibliothèques et applications.
DISPLAY_NAME = linuxtv
STARTABLE = yes

HOMEPAGE = https://linuxtv.org/
LICENSE  = GPLv2

SERVICE_SETUP = src/service-setup.sh

include ../../mk/spksrc.spk.mk
