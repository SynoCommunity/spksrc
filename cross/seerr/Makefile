PKG_NAME = seerr
PKG_VERS = 2.7.3
PKG_EXT  = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/seerr-team/seerr/archive/refs/tags
PKG_DIST_FILE = seerr-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = seerr-$(PKG_VERS)

BUILD_DEPENDS = native/nodejs_22

HOMEPAGE = https://github.com/seerr-team/seerr
COMMENT  = Media request management with Jellyfin, Plex, and Emby integration.
LICENSE  = MIT

INSTALL_TARGET = seerr_install

# ------------------------------------------------------------
# Build environment
# ------------------------------------------------------------
ENV += NPM_CONFIG_PREFIX=$(WORK_DIR)/npm-global
ENV += PATH=$(WORK_DIR)/npm-global/bin:$(WORK_DIR)/../../../native/nodejs_22/work-native/node/bin:$(PATH)
ENV += COREPACK_ENABLE_DOWNLOAD=1
ENV += HUSKY=0
ENV += HUSKY_SKIP_INSTALL=1
ENV += SKIP_GIT_INSTALL_HOOKS=1

include ../../mk/spksrc.install-resources.mk

.PHONY: seerr_install
seerr_install:

	# ------------------------------------------------------------
	# 1. Install pnpm (REQUIRED for build)
	# ------------------------------------------------------------
	install -m 755 -d $(WORK_DIR)/npm-global/bin
	$(RUN) npm install -g pnpm@9.0.0

	# Disable husky prepare script
	$(RUN) node -e "\
		const fs=require('fs');\
		const p='package.json';\
		const j=JSON.parse(fs.readFileSync(p));\
		delete j.scripts?.prepare;\
		fs.writeFileSync(p,JSON.stringify(j,null,2));"

	# ------------------------------------------------------------
	# 2. Install deps + build (pnpm-only phase)
	# ------------------------------------------------------------
	$(RUN) pnpm install --frozen-lockfile --filter '.' --config.ignore-workspace-root-check=true
	$(RUN) node $(CURDIR)/src/fix-entity-imports.js
	$(RUN) COMMIT_TAG=$(PKG_VERS) pnpm build

	# ------------------------------------------------------------
	# 3. Remove build-time node_modules completely
	# ------------------------------------------------------------
	$(RUN) rm -rf node_modules

	# ------------------------------------------------------------
	# 4. Remove pnpm-only metadata (npm cannot parse it)
	# ------------------------------------------------------------
	$(RUN) node -e "\
		const fs=require('fs');\
		const j=JSON.parse(fs.readFileSync('package.json'));\
		delete j.pnpm;\
		delete j.packageManager;\
		delete j.overrides;\
		fs.writeFileSync('package.json', JSON.stringify(j,null,2));"

	# ------------------------------------------------------------
	# 5. Install runtime deps only (npm, flat layout)
	# ------------------------------------------------------------
	$(RUN) npm install --omit=dev --ignore-scripts --legacy-peer-deps --no-audit --no-fund

	# ------------------------------------------------------------
	# 6. Restore native binaries (runtime-safe)
	# ------------------------------------------------------------

	# sqlite3
	$(RUN) sh -c "\
		cd node_modules/sqlite3 && \
		npx prebuild-install -r napi"

	# bcrypt (prebuilt glibc x64)
	$(RUN) sh -c "\
		cd node_modules/bcrypt && \
		mkdir -p lib/binding && \
		curl -sL https://github.com/kelektiv/node.bcrypt.js/releases/download/v5.1.0/bcrypt_lib-v5.1.0-napi-v3-linux-x64-glibc.tar.gz | \
		tar -xz -C lib/binding"

	# ------------------------------------------------------------
	# 7. Remove non-runtime artifacts
	# ------------------------------------------------------------
	$(RUN) rm -rf \
		.next/cache \
		.next/trace \
		.next/*.nft.json \
		charts \
		docs \
		gen-docs \
		server \
		pnpm-lock.yaml

	# Remove ace-builds entirely (already bundled into client JS)
	$(RUN) rm -rf node_modules/ace-builds

	# Remove node-gyp build tools (not needed at runtime)
	$(RUN) rm -rf \
		node_modules/node-gyp \
		node_modules/sqlite3/node_modules/node-gyp

	# Remove @babel packages except runtime (compiler/plugins are build-only)
	$(RUN) find node_modules/@babel -mindepth 1 -maxdepth 1 -type d ! -name 'runtime' -exec rm -rf {} +

	# Remove @svgr and svgo (webpack SVG loader - build-only)
	$(RUN) rm -rf \
		node_modules/@svgr \
		node_modules/svgo

	# Remove babel-plugin-* packages (build-only transpilation plugins)
	$(RUN) rm -rf \
		node_modules/babel-plugin-emotion \
		node_modules/babel-plugin-macros \
		node_modules/babel-plugin-polyfill-corejs2 \
		node_modules/babel-plugin-polyfill-corejs3 \
		node_modules/babel-plugin-polyfill-regenerator \
		node_modules/babel-plugin-syntax-jsx

	# Remove source files, build artifacts, and documentation
	$(RUN) find node_modules -type f \( \
		-name '*.ts' -o -name '*.map' -o -name '*.tsbuildinfo' -o \
		-name '*.c' -o -name '*.cpp' -o -name '*.cc' -o \
		-name '*.h' -o -name '*.hpp' -o \
		-name '*.gyp' -o -name '*.gypi' -o \
		-name 'README*' -o -name 'CHANGELOG*' -o -name 'HISTORY*' -o \
		-name 'AUTHORS*' -o -name 'CONTRIBUTORS*' \) -delete

	# Remove test and example directories
	$(RUN) find node_modules -type d \( \
		-name '__tests__' -o -name 'test' -o -name 'tests' -o \
		-name 'example' -o -name 'examples' \) -exec rm -rf {} + 2>/dev/null || true

	# ------------------------------------------------------------
	# 8. Version tag
	# ------------------------------------------------------------
	$(RUN) node -e "\
		require('fs').writeFileSync(\
			'committag.json', \
			JSON.stringify({ commitTag: '$(PKG_VERS)' })\
		)"

	# ------------------------------------------------------------
	# 9. Install into staging (Jellyseerr runtime layout)
	# ------------------------------------------------------------
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/share/seerr

	cp -a $(WORK_DIR)/$(PKG_DIR)/dist            $(STAGING_INSTALL_PREFIX)/share/seerr/
	cp -a $(WORK_DIR)/$(PKG_DIR)/.next           $(STAGING_INSTALL_PREFIX)/share/seerr/
	cp -a $(WORK_DIR)/$(PKG_DIR)/public          $(STAGING_INSTALL_PREFIX)/share/seerr/
	cp -a $(WORK_DIR)/$(PKG_DIR)/config          $(STAGING_INSTALL_PREFIX)/share/seerr/
	cp -a $(WORK_DIR)/$(PKG_DIR)/node_modules    $(STAGING_INSTALL_PREFIX)/share/seerr/

	cp $(WORK_DIR)/$(PKG_DIR)/package.json       $(STAGING_INSTALL_PREFIX)/share/seerr/
	cp $(WORK_DIR)/$(PKG_DIR)/jellyseerr-api.yml $(STAGING_INSTALL_PREFIX)/share/seerr/
	cp $(WORK_DIR)/$(PKG_DIR)/committag.json     $(STAGING_INSTALL_PREFIX)/share/seerr/

	# ------------------------------------------------------------
	# 10. Generate PLIST
	# ------------------------------------------------------------
	( cd $(STAGING_INSTALL_PREFIX) && \
		find share/seerr -type f -o -type l | sort ) \
		> $(WORK_DIR)/$(PKG_NAME).plist

	printf 'rsc:share/seerr\n' > $(WORK_DIR)/PLIST
