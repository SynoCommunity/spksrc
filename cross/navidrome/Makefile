PKG_NAME = navidrome
PKG_VERS = 0.47.5
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/navidrome/navidrome/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = native/go native/nodejs
DEPENDS = cross/taglib

# C++11 compiler required
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS)
# go does not support ppc archs
UNSUPPORTED_ARCHS += $(PPC_ARCHS)

HOMEPAGE = https://www.navidrome.org/
COMMENT  = Ì†ºÌæß‚òÅ Modern Music Server and Streamer compatible with Subsonic/Airsonic.
LICENSE  = GPL-3.0 License

PRE_COMPILE_TARGET = navidrome_pre_compile
COMPILE_TARGET = navidrome_compile

CGO_ENABLED = 1
GO_BIN_DIR = $(WORK_DIR)/$(PKG_DIR)/$(PKG_NAME)

include ../../mk/spksrc.cross-go.mk

ENV += NPM_CONFIG_USER=root
PATH := $(WORK_DIR)/../../../native/nodejs/work-native/node/bin:$(PATH)

.PHONY: navidrome_pre_compile
navidrome_pre_compile:
	@$(RUN) $(MAKE) setup

.PHONY: navidrome_compile
navidrome_compile:
	@$(RUN) $(MAKE) buildall
