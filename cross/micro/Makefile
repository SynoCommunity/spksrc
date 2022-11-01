PKG_NAME = micro
PKG_VERS = 2.0.11
PKG_EXT = tar.gz
# make sure the hash matches this release, as it is shown with 'micro --version'
GIT_HASH = 225927b
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/zyedidia/micro/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = native/go

HOMEPAGE = https://micro-editor.github.io/
COMMENT  = a modern and intuitive terminal-based text editor.
LICENSE  = MIT

GOPATH = $(WORK_DIR)

COMPILE_MAKE_OPTIONS += VERSION=$(PKG_VERS) HASH=$(GIT_HASH)

INSTALL_TARGET = micro_install

include ../../mk/spksrc.cross-go.mk

.PHONY: micro_install
micro_install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin
	@$(RUN) ; install -m 755 micro $(STAGING_INSTALL_PREFIX)/bin
