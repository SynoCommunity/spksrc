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

REQUIRED_MIN_DSM = 7

SPK_DEPENDS = WebStation:Apache2.4

SYSTEM_GROUP = http

DSM_UI_DIR = app
DSM_UI_CONFIG = src/app/config

CONF_DIR = src/conf/

STARTABLE = no

include ../../mk/spksrc.spk.mk
