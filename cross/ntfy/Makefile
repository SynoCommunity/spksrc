PKG_NAME = ntfy
PKG_VERS = 2.16.0
# keep the commit in sync with version $(PKG_VERS)
PKG_COMMIT = 4b474a89b7803e8f974f888021612c2c49cce734
PKG_DATE = $(shell date +%s)
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/binwiederhier/ntfy/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = native/go

DEPENDS =

# go does not support ppc archs
UNSUPPORTED_ARCHS = $(PPC_ARCHS)
# ARMv5 is lacking atomics support (error: '__ATOMIC_CONSUME' undeclared, error: '__ATOMIC_RELEASE' undeclared)
# and ARMv5 is not supported with go >= 1.24 anyway
UNSUPPORTED_ARCHS += $(ARMv5_ARCHS)

HOMEPAGE = https://ntfy.sh/
COMMENT  = Send push notifications to your phone or desktop using PUT/POST.
LICENSE  = Apache-2.0 and GPLv2

COMPILE_TARGET = ntfy_compile
INSTALL_TARGET = ntfy_install

GO = $(WORK_DIR)/../../../native/go/work-native/go/bin/go

include ../../mk/spksrc.cross-go.mk

.PHONY: ntfy_compile
# build similar to original Makefile targets: cli-deps-static-sites and cli-linux-server
# we can't use the original Makefile because it takes version and commit from 
# spksrc repo that we are running within.
# For the same reason we can't use goreleaser either.
ntfy_compile:
	@$(MSG) - build cli-linux-server
	@cd $(WORK_DIR)/$(PKG_DIR) && mkdir -p dist server/docs server/site && touch server/docs/index.html server/site/app.html
	@$(RUN) CGO_ENABLED=1 $(GO) build -o dist/ntfy \
		-tags sqlite_omit_load_extension,osusergo,netgo \
		-ldflags "-linkmode=external -extldflags=-static -s -w -X main.version=$(PKG_VERSION) -X main.commit=$(PKG_COMMIT) -X main.date=$(PKG_DATE)"

.PHONY: ntfy_install
ntfy_install:
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin/
	@install -m 755 $(WORK_DIR)/$(PKG_DIR)/dist/ntfy $(STAGING_INSTALL_PREFIX)/bin/
