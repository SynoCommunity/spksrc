PKG_NAME = uptime-kuma
PKG_VERS = 2.5.5
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/louislam/uptime-kuma/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = native/nodejs_22

HOMEPAGE = https://uptime.kuma.pet
COMMENT  = A self-hosted monitoring tool
LICENSE  = MIT

INSTALL_TARGET = uptime_kuma_install

# Build environment - use native Node.js from spksrc
ENV += PATH=$(WORK_DIR)/../../../native/nodejs_22/work-native/node/bin:$$PATH

include ../../mk/spksrc.cross-install.mk

# Map spksrc ARCH to Node.js arch for native module downloads
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
NODE_ARCH = arm64
else
ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
NODE_ARCH = arm
else
NODE_ARCH = x64
endif
endif

.PHONY: uptime_kuma_install
uptime_kuma_install:
	@$(MSG) "Installing production dependencies for Uptime Kuma"
	$(RUN) npm ci --omit dev --no-audit --no-fund
	@$(MSG) "Fetching sqlite native binding for target arch ($(NODE_ARCH))"
	$(RUN) sh -c 'cd node_modules/@louislam/sqlite3 && ../../.bin/node-pre-gyp install --update-binary --target_platform=linux --target_arch=$(NODE_ARCH)'
	$(RUN) bash -c 'keep="napi-v6-linux-$(NODE_ARCH)"; for d in node_modules/@louislam/sqlite3/lib/binding/napi-v6-linux-*/; do [ "$$(basename $$d)" = "$$keep" ] || rm -rf "$$d"; done'
	@$(MSG) "Installing Uptime Kuma to staging directory"
	@install -d $(STAGING_INSTALL_PREFIX)/share/uptime-kuma
	@# Install server files
	@cp -a $(WORK_DIR)/$(PKG_DIR)/server $(STAGING_INSTALL_PREFIX)/share/uptime-kuma/server
	@# Install node_modules (production only)
	@cp -a $(WORK_DIR)/$(PKG_DIR)/node_modules $(STAGING_INSTALL_PREFIX)/share/uptime-kuma/node_modules
	@# Install package metadata
	@cp -a $(WORK_DIR)/$(PKG_DIR)/package.json $(STAGING_INSTALL_PREFIX)/share/uptime-kuma/package.json
	@# Install database directory structure
	@install -d $(STAGING_INSTALL_PREFIX)/share/uptime-kuma/db
	@if [ -d "$(WORK_DIR)/$(PKG_DIR)/db" ]; then \
		cp -a $(WORK_DIR)/$(PKG_DIR)/db/* $(STAGING_INSTALL_PREFIX)/share/uptime-kuma/db/ 2>/dev/null || true; \
	fi
	@# Copy extra directories needed at runtime
	@for dir in config extra src; do \
		if [ -d "$(WORK_DIR)/$(PKG_DIR)/$$dir" ]; then \
			cp -a "$(WORK_DIR)/$(PKG_DIR)/$$dir" $(STAGING_INSTALL_PREFIX)/share/uptime-kuma/$$dir; \
		fi; \
	done
	@# Generate PLIST
	@( cd $(STAGING_INSTALL_PREFIX) && \
		find share/uptime-kuma -type f -o -type l | sort ) \
		> $(WORK_DIR)/$(PKG_NAME).plist
	@printf 'rsc:share/uptime-kuma\n' > $(WORK_DIR)/PLIST
