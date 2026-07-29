PKG_NAME = extism-js
PKG_VERS = 1.6.0
PKG_EXT = gz
PKG_DIST_NAME = extism-js-x86_64-linux-v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/extism/js-pdk/releases/download/v$(PKG_VERS)
PKG_DIR =

HOMEPAGE = https://github.com/extism/js-pdk
COMMENT  = Extism JavaScript PDK compiler (JS to WASM)
LICENSE  = BSD-3-Clause

EXTRACT_TARGET = extism_js_extract
INSTALL_TARGET = extism_js_install

include ../../mk/spksrc.native-install.mk

.PHONY: extism_js_extract
extism_js_extract:
	gunzip -c $(DIST_FILE) > $(EXTRACT_PATH)/extism-js
	chmod +x $(EXTRACT_PATH)/extism-js

.PHONY: extism_js_install
extism_js_install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin
	install -m 755 $(WORK_DIR)/extism-js $(STAGING_INSTALL_PREFIX)/bin/
