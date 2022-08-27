SPK_NAME = node-red
SPK_VERS = 3.0.2
SPK_REV = 1
SPK_ICON = src/node-red.png
DSM_UI_DIR = app

DEPENDS = cross/node-red

MAINTAINER = hgy59
DESCRIPTION = Node-RED is a programming tool for wiring together hardware devices, APIs and online services in new and interesting ways.  It provides a browser-based editor that makes it easy to wire together flows using the wide range of nodes in the palette that can be deployed to its runtime in a single-click.
DISPLAY_NAME = Node-RED
STARTABLE = yes
CHANGELOG = "Initial package release."
HOMEPAGE = https://nodered.org/
LICENSE = Apache 2.0

# DSM 6: Node.js_v12
# DSM 7: Node.js_v12, Node.js_v14 or Node.js_v16
#SPK_DEPENDS = "Node.js_v12"

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

# Service configuration
SERVICE_PORT = 1880
SERVICE_PORT_TITLE = Node-RED (HTTP)

# Admin link
ADMIN_PORT = $(SERVICE_PORT)

include ../../mk/spksrc.spk.mk
