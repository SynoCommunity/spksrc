SPK_NAME = mtproxy
SPK_VERS = 1
SPK_REV = 3
SPK_ICON = src/${SPK_NAME}.jpg

REQUIRED_DSM = 5.2
BETA = 1

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = Anonym-tsk
# From TelegramMessenger/MTProxy
DESCRIPTION = Simple MT-Proto proxy server
DESCRIPTION_RUS = Простой MT-Proto прокси сервер
RELOAD_UI = yes
STARTABLE = yes
DISPLAY_NAME = MTProxy
CHANGELOG =

UNSUPPORTED_ARCHS = $(ARM_ARCHES) $(PPC_ARCHES)

HOMEPAGE = https://github.com/TelegramMessenger/MTProxy
LICENSE  = GPL

WIZARDS_DIR = src/wizard/

SERVICE_SETUP = src/service-setup.sh

POST_STRIP_TARGET = mtproxy_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: mtproxy_extra_install
mtproxy_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/mtproxy.conf $(STAGING_DIR)/var/mtproxy.conf
