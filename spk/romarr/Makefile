SPK_NAME = romarr
SPK_VERS = 1.13.2
SPK_REV = 1
SPK_ICON = src/romarr.png

DEPENDS = cross/romarr

# Pure Python: the server is the standard library plus requests, and every
# wheel below is py3-none-any, so one package serves every DSM architecture.
override ARCH=noarch

SPK_DEPENDS = "python312"

MAINTAINER = BlizzHacker
DESCRIPTION = ROMarr is the *arr for games. Request a title and ROMarr searches your indexers through Prowlarr, hands the best release to qBittorrent, SABnzbd or NZBGet, verifies what arrived against No-Intro and Redump, and files it into RomM, Gaseous, Retrom or a plain folder tree for ES-DE, Batocera, EmuDeck and RetroArch. ROMarr includes no games or BIOS files.
DISPLAY_NAME = ROMarr
CHANGELOG = "1. Initial package, ROMarr 1.13.2."

HOMEPAGE = https://romarr.app
LICENSE  = MIT

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

SERVICE_PORT = 6868
SERVICE_PORT_TITLE = $(DISPLAY_NAME) (HTTP)
ADMIN_PORT = $(SERVICE_PORT)

# The games shared folder: created if missing and made writable by sc-romarr.
WIZARDS_DIR = src/wizard
SERVICE_WIZARD_SHARENAME = wizard_games_share

# Large archives are extracted under TMPDIR; DSM's /tmp is a small tmpfs.
USE_ALTERNATE_TMPDIR = 1

POST_STRIP_TARGET = romarr_extra_install

include ../../mk/spksrc.spk.mk

# spksrc's WHEELS machinery cross-compiles a Python per architecture, which a
# noarch package has none of. Every wheel here is py3-none-any, so fetch them
# as built and ship them in the wheelhouse that install_python_wheels reads.
.PHONY: romarr_extra_install
romarr_extra_install:
	install -m 755 -d $(STAGING_DIR)/share/wheelhouse
	pip3 download --disable-pip-version-check --no-deps --only-binary=:all: \
	    --python-version 3.12 --implementation py --abi none --platform any \
	    --dest $(STAGING_DIR)/share/wheelhouse --requirement src/requirements-pure.txt
	install -m 644 src/requirements-pure.txt $(STAGING_DIR)/share/wheelhouse/requirements.txt
