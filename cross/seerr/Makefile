PKG_NAME = seerr
PKG_VERS = 3.5.0
PKG_EXT  = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/seerr-team/seerr/archive/refs/tags
PKG_DIST_FILE = seerr-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = seerr-$(PKG_VERS)

BUILD_DEPENDS = native/nodejs_22

# Node.js optional dependencies are only installed for x64 and arm64
REQUIRE_64BIT = 1

HOMEPAGE = https://github.com/seerr-team/seerr
COMMENT  = Media request management with Jellyfin, Plex, and Emby integration.
LICENSE  = MIT

INSTALL_TARGET = seerr_install

# ------------------------------------------------------------
# Build environment
# ------------------------------------------------------------
ENV += PATH=$(WORK_DIR)/../../../native/nodejs_22/work-native/node/bin:$$PATH
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

	# Enable cross-arch optional dependency installation
	$(RUN) node -e "\
		const fs=require('fs');\
		const p='package.json';\
		const j=JSON.parse(fs.readFileSync(p));\
		j.pnpm = j.pnpm || {};\
		j.pnpm.supportedArchitectures = { os: ['linux'], cpu: ['x64', 'arm64'] };\
		fs.writeFileSync(p,JSON.stringify(j,null,2));"

	# ------------------------------------------------------------
	# 2. Install deps + build
	# ------------------------------------------------------------
	$(RUN) pnpm install --frozen-lockfile
	$(RUN) COMMIT_TAG=$(PKG_VERS) pnpm build

	# ------------------------------------------------------------
	# 3. Native binaries for target architecture ($(NODE_ARCH))
	# ------------------------------------------------------------
	# sqlite3 - download prebuilt napi binary
	$(RUN) sh -c 'cd node_modules/sqlite3 && npx prebuild-install -r napi --platform linux --arch $(NODE_ARCH)'

	# bcrypt bundles prebuilts in prebuilds/ dir
	# Keep only the target architecture prebuild (linux-x64 or linux-arm64)
	$(RUN) find node_modules/bcrypt/prebuilds -mindepth 1 -maxdepth 1 ! -name "linux-$(NODE_ARCH)" -exec rm -rf {} +
	$(RUN) rm -rf node_modules/bcrypt/lib

	# ------------------------------------------------------------
	# 4. Remove pnpm-only metadata
	# ------------------------------------------------------------
	$(RUN) node -e "\
		const fs=require('fs');\
		const j=JSON.parse(fs.readFileSync('package.json'));\
		delete j.pnpm;\
		delete j.packageManager;\
		delete j.overrides;\
		fs.writeFileSync('package.json', JSON.stringify(j,null,2));"

	# ------------------------------------------------------------
	# 5. Remove dev-only packages from .pnpm store
	# ------------------------------------------------------------
	$(RUN) rm -rf \
		node_modules/.pnpm/ace-builds@*/ \
		node_modules/.pnpm/typescript@*/ \
		node_modules/.pnpm/prettier@*/ \
		node_modules/.pnpm/eslint@*/ \
		node_modules/.pnpm/tailwindcss@*/ \
		node_modules/.pnpm/prettier-plugin*/ \
		node_modules/.pnpm/@typescript-eslint*/ \
		node_modules/.pnpm/@eslint*/ \
		node_modules/.pnpm/ts-node@*/ \
		node_modules/.pnpm/jest@*/ \
		node_modules/.pnpm/@jest*/ \
		node_modules/.pnpm/@testing-library*/ \
		node_modules/.pnpm/cypress@*/ \
		node_modules/.pnpm/playwright@*/ \
		node_modules/.pnpm/storybook@*/ \
		node_modules/.pnpm/@storybook*/ \
		node_modules/.pnpm/jsdom@*/ \
		node_modules/.pnpm/puppeteer@*/ \
		node_modules/.pnpm/nodemon@*/ \
		node_modules/.pnpm/supertest@*/ \
		node_modules/.pnpm/nock@*/ \
		node_modules/.pnpm/mocha@*/ \
		node_modules/.pnpm/webpack@*/ \
		node_modules/.pnpm/postcss@*/ \
		node_modules/.pnpm/autoprefixer@*/ \
		node_modules/.pnpm/svgo@*/ \
		node_modules/.pnpm/wasm-vips@*/ \
		node_modules/.pnpm/rollup@*/ \
		node_modules/.pnpm/vite@*/ \
		node_modules/.pnpm/stylelint@*/ \
		node_modules/.pnpm/@next+swc-linux-x64-musl@*/ \
		node_modules/.pnpm/@swc+core-linux-x64-musl@*/ \
		node_modules/.pnpm/@img+sharp-libvips-linuxmusl-x64@*/ \
		node_modules/.pnpm/@img+sharp-linuxmusl-x64@*/ \
		node_modules/.pnpm/@unicode+unicode-*@*/

	# Remove build-only @babel packages from .pnpm store
	# (keep only runtime packages needed by email-templates chain)
	$(RUN) node -e "\
		const fs = require('fs');\
		const path = require('path');\
		const pnpmDir = 'node_modules/.pnpm';\
		if (!fs.existsSync(pnpmDir)) process.exit(0);\
		const keep = ['runtime', 'parser', 'types', 'helper-validator-identifier', 'helper-string-parser'];\
		const dirs = fs.readdirSync(pnpmDir);\
		for (const d of dirs) {\
			const m = d.match(/^(@babel\+)(.+)@/);\
			if (m && keep.indexOf(m[2]) === -1) {\
				try { fs.rmSync(path.join(pnpmDir, d), { recursive: true, force: true }); } catch(e) {}\
			}\
		}"

	# Remove binaries for the wrong architecture.
	# Both variants are already in the .pnpm store (dual-arch install above)
	# and dependents link their own copy, so no install step is needed here.
	# NOTE: do not invoke pnpm past this point - without the packageManager pin
	# and supportedArchitectures it re-resolves with host defaults and restores
	# everything pruned above.
	$(RUN) bash -c 'if [ "$(NODE_ARCH)" = "arm64" ]; then \
		rm -rf node_modules/.pnpm/@next+swc-linux-x64*/ \
			node_modules/.pnpm/@swc+core-linux-x64*/ \
			node_modules/.pnpm/@img+sharp-linux-x64*/ \
			node_modules/.pnpm/@img+sharp-libvips-linux-x64*/ \
			node_modules/.pnpm/@unrs+resolver-binding-linux-x64*/; \
		for p in "@next+swc-linux-arm64-gnu@" "@swc+core-linux-arm64-gnu@" \
			"@img+sharp-linux-arm64@" "@img+sharp-libvips-linux-arm64@"; do \
			ls -d node_modules/.pnpm/$${p}* >/dev/null || \
				{ echo "missing $${p}* in .pnpm store - dual-arch install incomplete" >&2; exit 1; }; \
		done; \
	elif [ "$(NODE_ARCH)" = "x64" ]; then \
		rm -rf node_modules/.pnpm/@next+swc-linux-arm64*/ \
			node_modules/.pnpm/@swc+core-linux-arm64*/ \
			node_modules/.pnpm/@img+sharp-linux-arm64*/ \
			node_modules/.pnpm/@img+sharp-libvips-linux-arm64*/ \
			node_modules/.pnpm/@unrs+resolver-binding-linux-arm64*/; \
		for p in "@next+swc-linux-x64-gnu@" "@swc+core-linux-x64-gnu@" \
			"@img+sharp-linux-x64@" "@img+sharp-libvips-linux-x64@"; do \
			ls -d node_modules/.pnpm/$${p}* >/dev/null || \
				{ echo "missing $${p}* in .pnpm store - dual-arch install incomplete" >&2; exit 1; }; \
		done; \
	fi'

	# Remove dangling top-level symlinks (dev packages whose .pnpm entries were pruned)
	$(RUN) find node_modules -maxdepth 1 -type l ! -exec test -e {} \; -delete 2>/dev/null || true
	$(RUN) find node_modules/@* -maxdepth 1 -type l ! -exec test -e {} \; -delete 2>/dev/null || true

	# ------------------------------------------------------------
	# 6. Cleanup non-runtime artifacts
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
	$(RUN) rm -rf node_modules/node-gyp

	# Remove sqlite3 source tarball (prebuilt binary already downloaded)
	$(RUN) rm -rf node_modules/.pnpm/sqlite3@*/node_modules/sqlite3/deps

	# Remove musl native variants (DSM uses glibc on all architectures)
	$(RUN) bash -c 'rm -rf node_modules/.pnpm/*musl*@*/' 2>/dev/null || true

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
	# 7. Version tag
	# ------------------------------------------------------------
	$(RUN) node -e "\
		require('fs').writeFileSync(\
			'committag.json', \
			JSON.stringify({ commitTag: '$(PKG_VERS)' })\
		)"

	# ------------------------------------------------------------
	# 8. Install into staging (Seerr runtime layout)
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
	# 9. Generate PLIST
	# ------------------------------------------------------------
	( cd $(STAGING_INSTALL_PREFIX) && \
		find share/seerr -type f -o -type l | sort ) \
		> $(WORK_DIR)/$(PKG_NAME).plist

	printf 'rsc:share/seerr\n' > $(WORK_DIR)/PLIST
