SPK_NAME = firebird
SPK_VERS = 4.0.3
SPK_ICON = src/firebird.png
SPK_REV = 1

DEPENDS = cross/$(SPK_NAME)

DISPLAY_NAME = FirebirdSQL
DESCRIPTION = Firebird is a relational database with excelent concurrency and high performance.
CHANGELOG = "Add FirebirdSQL DB server in version 4.0.3"
HOMEPAGE = https://firebirdsql.org/
MAINTAINER = vitkabele
LICENSE  = MPL

OS_MIN_VERS = 7.0
REQUIRED_MIN_DSM = 7.0
REQUIRED_MAX_DSM = 7.1

WIZARDS_DIR = src/wizard

# Startable service properties
STARTABLE = yes
SERVICE_SETUP = src/service-setup.sh
SERVICE_USER = auto
SERVICE_PORT = 3050
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

include ../../mk/spksrc.spk.mk

