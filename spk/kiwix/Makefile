SPK_NAME = kiwix
SPK_VERS = 3.7.0
SPK_REV  = 6
SPK_ICON = src/kiwix.png

DEPENDS = cross/kiwix-tools

# compiler too old for cross/libzim
REQUIRED_MIN_DSM = 7.0
UNSUPPORTED_ARCHS = comcerto2k

HOMEPAGE = https://www.kiwix.org/
DESCRIPTION = Kiwix is an offline reader for online content like Wikipedia, Project Gutenberg, or TED Talks. It makes knowledge available to people with no or limited internet access. The software as well as the content is free to use for anyone.
LICENSE  = GPLv3

MAINTAINER = hgy59
DISPLAY_NAME = Kiwix
CHANGELOG = "Update kiwix to v3.7.0."

SERVICE_USER = auto
STARTABLE = yes
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8092
SERVICE_PORT_TITLE = Kiwix (http)
ADMIN_PORT = $(SERVICE_PORT)

WIZARDS_DIR = src/wizard
SERVICE_WIZARD_SHARENAME = wizard_data_folder

POST_STRIP_TARGET = kiwix_extra_install

SPK_COMMANDS = bin/kiwix-manage bin/kiwix-search bin/kiwix-serve

include ../../mk/spksrc.spk.mk

.PHONY: kiwix_extra_install
kiwix_extra_install:
	install -d -m 755 $(STAGING_DIR)/var
	install -m 644 src/empty_library.xml  $(STAGING_DIR)/var/empty_library.xml
	install -m 644 src/kiwix.cfg  $(STAGING_DIR)/var/kiwix.cfg
