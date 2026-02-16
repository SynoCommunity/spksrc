PKG_NAME = seerr
PKG_VERS = 3.0.1
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
ENV += PATH=$(WORK_DIR)/../../../native/nodejs_22/work-native/node/bin:$(PATH)
ENV += COREPACK_ENABLE_AUTO_PIN=0
ENV += COREPACK_ENABLE_DOWNLOAD_PROMPT=0
ENV += HUSKY=0
ENV += HUSKY_SKIP_INSTALL=1
ENV += SKIP_GIT_INSTALL_HOOKS=1

include ../../mk/spksrc.install-resources.mk

# Map spksrc ARCH to Node.js arch for native module downloads
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
NODE_ARCH = arm64
else
NODE_ARCH = x64
endif

.PHONY: seerr_install
seerr_install:

	# ------------------------------------------------------------
	# 1. Setup pnpm via corepack (bundled with Node.js 22)
	# ------------------------------------------------------------
	$(RUN) corepack enable

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
	$(RUN) pnpm install --frozen-lockfile
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
	$(RUN) npm install --omit=dev --ignore-scripts --legacy-peer-deps --no-audit --no-fund --no-optional

	# ------------------------------------------------------------
	# 6. Native binaries for target architecture ($(NODE_ARCH))
	# ------------------------------------------------------------

	# sqlite3 - download prebuilt napi binary for target arch
	$(RUN) sh -c "\
		cd node_modules/sqlite3 && \
		npx prebuild-install -r napi --platform linux --arch $(NODE_ARCH)"

	# bcrypt v6.0.0 bundles prebuilts in prebuilds/ dir
	# Keep only the target architecture prebuild
	$(RUN) rm -rf \
		node_modules/bcrypt/prebuilds/darwin-arm64 \
		node_modules/bcrypt/prebuilds/darwin-x64 \
		node_modules/bcrypt/prebuilds/linux-arm \
		node_modules/bcrypt/prebuilds/win32-arm64 \
		node_modules/bcrypt/prebuilds/win32-x64 \
		node_modules/bcrypt/lib
	@if [ "$(NODE_ARCH)" = "x64" ]; then \
		$(RUN) rm -rf node_modules/bcrypt/prebuilds/linux-arm64; \
	else \
		$(RUN) rm -rf node_modules/bcrypt/prebuilds/linux-x64; \
	fi

	# ------------------------------------------------------------
	# 7. Cleanup non-runtime artifacts
	# ------------------------------------------------------------
	$(RUN) rm -rf \
		.next/cache \
		.next/trace \
		.next/*.nft.json \
		charts \
		docs \
		gen-docs \
		server

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

	# Remove source files, build artifacts, documentation, and license files
	$(RUN) find node_modules -type f \( \
		-name '*.ts' -o -name '*.map' -o -name '*.tsbuildinfo' -o \
		-name '*.c' -o -name '*.cpp' -o -name '*.cc' -o \
		-name '*.h' -o -name '*.hpp' -o \
		-name '*.gyp' -o -name '*.gypi' -o \
		-name 'README*' -o -name 'CHANGELOG*' -o -name 'HISTORY*' -o \
		-name 'AUTHORS*' -o -name 'CONTRIBUTORS*' -o \
		-name 'LICENSE*' -o -name 'COPYING*' \) -delete

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
	# 9. Install into staging (Seerr runtime layout)
	# ------------------------------------------------------------
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/share/seerr

	cp -a $(WORK_DIR)/$(PKG_DIR)/dist            $(STAGING_INSTALL_PREFIX)/share/seerr/
	cp -a $(WORK_DIR)/$(PKG_DIR)/.next           $(STAGING_INSTALL_PREFIX)/share/seerr/
	cp -a $(WORK_DIR)/$(PKG_DIR)/public          $(STAGING_INSTALL_PREFIX)/share/seerr/
	cp -a $(WORK_DIR)/$(PKG_DIR)/config          $(STAGING_INSTALL_PREFIX)/share/seerr/
	cp -a $(WORK_DIR)/$(PKG_DIR)/node_modules    $(STAGING_INSTALL_PREFIX)/share/seerr/

	cp $(WORK_DIR)/$(PKG_DIR)/package.json       $(STAGING_INSTALL_PREFIX)/share/seerr/
	cp $(WORK_DIR)/$(PKG_DIR)/seerr-api.yml      $(STAGING_INSTALL_PREFIX)/share/seerr/
	cp $(WORK_DIR)/$(PKG_DIR)/committag.json     $(STAGING_INSTALL_PREFIX)/share/seerr/

	# ------------------------------------------------------------
	# 10. Generate PLIST
	# ------------------------------------------------------------
	( cd $(STAGING_INSTALL_PREFIX) && \
		find share/seerr -type f -o -type l | sort ) \
		> $(WORK_DIR)/$(PKG_NAME).plist

	printf 'rsc:share/seerr\n' > $(WORK_DIR)/PLIST
