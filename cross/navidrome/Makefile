PKG_NAME = navidrome
PKG_VERS = 0.51.0
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
COMPILE_MAKE_OPTIONS = buildall

CGO_ENABLED = 1
GO_BIN_DIR = $(WORK_DIR)/$(PKG_DIR)/$(PKG_NAME)

# with parallel make, sometimes the frontent build (make buildjs) fails with:
# # github.com/navidrome/navidrome/ui
# ui/embed.go:9:5: embed build/asset-manifest.json: open ui/build/asset-manifest.json: no such file or directory
# ui/embed.go:9:5: embed build/index.html: open ui/build/index.html: no such file or directory
.NOTPARALLEL:

include ../../mk/spksrc.cross-go.mk

ENV += NPM_CONFIG_USER=root
PATH := $(WORK_DIR)/../../../native/nodejs/work-native/node/bin:$(PATH)

# avoid webpack error ERR_OSSL_EVP_UNSUPPORTED with nodejs v18
ENV += NODE_OPTIONS=--openssl-legacy-provider

.PHONY: navidrome_pre_compile
# without "make buildjs" make buildall has warning:
# WARNING: This command does not build the frontend, it uses the latest built with 'make buildjs'
navidrome_pre_compile:
	@$(MSG) Prepare Navidrom build with "make setup"
	@$(RUN) $(MAKE) setup
	@$(MSG) Prepare Navidrom build with "make buildjs"
	@$(RUN) $(MAKE) buildjs
