PKG_NAME = uptime-kuma
PKG_VERS = 2.1.0
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

# Build environment — use native Node.js from spksrc
ENV += PATH=$(WORK_DIR)/../../../native/nodejs_22/work-native/node/bin:$(PATH)

# Uptime Kuma pre-built frontend dist URL
DIST_URL = https://github.com/louislam/uptime-kuma/releases/download/$(PKG_VERS)/dist.tar.gz

include ../../mk/spksrc.install-resources.mk

.PHONY: uptime_kuma_install
uptime_kuma_install:
	@$(MSG) "Installing production dependencies for Uptime Kuma"
	cd $(WORK_DIR)/$(PKG_DIR) && \
		env HOME=$(WORK_DIR) \
		npm ci --omit dev --no-audit --no-fund
	@$(MSG) "Downloading pre-built frontend dist"
	cd $(WORK_DIR)/$(PKG_DIR) && \
		curl -sL "$(DIST_URL)" | tar xzf -
	@$(MSG) "Installing Uptime Kuma to staging directory"
	@install -d $(STAGING_INSTALL_PREFIX)/share/uptime-kuma
	@# Install server files
	@cp -a $(WORK_DIR)/$(PKG_DIR)/server $(STAGING_INSTALL_PREFIX)/share/uptime-kuma/server
	@# Install pre-built frontend dist
	@cp -a $(WORK_DIR)/$(PKG_DIR)/dist $(STAGING_INSTALL_PREFIX)/share/uptime-kuma/dist
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
