SPK_NAME = stockfish
SPK_VERS = 11
SPK_REV = 3
SPK_ICON= src/stockfish.png
DSM_UI_DIR = app

DEPENDS = cross/$(SPK_NAME) cross/stockfish-webgui

MAINTAINER = mayweed
DESCRIPTION = Strong open source chess engine. Stockfish is one of the strongest chess engines in the world. It is also much stronger than the best human chess grandmasters.
CHANGELOG = "Initial package version. With web frontend to play chess against stockfish engine."

DISPLAY_NAME = Stockfish
RELOAD_UI = yes
HOMEPAGE = https://stockfishchess.org/
LICENSE  = GPLv2/GPLv3

INSTALL_DEP_SERVICES = apache-web
START_DEP_SERVICES = apache-web
INSTUNINST_RESTART_SERVICES = apache-web

SERVICE_SETUP = src/service-setup.sh
SSS_SCRIPT = src/start-stop-status.sh
WIZARDS_DIR = src/wizard

POST_STRIP_TARGET = stockfish_extra_install

# Toolchains lacking c++11 compiler ar not supported
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

SPK_COMMANDS  = bin/stockfish

include ../../mk/spksrc.spk.mk

.PHONY: stockfish_extra_install
stockfish_extra_install:
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/webgui-config-template.php $(STAGING_DIR)/var/webgui-config-template.php
