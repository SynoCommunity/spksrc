SPK_NAME = stockfish
SPK_VERS = 16
SPK_REV = 4
SPK_ICON = src/stockfish.png
DSM_UI_DIR = app

DEPENDS = cross/stockfish cross/stockfish-webgui

MAINTAINER = mayweed
DESCRIPTION = Strong open source chess engine. Stockfish is one of the strongest chess engines in the world. It is also much stronger than the best human chess grandmasters.
CHANGELOG = "Update to v16 with improved NNUE and significantly stronger play."

DISPLAY_NAME = Stockfish
HOMEPAGE = https://stockfishchess.org/
LICENSE  = GPLv2/GPLv3

# ARMv5 and OLD_PPC lack C++ compiler support
# UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)
# C++17 required - GCC 8+ needed (excludes DSM 6.x and comcerto2k)
REQUIRED_MIN_DSM = 7.0
UNSUPPORTED_ARCHS = comcerto2k

SPK_DEPENDS = WebStation:PHP8.0:Apache2.4

SERVICE_USER = auto
SYSTEM_GROUP = http

SERVICE_SETUP = src/service-setup.sh
STARTABLE = no
WIZARDS_DIR = src/wizard
CONF_DIR = src/conf

POST_STRIP_TARGET = stockfish_extra_install

SPK_COMMANDS  = bin/stockfish

include ../../mk/spksrc.spk.mk

.PHONY: stockfish_extra_install
stockfish_extra_install:
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/webgui-config-template.php $(STAGING_DIR)/var/webgui-config-template.php
