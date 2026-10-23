SPK_NAME = speedketchup
SPK_VERS = 0.4.0
SPK_REV = 1
SPK_ICON = src/speedketchup.png

DEPENDS = cross/speedketchup

MAINTAINER = gatispei
DISPLAY_NAME = SpeedKetchup
DESCRIPTION = Runs an internet speed test against the nearest speedtest.net server every few minutes, stores the results and shows them with speed and latency charts, averages and a table of every result in its builtin web page.
HOMEPAGE = https://speedketchup.com
HELPURL = https://github.com/gatispei/speedketchup/issues
LICENSE = GPLv2
CHANGELOG = "Initial package release."

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8288
ADMIN_PORT = $(SERVICE_PORT)
SERVICE_PORT_TITLE = SpeedKetchup (HTTP)

POST_STRIP_TARGET = speedketchup_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: speedketchup_extra_install
speedketchup_extra_install:
	@install -m 755 src/speedketchup-service $(STAGING_DIR)/bin/
	@install -d -m 755 $(STAGING_DIR)/var
	@install -m 644 src/environment-variables $(STAGING_DIR)/var/
