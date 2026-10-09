PKG_NAME = actual-budget
PKG_VERS = 26.10.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/actualbudget/actual/archive/refs/tags
PKG_DIST_FILE = actual-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = actual-$(PKG_VERS)

BUILD_DEPENDS = native/nodejs_22

# better-sqlite3 ships prebuilds for 64-bit Linux only
REQUIRE_64BIT = 1

HOMEPAGE = https://actualbudget.org
COMMENT  = Local-first personal finance, budgeting and expense tracking sync server.
LICENSE  = MIT

INSTALL_TARGET = actual_budget_install

ENV += PATH=$(WORK_DIR)/../../../native/nodejs_22/work-native/node/bin:$$PATH
ENV += COREPACK_ENABLE_DOWNLOAD_PROMPT=0
# .yarnrc.yml refuses packages published less than 3 days ago; a fresh release
# can be newer than that, so disable the gate for the pinned lockfile.
ENV += YARN_NPM_MINIMAL_AGE_GATE=0

include ../../mk/spksrc.cross-install.mk

# Map spksrc ARCH to Node.js arch for native prebuild pruning
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
NODE_ARCH = arm64
else
NODE_ARCH = x64
endif

SITE_DIR = $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)

.PHONY: actual_budget_install
actual_budget_install:
	# The lage build orchestrator requires git metadata, absent from the archive
	$(RUN) git init -q && git add -A && \
		git -c user.email=spksrc@synocommunity.com -c user.name=spksrc commit -qm spksrc || true
	$(RUN) yarn install --immutable
	# Build the web frontend (clones the upstream translations repo) and the server
	$(RUN) yarn build:server
	$(RUN) yarn workspaces focus --production @actual-app/sync-server
	# keep only the target-arch glibc prebuilds (DSM has no musl, no 32-bit)
	$(RUN) find node_modules/argon2/prebuilds node_modules/bcrypt/prebuilds -maxdepth 1 -mindepth 1 ! -name 'linux-$(NODE_ARCH)' -exec rm -rf {} +
	$(RUN) find node_modules/argon2/prebuilds node_modules/bcrypt/prebuilds -name '*.musl.node' -delete
	$(RUN) find node_modules/better-sqlite3/prebuilds -maxdepth 1 -mindepth 1 -type f ! -name 'linux-$(NODE_ARCH).node' -delete
	# drop build-only tooling (the native modules ship prebuilt binaries)
	$(RUN) rm -rf node_modules/node-gyp node_modules/@npmcli node_modules/cacache \
		node_modules/make-fetch-happen node_modules/minipass node_modules/minipass-* \
		node_modules/glob node_modules/@isaacs node_modules/tar
	# stage the runtime tree
	@install -m 755 -d $(SITE_DIR)
	@cp -a $(WORK_DIR)/$(PKG_DIR)/packages/sync-server/build $(SITE_DIR)/build
	@cp -a $(WORK_DIR)/$(PKG_DIR)/node_modules $(SITE_DIR)/node_modules
	@cp $(WORK_DIR)/$(PKG_DIR)/packages/sync-server/package.json $(SITE_DIR)/package.json
	# replace workspace symlinks with their built contents (published-style pruning)
	@rm -f $(SITE_DIR)/node_modules/@actual-app/web $(SITE_DIR)/node_modules/@actual-app/crdt $(SITE_DIR)/node_modules/@actual-app/sync-server
	@install -m 755 -d $(SITE_DIR)/node_modules/@actual-app/web $(SITE_DIR)/node_modules/@actual-app/crdt
	@cp -a $(WORK_DIR)/$(PKG_DIR)/packages/desktop-client/build $(SITE_DIR)/node_modules/@actual-app/web/
	@cp $(WORK_DIR)/$(PKG_DIR)/packages/desktop-client/package.json $(SITE_DIR)/node_modules/@actual-app/web/
	@cp -a $(WORK_DIR)/$(PKG_DIR)/packages/crdt/dist $(SITE_DIR)/node_modules/@actual-app/crdt/
	@cp $(WORK_DIR)/$(PKG_DIR)/packages/crdt/package.json $(SITE_DIR)/node_modules/@actual-app/crdt/
	# remove bin symlinks left dangling by the tooling prune
	@find $(SITE_DIR)/node_modules/.bin -type l -xtype l -delete 2>/dev/null || true
