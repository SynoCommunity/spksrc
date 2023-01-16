SPK_NAME = domoticz
SPK_VERS = 2020.2
SPK_REV = 10
SPK_ICON = src/domoticz.png
DSM_UI_DIR = app

DEPENDS = cross/$(SPK_NAME)

# archs lacking C++11 compiler (arm5 archs, ppc archs except QorIQ)
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

MAINTAINER = SynoCommunity
DESCRIPTION = Domoticz is a Home Automation System that lets you monitor and configure various devices like: Lights, Switches, various sensors/meters like Temperature, Rain, Wind, UV, Electra, Gas, Water and much more. Notifications/Alerts can be sent to any mobile device.
DESCRIPTION_FRE = Domoticz est un système domotique qui vous permet de surveiller et de configurer différents périphériques tels que: Lumières, Interrupteurs, divers capteurs/compteurs  afin de surveiller température, pluie, vent, UV, électricité, gaz, eau et bien plus encore. Notifications et alertes peuvent être envoyées à n\'importe quel appareil mobile.
DISPLAY_NAME = Domoticz
CHANGELOG = "1. Update domoticz to v2020.2<br/>2. Update openssl to 1.1.<br/>3. Update bundled python to 3.8<br/>4. Use generic service support."

HOMEPAGE = https://www.domoticz.com/
LICENSE  = GPLv3

STARTABLE = yes
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8084
SERVICE_PORT_TITLE = $(DISPLAY_NAME)
ADMIN_PORT = $(SERVICE_PORT)
SERVICE_USER = auto

include ../../mk/spksrc.common.mk
ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
# privilege file for DSM<=6 (use default for DSM >=7)
CONF_DIR = src/conf
endif

POST_STRIP_TARGET = domoticz_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: domoticz_extra_install
domoticz_extra_install:
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
