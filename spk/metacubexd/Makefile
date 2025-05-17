SPK_NAME = metacubexd
SPK_VERS = 1.186.1
SPK_REV = 1
SPK_ICON = src/metacubexd.png

DEPENDS = cross/metacubexd

override ARCH=noarch

MAINTAINER = wangbin1989
MAINTAINER_URL = https://github.com/wangbin1989

DESCRIPTION = Mihomo Dashboard, The Official One, XD
DISPLAY_NAME = "MetaCubeXD"
CHANGELOG = "Initial package release."

LICENSE = GPLv3

REQUIRED_MIN_DSM = 6.0

SPK_DEPENDS = WebStation:Apache2.4

SERVICE_USER = auto
SYSTEM_GROUP = http

SERVICE_SETUP = src/service-setup.sh

DSM_UI_DIR = app
DSM_UI_CONFIG = src/app/config

CONF_DIR = src/conf/

include ../../mk/spksrc.common.mk

ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
DSM_UI_CONFIG = src/app_6/config
CONF_DIR = src/conf_6/
POST_STRIP_TARGET = metacubexd_custom_post_strip
endif

STARTABLE = no

include ../../mk/spksrc.spk.mk

.PHONY: metacubexd_custom_post_strip
metacubexd_custom_post_strip:
	install -m 755 -d $(STAGING_DIR)/apache24
	install -m 644 src/metacubexd.conf $(STAGING_DIR)/apache24/metacubexd.conf
