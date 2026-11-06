PKG_NAME = yarr
PKG_VERS = 2.6
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/nkanaev/yarr/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = native/go

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(PPC_ARCHS)

HOMEPAGE = https://github.com/nkanaev/yarr
COMMENT  = Yarr is a web-based feed aggregator (RSS, Atom, JSON Feed).
LICENSE  = MIT

CGO_ENABLED = 1
GO_BIN_DIR = $(WORK_DIR)/$(PKG_DIR)/out/yarr
COMPILE_TARGET = yarr_compile

include ../../mk/spksrc.cross-go.mk

.PHONY: yarr_compile
yarr_compile:
	@$(MSG) "- Build yarr"
	@$(RUN) $(MAKE) host
