PKG_NAME = actual-budget
PKG_VERS = 26.10.0
PKG_EXT = tgz
PKG_DIST_NAME = sync-server-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://registry.npmjs.org/@actual-app/sync-server/-
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = package

BUILD_DEPENDS = native/nodejs_22

HOMEPAGE = https://actualbudget.org
COMMENT  = Local-first personal finance, budgeting and expense tracking sync server.
LICENSE  = MIT

INSTALL_TARGET = actual_budget_install

ENV += PATH=$(WORK_DIR)/../../../native/nodejs_22/work-native/node/bin:$$PATH

include ../../mk/spksrc.cross-install.mk

# Map spksrc ARCH to Node.js arch for native prebuild pruning
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
NODE_ARCH = arm64
else
NODE_ARCH = x64
endif

.PHONY: actual_budget_install
actual_budget_install:
	$(RUN) npm install --omit dev --no-audit --no-fund
	# keep only the target-arch glibc prebuilds (DSM has no musl, no 32-bit)
	$(RUN) find node_modules/argon2/prebuilds node_modules/bcrypt/prebuilds -maxdepth 1 -mindepth 1 ! -name 'linux-$(NODE_ARCH)' -exec rm -rf {} +
	$(RUN) find node_modules/argon2/prebuilds node_modules/bcrypt/prebuilds -name '*.musl.node' -delete
	$(RUN) find node_modules/better-sqlite3/prebuilds -maxdepth 1 -mindepth 1 -type f ! -name 'linux-$(NODE_ARCH).node' -delete
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)
	@tar -cf - -C $(WORK_DIR)/$(PKG_DIR) build node_modules package.json | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)
