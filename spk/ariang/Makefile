SPK_NAME = ariang
SPK_VERS = 1.3.15
SPK_REV = 2
SPK_ICON = src/ariang.png
DSM_UI_DIR = app

DEPENDS = cross/ariang

SPK_DEPENDS = "WebStation>=2.1.0"

# SRM is not supported due lacking webstation package
REQUIRED_MIN_SRM = 3.0

MAINTAINER = vitkabele
DESCRIPTION = AriaNg, a modern web frontend making aria2 easier to use.
CHANGELOG = "Update to AriaNg 1.3.15."
ADMIN_URL = /ariang/
DISPLAY_NAME = AriaNg

HOMEPAGE = https://ariang.mayswind.net/
LICENSE  = MIT

CONF_DIR = src/conf
STARTABLE = no

# Pure PHP package, make sure ARCH is noarch
override ARCH=noarch

include ../../mk/spksrc.spk.mk
