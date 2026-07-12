PKG_NAME = immich
PKG_VERS = 3.0.2
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/immich-app/immich/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = native/nodejs_22 native/pnpm

HOMEPAGE = https://immich.app
COMMENT  = Self-hosted photo and video backup solution.
LICENSE  = GPLv3

INSTALL_TARGET = immich_install
POST_INSTALL_TARGET = immich_post_install
ENV += PATH=$(WORK_DIR)/../../../native/nodejs_22/work-native/node/bin:$(WORK_DIR)/../../../native/pnpm/work-native/bin:$$PATH
ENV += COREPACK_ENABLE_AUTO_PIN=0
ENV += COREPACK_ENABLE_DOWNLOAD_PROMPT=0
ENV += HUSKY=0
ENV += HUSKY_SKIP_INSTALL=1
ENV += SKIP_GIT_INSTALL_HOOKS=1

include ../../mk/spksrc.cross-install.mk

# Map spksrc ARCH to Node.js arch for native module downloads
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
NODE_ARCH = arm64
else
NODE_ARCH = x64
endif

.PHONY: immich_install
immich_install:

	# ------------------------------------------------------------
	# 1. Disable prepare scripts, save ML subproject
	# ------------------------------------------------------------
	$(RUN) cp -a machine-learning machine-learning-src
	$(RUN) rm -rf machine-learning

	# ------------------------------------------------------------
	# 2. Install all deps (needed for building)
	# ------------------------------------------------------------
	$(RUN) pnpm install --frozen-lockfile

	# ------------------------------------------------------------
	# 3. Build (order: sdk -> plugin-sdk -> cli -> server -> web)
	# ------------------------------------------------------------
	$(RUN) pnpm --filter @immich/sdk run build
	$(RUN) pnpm --filter @immich/plugin-sdk run build
	$(RUN) pnpm --filter @immich/cli run build
	$(RUN) pnpm --filter immich run build
	$(RUN) pnpm --filter immich-web run build

	# ------------------------------------------------------------
	# 4. Deploy production-only copy using pnpm deploy
	# ------------------------------------------------------------
	$(RUN) rm -rf immich-deploy
	$(RUN) pnpm --filter immich deploy immich-deploy --frozen-lockfile

	# ------------------------------------------------------------
	# 5. Add web build to deploy dir
	# ------------------------------------------------------------
	$(RUN) cp -a web/build immich-deploy/web
	$(RUN) cp package.json immich-deploy/
	# Remove "type": "module" from deployed package.json (server dist is CommonJS)
	$(RUN) sed -i '/"type": "module"/d' immich-deploy/package.json



	# ------------------------------------------------------------
	# 6. Remove non-runtime files from deploy
	# ------------------------------------------------------------
	# Remove dev-only packages shipped by pnpm deploy (immich monorepo
	# doesn't properly separate devDependencies)
	$(RUN) bash -c 'for pkg in \
		typescript eslint @eslint @typescript-eslint vitest jsdom \
		@swc @esbuild @rolldown; do \
		case $$pkg in \
			@*) dir="$${pkg#@}"; dir="$${dir%/*}/+$${dir#*/}"; \
				rm -rf immich-deploy/node_modules/$$pkg \
					immich-deploy/node_modules/.pnpm/$${dir}@* \
					immich-deploy/node_modules/.pnpm/*@*/node_modules/$$pkg 2>/dev/null ;; \
			*)  rm -rf immich-deploy/node_modules/$$pkg \
					immich-deploy/node_modules/.pnpm/$${pkg}@* \
					immich-deploy/node_modules/.pnpm/*@*/node_modules/$${pkg} 2>/dev/null ;; \
		esac; \
	done; \
	find immich-deploy/node_modules -type d \( -name __tests__ -o -name test -o -name tests -o -name example -o -name examples \) -exec rm -rf {} + 2>/dev/null || true'
	# Remove source maps, TypeScript sources, C sources, docs
	$(RUN) find immich-deploy/node_modules -type f \( \
		-name '*.ts' -o -name '*.map' -o -name '*.tsbuildinfo' -o \
		-name '*.c' -o -name '*.cpp' -o -name '*.cc' -o \
		-name '*.h' -o -name '*.hpp' -o \
		-name '*.gyp' -o -name '*.gypi' -o \
		-name 'README*' -o -name 'CHANGELOG*' -o -name 'HISTORY*' -o \
		-name 'AUTHORS*' -o -name 'CONTRIBUTORS*' -o \
		-name 'LICENSE*' -o -name 'COPYING*' \) -delete 2>/dev/null || true

	# Keep only target-arch native binaries
	$(RUN) bash -c 'if [ "$(NODE_ARCH)" = "x64" ]; then \
		find immich-deploy/node_modules -name "*.node" -path "*/linux/arm64/*" -delete 2>/dev/null; \
		find immich-deploy/node_modules -name "*.node" -path "*/linux-arm64*" -delete 2>/dev/null; \
	else \
		find immich-deploy/node_modules -name "*.node" -path "*/linux/x64/*" -delete 2>/dev/null; \
		find immich-deploy/node_modules -name "*.node" -path "*/linux-x64*" -delete 2>/dev/null; \
	fi' || true

	# Remove musl variants
	$(RUN) find immich-deploy/node_modules -type d -name "*musl*" -exec rm -rf {} + 2>/dev/null || true

	# ------------------------------------------------------------
	# 6b. Patch hardcoded PostgreSQL binary paths
	# ------------------------------------------------------------
	# Immich assumes Linux paths like /usr/lib/postgresql/*/bin/pg_dump
	# DSM has these at /usr/local/bin/ via SPK_COMMANDS symlinks
	$(RUN) sed -i 's|/usr/lib/postgresql/[^/]*/bin/|/usr/local/bin/|g' \
		immich-deploy/dist/services/database-backup.service.js 2>/dev/null || true

	# ------------------------------------------------------------
	# 7. Install to staging
	# ------------------------------------------------------------
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/share/immich
	cp -a $(WORK_DIR)/$(PKG_DIR)/immich-deploy/* $(STAGING_INSTALL_PREFIX)/share/immich/
	# Server expects web files at $IMMICH_BUILD_DATA/www/
	@if [ -d $(STAGING_INSTALL_PREFIX)/share/immich/web ]; then \
		mv $(STAGING_INSTALL_PREFIX)/share/immich/web $(STAGING_INSTALL_PREFIX)/share/immich/www; \
	fi
	# Create build-lock.json so server doesn't warn at startup
	printf '{"build":"%s"}\n' "$$(date -u +%Y%m%dT%H%M%S)" > $(STAGING_INSTALL_PREFIX)/share/immich/build-lock.json
	# Install ML Python source (bundled with the main app, used by optional ML worker)
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/share/immich/immich-ml
	cp -a $(WORK_DIR)/$(PKG_DIR)/machine-learning-src/immich_ml $(STAGING_INSTALL_PREFIX)/share/immich/immich-ml/

	# ------------------------------------------------------------
	# 8. Generate PLIST
	# ------------------------------------------------------------
	( cd $(STAGING_INSTALL_PREFIX) && \
		find share/immich -type f -o -type l | sort ) \
		> $(WORK_DIR)/$(PKG_NAME).plist

	printf 'rsc:share/immich\n' > $(WORK_DIR)/PLIST

.PHONY: immich_post_install
immich_post_install:
	@$(MSG) "Removing dev-only packages from node_modules"
	bash -c 'for pkg in typescript eslint @typescript-eslint @swc @esbuild @rolldown vitest jsdom; do \
		case $$pkg in @*) d=".pnpm/$${pkg#@}"; d="$${d/\//+}@*"; rm -rf $(STAGING_INSTALL_PREFIX)/share/immich/node_modules/$${pkg} $(STAGING_INSTALL_PREFIX)/share/immich/node_modules/$${d} 2>/dev/null ;; \
		*) rm -rf $(STAGING_INSTALL_PREFIX)/share/immich/node_modules/$${pkg} $(STAGING_INSTALL_PREFIX)/share/immich/node_modules/.pnpm/$${pkg}@* 2>/dev/null ;; \
		esac; \
	done'
