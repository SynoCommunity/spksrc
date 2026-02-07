SPK_NAME = beszel-agent
SPK_VERS = 0.18.3
SPK_REV = 1
SPK_ICON = src/beszel.png

DEPENDS = cross/beszel-agent

MAINTAINER = not-first
DESCRIPTION = Lightweight server monitoring with historical data, docker stats, and alerts. This package provides only the agent, and requires Beszel Hub to be running elsewhere. See Beszel documentation for information on setting up SMART monitoring.

DISPLAY_NAME = Beszel Agent
CHANGELOG = "Initial package release for Beszel 0.18.3"

HOMEPAGE = https://beszel.dev/
LICENSE = MIT

STARTABLE = yes
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 45876
NO_SERVICE_SHORTCUT = y

WIZARDS_DIR = src/wizard/

include ../../mk/spksrc.spk.mk
