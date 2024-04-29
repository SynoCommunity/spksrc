PKG_NAME = duf
PKG_VERS = 0.8.1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/muesli/duf/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = native/go

HOMEPAGE = https://github.com/muesli/duf
COMMENT  = Disk Usage/Free Utility - a better 'df' alternative.
LICENSE  = MIT

PRE_COMPILE_TARGET = duf_pre_compile

GO_SRC_DIR = $(WORK_DIR)/$(PKG_DIR)
GO_BIN_DIR = $(GO_SRC_DIR)/$(PKG_NAME)

include ../../mk/spksrc.cross-go.mk

.PHONY: duf_pre_compile
duf_pre_compile:
	@$(MSG) Patch version into main.go
	@$(RUN) ; sed -e 's|Version = ""|Version = "$(PKG_VERS)"|g' -i main.go
