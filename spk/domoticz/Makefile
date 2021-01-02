SPK_NAME = domoticz
SPK_VERS = 4.9700
SPK_REV = 9
SPK_ICON = src/domoticz.png
DSM_UI_DIR = app

DEPENDS = cross/busybox cross/$(SPK_NAME)

# archs lacking C++11 compiler (arm5 archs, ppc archs except QorIQ)
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

MAINTAINER = Diaoul
DESCRIPTION = Domoticz is a Home Automation System that lets you monitor and configure various devices like: Lights, Switches, various sensors/meters like Temperature, Rain, Wind, UV, Electra, Gas, Water and much more. Notifications/Alerts can be sent to any mobile device.
DESCRIPTION_FRE = Domoticz est un système domotique qui vous permet de surveiller et de configurer différents périphériques tels que: Lumières, Interrupteurs, divers capteurs/compteurs  afin de surveiller température, pluie, vent, UV, électricité, gaz, eau et bien plus encore. Notifications et alertes peuvent être envoyées à n\'importe quel appareil mobile.
ADMIN_PORT = 8084
RELOAD_UI = yes
DISPLAY_NAME = Domoticz
CHANGELOG = "Update openssl to 1.1."

HOMEPAGE = https://www.domoticz.com/
LICENSE  = GPLv3

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc
CONF_DIR         = src/conf/

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = domoticz_extra_install

BUSYBOX_CONFIG = usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: domoticz_extra_install
domoticz_extra_install:
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
