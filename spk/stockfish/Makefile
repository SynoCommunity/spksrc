SPK_NAME = stockfish
SPK_VERS = 19
SPK_REV = 5
SPK_ICON = src/stockfish.png

DEPENDS = cross/stockfish
BUILD_DEPENDS = native/nodejs-22
SPK_DEPENDS = "Node.js_v22"

# Node.js_v22 (Synology package) declares os_min_ver="7.2-60085"
REQUIRED_MIN_DSM = 7.2

MAINTAINER = mayweed
DISPLAY_NAME = Stockfish
DESCRIPTION = Strong open source chess engine. Stockfish is one of the strongest chess engines in the world. It is also much stronger than the best human chess grandmasters.
CHANGELOG = "Update to v19 (requires DSM 7.2)."
HOMEPAGE = https://stockfishchess.org/
LICENSE = GPLv3

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
STARTABLE = yes

SERVICE_PORT = 8300
SERVICE_PORT_TITLE = Stockfish Web GUI
ADMIN_PORT = $(SERVICE_PORT)

SPK_COMMANDS = bin/stockfish

POST_STRIP_TARGET = stockfish_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: stockfish_extra_install
stockfish_extra_install:
	install -m 755 -d $(STAGING_DIR)/share/webgui
	cp -a src/webgui/. $(STAGING_DIR)/share/webgui/
	cd $(STAGING_DIR)/share/webgui && \
		PATH=$(realpath $(WORK_DIR)/../../../native/nodejs-22/work-native/node)/bin:$$PATH \
		HOME=$(WORK_DIR) npm install --production --no-audit --no-fund
