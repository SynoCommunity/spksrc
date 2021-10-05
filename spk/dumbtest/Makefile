SPK_NAME = dumbtest
SPK_VERS = 20211005
SPK_REV = 1
SPK_ICON = src/sickchill.png

BUILD_DEPENDS = cross/python38
DEPENDS = cross/PyNaCl
SPK_DEPENDS = "python38:git"

WHEELS = src/requirements.txt

MAINTAINER = BKSteve
DESCRIPTION = Test the python 38 depends
STARTABLE = yes
DISPLAY_NAME = dumbtest
CHANGELOG = "Initial dumbtest of Python 3.8"

LICENSE    = GPLv3+

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8081
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

WIZARDS_DIR = src/wizard/

POST_STRIP_TARGET = sickchill_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: sickchill_extra_install
sickchill_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
