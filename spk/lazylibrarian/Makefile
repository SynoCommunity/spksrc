SPK_NAME = lazylibrarian
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 7
SPK_ICON = src/lazylibrarian.png

DEPENDS =
SPK_DEPENDS = "python>2.7.3-3:git"

MAINTAINER = Diaoul
DESCRIPTION = LazyLibrarian is a program to follow authors and grab metadata for all your digital reading needs. It uses Goodreads.com for author info and book info websites as a source.
RELOAD_UI = yes
DISPLAY_NAME = LazyLibrarian
CHANGELOG = "Fix DSM 6 service start."

HOMEPAGE   = https://lazylibrarian.gitlab.io/
LICENSE    = GPLv3
STARTABLE  = yes

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8082
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

WIZARDS_DIR = src/wizard/

COPY_TARGET = nop
POST_STRIP_TARGET = lazylibrarian_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: lazylibrarian_extra_install
lazylibrarian_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 600 src/config.ini $(STAGING_DIR)/var/config.ini
