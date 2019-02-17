SPK_NAME = webgrabplus
SPK_VERS = 2.1
SPK_REV = 1
SPK_ICON = src/webgrabplus.png

DEPENDS = cross/$(SPK_NAME)
# depend on mono 5.4 for BTLS HttpWebClient support
SPK_DEPENDS = "mono>=5.4"

MAINTAINER = m4tt075
DESCRIPTION = WebGrab Plus is a multi-site incremental xmltv epg grabber. It collects tv-program guide data from selected tvguide sites for your favourite channels.
DISPLAY_NAME = WebGrabPlus
BETA = 1
STARTABLE = no
CHANGELOG = "Initial relase WebGrabPlus v2.1 for Synology"
HOMEPAGE = http://webgrabplus.com/
LICENSE = Freeware

WIZARDS_DIR = src/wizard/

# 'auto' reserved value grabs SPK_NAME
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

POST_STRIP_TARGET = webgrabplus_extra_install

REQUIRED_DSM = 5.0
# no PPC support for mono
UNSUPPORTED_ARCHS = $(PPC_ARCHES)

# Pure Mono package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: webgrabplus_extra_install
webgrabplus_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/WebGrab++.config.xml $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/var/siteini.pack
	cp -R $(STAGING_DIR)/share/$(SPK_NAME)/siteini.pack.update/* $(STAGING_DIR)/var/siteini.pack
	install -m 755 -d $(STAGING_DIR)/var/siteini.user
	install -m 755 -d $(STAGING_DIR)/bin
	install -m 644 src/tv_grab_wg++ $(STAGING_DIR)/bin
	install -m 644 src/run.sh $(STAGING_DIR)/bin
