SPK_NAME = syno-magnet
SPK_VERS = 1.0
# unreleased - refactored to use cross/syno-magnet
SPK_REV = 4
SPK_ICON = src/magnet.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = neykov
DESCRIPTION = Download Station Magnet Handler. Register Download Station as the application to download magnet links from your browser. No plugins required.
DISPLAY_NAME = Download Station Magnet
CHANGELOG = "Initial Version"

HOMEPAGE = https://github.com/neykov/syno-magnet
LICENSE = Apache 2.0

DSM_UI_DIR = app
SERVICE_TYPE = legacy
SERVICE_URL = /webman/3rdparty/syno-magnet/index.html
SERVICE_PORT_ALL_USERS = true

# exported as used by cross/syno-magnet
export DSM_UI_DIR
export DESCRIPTION
export DISPLAY_NAME
export SERVICE_TYPE
export SERVICE_URL
export SERVICE_PORT_ALL_USERS

# Pure web package, make sure ARCH is noarch
override ARCH=noarch

STARTABLE  = no

include ../../mk/spksrc.spk.mk
