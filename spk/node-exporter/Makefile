SPK_NAME = node-exporter
SPK_VERS = 1.10.2
SPK_REV = 6
SPK_ICON = src/node-exporter.png

DEPENDS = cross/node-exporter

UNSUPPORTED_ARCHS = $(PPC_ARCHS)

MAINTAINER = chiehmin
DESCRIPTION = Prometheus exporter for hardware and OS metrics exposed by *NIX kernels.
STARTABLE = yes
DISPLAY_NAME = Node Exporter
CHANGELOG = "Update to v1.10.2"

HOMEPAGE = https://github.com/prometheus/node_exporter
LICENSE  = Apache License 2.0

ADMIN_PORT = 9100
FWPORTS = src/node-exporter.sc

SERVICE_SETUP = src/service-setup.sh

POST_STRIP_TARGET = node-exporter_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: node-exporter_extra_install
node-exporter_extra_install:
	@install -m 755 -d $(STAGING_DIR)/var
	@install -m 644 src/parameters.txt $(STAGING_DIR)/var/
