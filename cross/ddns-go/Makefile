PKG_NAME = ddns-go
PKG_VERS = 6.15.0
WEB_VERSION = $(PKG_VERS)
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/jeessy2/ddns-go/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = native/go

# lacking support for atomics
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS)
# not supported by go
UNSUPPORTED_ARCHS += $(PPC_ARCHS)

HOMEPAGE = https://github.com/jeessy2/ddns-go
COMMENT  = Automatically obtain your public IPv4 or IPv6 address and resolve it to the corresponding domain name service.
LICENSE = MIT

COMPILE_TARGET = ddns-go_compile_target
INSTALL_TARGET = ddns-go_install

include ../../mk/spksrc.cross-go.mk

.PHONY: ddns-go_compile_target
ddns-go_compile_target:
	@$(RUN) $(MAKE) VERSION=v$(PKG_VERS) BUILD_TIME="$$(date -u +'%Y-%m-%dT%H:%M:%SZ')" build

.PHONY: ddns-go_install
ddns-go_install:
	@mkdir -p $(STAGING_INSTALL_PREFIX)/bin
	@install -m 755 $(WORK_DIR)/$(PKG_DIR)/ddns-go $(STAGING_INSTALL_PREFIX)/bin/
