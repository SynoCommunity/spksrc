SPK_NAME = domoticz
SPK_VERS = 281
SPK_REV = 1
SPK_ICON = src/domoticz.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = Domoticz is a Home Automation System that lets you monitor and configure various devices like: Lights, Switches, various sensors/meters like Temperature, Rain, Wind, UV, Electra, Gas, Water and much more. Notifications/Alerts can be sent to any mobile device.
DESCRIPTION_FRE = Domoticz est un système domotique qui vous permet de surveiller et de configurer différents périphériques tels que: Lumières, Interrupteurs, divers capteurs/compteurs  afin de surveiller température, pluie, vent, UV, électricité, gaz, eau et bien plus encore. Notifications et alertes peuvent être envoyées à n\\\'importe quel appareil mobile.
RELOAD_UI = yes
DISPLAY_NAME = Domoticz

HOMEPAGE = http://www.domoticz.com/
LICENSE  = 

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS =

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

#POST_STRIP_TARGET = domoticz_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: domoticz_extra_install
domoticz_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 src/app/domoticz.cgi.pl $(STAGING_DIR)/app/domoticz.cgi
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 ; \
	do \
	    convert $(SPK_ICON) -thumbnail $${size}x$${size} \
	            $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
