SPK_NAME = postgresql
SPK_VERS = 10.11
SPK_REV = 1
SPK_ICON = src/postgresql.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = DigitalBox
DESCRIPTION = PostgreSQL is a powerful, open source object-relational database system with over 30 years of active development that has earned it a strong reputation for reliability, feature robustness, and performance

RELOAD_UI = yes
DISPLAY_NAME = PostgreSQL
STARTABLE = yes

HOMEPAGE   = http://www.postgresql.com
LICENSE    = MPL

WIZARDS_DIR = WIZARD_UIFILES

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT = src/start-stop-status.sh

include ../../mk/spksrc.spk.mk

