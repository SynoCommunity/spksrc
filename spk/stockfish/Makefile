SPK_NAME = stockfish
SPK_VERS = 16
SPK_REV = 4
SPK_ICON = src/stockfish.png

DEPENDS = cross/stockfish
BUILD_DEPENDS = native/nodejs_22

MAINTAINER = mayweed
DESCRIPTION = Strong open source chess engine. Stockfish is one of the strongest chess engines in the world. It is also much stronger than the best human chess grandmasters.
CHANGELOG = "Update to v16. Replace legacy PHP web GUI with modern Node.js-based interface using server-side engine."

DISPLAY_NAME = Stockfish
HOMEPAGE = https://stockfishchess.org/
LICENSE  = GPLv2/GPLv3

# C++17 requires GCC 8+ (excludes comcerto2k), Node.js excludes 32-bit archs
REQUIRED_MIN_DSM = 7.0
UNSUPPORTED_ARCHS = comcerto2k $(32bit_ARCHS)

SPK_DEPENDS = "Node.js_v18"

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
STARTABLE = yes

SERVICE_PORT = 3001
SERVICE_PORT_TITLE = Stockfish Web GUI (HTTP)
ADMIN_PORT = $(SERVICE_PORT)

POST_STRIP_TARGET = stockfish_extra_install

SPK_COMMANDS = bin/stockfish

# Path to native nodejs for build-time npm install
NODE_NATIVE = $(realpath $(WORK_DIR)/../../../native/nodejs_22/work-native/node)

include ../../mk/spksrc.spk.mk

.PHONY: stockfish_extra_install
stockfish_extra_install:
	install -m 755 -d $(STAGING_DIR)/share/webgui
	cp -a src/webgui/. $(STAGING_DIR)/share/webgui/
	@# Install npm dependencies at build time
	cd $(STAGING_DIR)/share/webgui && \
		PATH=$(NODE_NATIVE)/bin:$$PATH HOME=$(WORK_DIR) npm install --production --no-audit --no-fund
