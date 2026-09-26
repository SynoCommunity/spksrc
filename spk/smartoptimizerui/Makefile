SPK_NAME = smartoptimizerui
SPK_VERS = 2.1.0
SPK_REV = 1
SPK_ICON = src/smartoptimizerui.png

PYTHON_PACKAGE = python312

DEPENDS = cross/smart-optimizer-ui

MAINTAINER = MrRobot-88
DESCRIPTION = Smart Optimizer UI provides a web interface and optimization engines for Radarr and Sonarr, allowing users to find smaller releases while preserving configurable quality requirements.
DISPLAY_NAME = Smart Optimizer UI
CHANGELOG = "Initial SynoCommunity package release with RULES V2."

HOMEPAGE = https://github.com/MrRobot-88/Smart-Optimizer-UI
LICENSE = MIT

STARTABLE = yes
REQUIRED_MIN_DSM = 7.2

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

SERVICE_PORT = 8788
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

ADMIN_PORT = $(SERVICE_PORT)

USE_ALTERNATE_TMPDIR = 1

include ../../mk/spksrc.spk-meta.mk
