SPK_NAME = yarr
SPK_VERS = 2.6
SPK_REV = 1
SPK_ICON = src/yarr.png

DEPENDS = cross/yarr

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(PPC_ARCHS)

MAINTAINER = alcides
DESCRIPTION = "Yarr is a lightweight web-based feed aggregator that supports RSS, Atom and JSON Feed. Data is stored locally in an SQLite database."
DISPLAY_NAME = Yarr
HOMEPAGE = https://github.com/nkanaev/yarr
LICENSE = MIT
CHANGELOG = "Initial release."

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 7070
SERVICE_PORT_TITLE = Yarr Web UI
ADMIN_PORT = $(SERVICE_PORT)

include ../../mk/spksrc.spk.mk
