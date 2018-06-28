SPK_NAME = mylar
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 6
SPK_ICON = src/mylar.png

DEPENDS  =
SPK_DEPENDS = "python>2.7.3-3:git"

MAINTAINER = Diaoul
DESCRIPTION = Mylar is an automatic Comic Book downloader \(cbr/cbz\)
DESCRIPTION_FRE = Mylar permet le téléchargement automatique de Comic Book \(cbr/cbz\)
RELOAD_UI = yes
DISPLAY_NAME = Mylar
CHANGELOG = "Integrate with DSM5+6 Generic Service support and added to 'sc-download' group."

HOMEPAGE   = https://github.com/evilhero/mylar
LICENSE    = GPLv3
STARTABLE  = yes

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8090
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

WIZARDS_DIR = src/wizard/

COPY_TARGET = nop
POST_STRIP_TARGET = mylar_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: mylar_extra_install
mylar_extra_install: $(STAGING_DIR)/share/mylar
	install -m 755 -d $(STAGING_DIR)/var
	install -m 600 src/config.ini $(STAGING_DIR)/var/config.ini

$(STAGING_DIR)/share/mylar:
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && git clone https://github.com/evilhero/mylar.git mylar
