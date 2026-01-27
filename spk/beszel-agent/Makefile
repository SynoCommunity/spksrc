SPK_NAME = beszel-agent
SPK_VERS = 0.11.1
SPK_REV = 1
SPK_ICON = src/beszel.png

UNSUPPORTED_ARCHS = $(PPC_ARCHS)

DEPENDS = cross/beszel-agent

MAINTAINER = hgy59
DESCRIPTION = "Simple, lightweight server monitoring. This package provides the Beszel Agent only."

DISPLAY_NAME = Beszel Agent
CHANGELOG = "Initial package release."

HOMEPAGE = https://beszel.dev/
LICENSE  = MIT

STARTABLE = yes
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 45876
NO_SERVICE_SHORTCUT = y

WIZARDS_DIR = src/wizard/

include ../../mk/spksrc.spk.mk
