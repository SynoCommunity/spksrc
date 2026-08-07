SPK_NAME = domoticz
SPK_VERS = 2026.3
SPK_REV = 12
SPK_ICON = src/domoticz.png
DSM_UI_DIR = app

DEPENDS = cross/domoticz

# Requires C++ compiler, supporting at least C++17 (gcc 7 or newer, i.e. DSM 7.x toolchains).
MIN_GCC_VERSION = 7

MAINTAINER = SynoCommunity
DESCRIPTION = Domoticz is a Home Automation System that lets you monitor and configure various devices like: Lights, Switches, various sensors/meters like Temperature, Rain, Wind, UV, Electra, Gas, Water and much more. Notifications/Alerts can be sent to any mobile device.
DESCRIPTION_FRE = Domoticz est un système domotique qui vous permet de surveiller et de configurer différents périphériques tels que: Lumières, Interrupteurs, divers capteurs/compteurs afin de surveiller température, pluie, vent, UV, électricité, gaz, eau et bien plus encore. Notifications et alertes peuvent être envoyées à n\'importe quel appareil mobile.
DISPLAY_NAME = Domoticz
CHANGELOG = "1. Update domoticz to v2026.3. "

HOMEPAGE = https://www.domoticz.com/
LICENSE  = GPLv3

STARTABLE = yes
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8084
SERVICE_PORT_TITLE = Domoticz Web UI (HTTP)
ADMIN_PORT = $(SERVICE_PORT)
SERVICE_USER = auto

# Remove files not needed at runtime to slim down the package
# (python bytecode/tests, terminfo, and unused boost libraries)
POST_STRIP_TARGET = domoticz_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: domoticz_extra_install
domoticz_extra_install:
	@$(MSG) "Removing unnecessary python runtime and unused libraries"
	@find $(STAGING_DIR)/lib/python3.14 -type f -regex '.*\.py[co]' -delete
	@rm -rf $(STAGING_DIR)/lib/python3.14/__pycache__ \
	       $(STAGING_DIR)/lib/python3.14/idlelib \
	       $(STAGING_DIR)/lib/python3.14/tkinter \
	       $(STAGING_DIR)/lib/python3.14/turtledemo \
	       $(STAGING_DIR)/lib/python3.14/ensurepip \
	       $(STAGING_DIR)/lib/python3.14/pydoc_data
	@rm -rf $(STAGING_DIR)/share/terminfo
	@find $(STAGING_DIR)/lib -maxdepth 1 -name 'libboost_*' ! -name 'libboost_thread*' -delete
