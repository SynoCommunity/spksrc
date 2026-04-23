SPK_NAME = node-red
SPK_VERS = 3.0.2
SPK_REV = 1
SPK_ICON = src/node-red.png
DSM_UI_DIR = app

DEPENDS = cross/node-red


# https://nodejs.dev/en/about/releases/
# DSM 6 has nodejs v12 (and v8) only (all EOL)
# DSM 7 has nodejs v12, v14, v16 and v18 (LTS versions)
# DSM 5 and SRM have no nodejs package from Synology
REQUIRED_MIN_DSM = 6
# SRM is not supported, set to dummy min version >= 2.x
REQUIRED_MIN_SRM = 2


MAINTAINER = hgy59
DESCRIPTION = "Node-RED is a programming tool for wiring together hardware devices, APIs and online services in new and interesting ways.  It provides a browser-based editor that makes it easy to wire together flows using the wide range of nodes in the palette that can be deployed to its runtime in a single-click."
DISPLAY_NAME = Node-RED
STARTABLE = yes
CHANGELOG = "Initial package release."
HOMEPAGE = https://nodered.org/
LICENSE = Apache 2.0

include ../../mk/spksrc.common.mk
ifeq ($(call version_ge, $(TCVERSION), 7.0),1)
SPK_DEPENDS = "Node.js_v18"
else
SPK_DEPENDS = "Node.js_v12"
endif

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

# Service configuration
SERVICE_PORT = 1880
SERVICE_PORT_TITLE = Node-RED (HTTP)

# Admin link
ADMIN_PORT = $(SERVICE_PORT)

include ../../mk/spksrc.spk.mk
