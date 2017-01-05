SPK_NAME = domoticz
SPK_VERS = 2.0.2563
SPK_REV = 7
SPK_ICON = src/domoticz.png
DSM_UI_DIR = app
BETA = 1

DEPENDS = cross/busybox cross/$(SPK_NAME)

MAINTAINER = Diaoul
DESCRIPTION = Domoticz is a Home Automation System that lets you monitor and configure various devices like: Lights, Switches, various sensors/meters like Temperature, Rain, Wind, UV, Electra, Gas, Water and much more. Notifications/Alerts can be sent to any mobile device.
DESCRIPTION_FRE = Domoticz est un système domotique qui vous permet de surveiller et de configurer différents périphériques tels que: Lumières, Interrupteurs, divers capteurs/compteurs  afin de surveiller température, pluie, vent, UV, électricité, gaz, eau et bien plus encore. Notifications et alertes peuvent être envoyées à n\\\'importe quel appareil mobile.
ADMIN_PORT = 8084
RELOAD_UI = yes
DISPLAY_NAME = Domoticz
CHANGELOG = "1. Includes OpenZwave support<BR>2. fix RFlink causing crash on malformed input<BR>3. add USB drivers for pl2303<BR>4. fix backups directory permission<BR>5. upgrade now preserves scripts and backups<BR>5.  Updated to SVN revision 2563<BR>6. Removed Python dependency<BR>7. Moved approot to /var<BR>8. Added Libudev<BR>9. removed Dependency on cross/openzwave as domoticz ships its own "

HOMEPAGE = http://www.domoticz.com/
LICENSE  = 

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS = src/$(SPK_NAME).sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = domoticz_extra_install

BUSYBOX_CONFIG = usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: domoticz_extra_install
domoticz_extra_install:
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/var/backups
	install -m 755 -d $(STAGING_DIR)/var/backups/hourly
	install -m 755 -d $(STAGING_DIR)/var/backups/daily
	install -m 755 -d $(STAGING_DIR)/var/backups/weekly
	install -m 755 -d $(STAGING_DIR)/rules.d
	install -m 644 src/60-synocommunity.domoticz.rules $(STAGING_DIR)/rules.d/60-synocommunity.domoticz.rules
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72 ; do \
	    convert $(SPK_ICON) -thumbnail $${size}x$${size} \
	            $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
