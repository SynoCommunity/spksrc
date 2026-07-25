SPK_NAME = activebackup-prometheus-exporter
SPK_VERS = 1.0.3
SPK_REV = 3
SPK_ICON = 

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = fleaz
DESCRIPTION = Prometheus exporter for backup jobs from the ActiveBackup tool suite
STARTABLE = yes
DISPLAY_NAME = ActiveBackup Prometheus Exporter
CHANGELOG = ""

HOMEPAGE = https://github.com/codemonauts/activebackup-prometheus-exporter
LICENSE  = MIT

SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT=9763
SERVICE_PORT_URL="/metrics"

include ../../mk/spksrc.spk.mk
