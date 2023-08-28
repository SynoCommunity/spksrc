SPK_NAME = ariang
SPK_VERS = 1.3.6
SPK_REV = 1
SPK_ICON = src/ariang.png
DSM_UI_DIR = app

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = vitkabele
DESCRIPTION = AriaNg, a modern web frontend making aria2 easier to use.
ADMIN_URL = /ariang/
DISPLAY_NAME = AriaNg

HOMEPAGE = http://ariang.mayswind.net/
LICENSE  = MIT

include ../../mk/spksrc.common.mk

SPK_DEPENDS = "WebStation>=2.1.0"

CONF_DIR = src/conf
SSS_SCRIPT = src/dsm-control.sh

POST_STRIP_TARGET = ariang_extra_install

# Pure PHP package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: ariang_extra_install
ariang_extra_install:
	install -m 755 -d $(STAGING_DIR)/web
