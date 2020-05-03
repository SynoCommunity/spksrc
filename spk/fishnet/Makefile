SPK_NAME = fishnet
SPK_VERS = 17.2.1
SPK_REV = 1
SPK_ICON= src/fishnet.png

DEPENDS = cross/stockfish-niklasf

SPK_DEPENDS = "python3>=3.4"
PIP = pip3

MAINTAINER = mayweed
DESCRIPTION = FishNet is a distributed Stockfish analysis service for lichess.org. You need an api key from lichess.org to run this service.
DISPLAY_NAME = FishNet
HOMEPAGE = https://github.com/niklasf/fishnet#readme
CHANGELOG = "Initial package version."

LICENSE  = GPLv3
STARTABLE = no

WHEELS = src/requirements.txt

SERVICE_SETUP = src/service-setup.sh

POST_STRIP_TARGET = fishnet_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: fishnet_extra_install
fishnet_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/fishnet_template.ini $(STAGING_DIR)/var/fishnet_template.ini
