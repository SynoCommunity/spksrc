PKG_NAME = seerr
PKG_VERS = 2.7.3
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/seerr-team/seerr/archive/refs/tags
PKG_DIST_FILE = seerr-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = seerr-$(PKG_VERS)

BUILD_DEPENDS = native/nodejs_22

HOMEPAGE = https://github.com/seerr-team/seerr
COMMENT  = Media request management with Jellyfin, Plex, and Emby integration.
LICENSE  = MIT

# Build environment
ENV += NPM_CONFIG_PREFIX=$(WORK_DIR)/npm-global
ENV += PATH=$(WORK_DIR)/npm-global/bin:$(WORK_DIR)/../../../native/nodejs_22/work-native/node/bin:$(PATH)
ENV += COREPACK_ENABLE_DOWNLOAD=1
ENV += HUSKY=0
ENV += HUSKY_SKIP_INSTALL=1
ENV += SKIP_GIT_INSTALL_HOOKS=1

INSTALL_TARGET = seerr_install

include ../../mk/spksrc.install-resources.mk

.PHONY: seerr_install
seerr_install:
	# Setup pnpm package manager
	install -m 755 -d $(WORK_DIR)/npm-global/bin
	$(RUN) npm install -g pnpm@9.0.0

	# Remove prepare script to skip husky git hooks
	$(RUN) node -e "const fs=require('fs');const p='package.json';const j=JSON.parse(fs.readFileSync(p));delete j.scripts?.prepare;fs.writeFileSync(p,JSON.stringify(j,null,2));"

	# Install dependencies and build
	$(RUN) pnpm install --frozen-lockfile --filter '.' --config.ignore-workspace-root-check=true
	$(RUN) node $(CURDIR)/src/fix-entity-imports.js
	$(RUN) COMMIT_TAG=$(PKG_VERS) pnpm build
	$(RUN) pnpm prune --prod --ignore-scripts

	# Download prebuilt native binaries (skipped by --ignore-scripts)
	# NOTE: Version-specific paths - update when upgrading sqlite3 or bcrypt
	$(RUN) sh -c 'cd node_modules/.pnpm/sqlite3@5.1.7/node_modules/sqlite3 && npx prebuild-install -r napi'
	$(RUN) sh -c 'cd node_modules/.pnpm/bcrypt@5.1.0_encoding@0.1.13/node_modules/bcrypt && mkdir -p lib/binding && curl -sL https://github.com/kelektiv/node.bcrypt.js/releases/download/v5.1.0/bcrypt_lib-v5.1.0-napi-v3-linux-x64-glibc.tar.gz | tar -xz -C lib/binding'

	# Remove unused platform-specific binaries (keep linux-x64-glibc only)
	$(RUN) rm -rf node_modules/.pnpm/@next+swc-*-darwin@* \
	              node_modules/.pnpm/@next+swc-*-win32@* \
	              node_modules/.pnpm/@next+swc-linux-*-musl@* \
	              node_modules/.pnpm/@swc+core-*-darwin@* \
	              node_modules/.pnpm/@swc+core-*-win32@* \
	              node_modules/.pnpm/@swc+core-linux-*-musl@* \
	              node_modules/.pnpm/@img+sharp-*musl*@* \
	              node_modules/.pnpm/jsc-android@* \
	              node_modules/.pnpm/@react-three@*

	# Remove React Native (unused optional dependency from react-spring)
	$(RUN) find node_modules/.pnpm -maxdepth 1 -type d \( -name 'react-native@*' -o -name '@react-native*' \) -exec rm -rf {} +

	# Remove build-time tooling and metadata
	$(RUN) rm -rf node_modules/.pnpm/.store \
	              node_modules/.pnpm/typescript@* \
	              node_modules/.pnpm/ts-node@* \
	              server .next/cache charts gen-docs docs pnpm-lock.yaml
	$(RUN) find node_modules -type f \( -name '*.d.ts' -o -name '*.d.mts' -o -name '*.d.cts' -o -name '*.map' -o -name '*.tsbuildinfo' \) -delete

	# Create version tag file
	$(RUN) node -e "require('fs').writeFileSync('committag.json', JSON.stringify({commitTag: '$(PKG_VERS)'}))"

	# Install to staging
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/share/seerr
	cp -a $(WORK_DIR)/$(PKG_DIR)/dist $(STAGING_INSTALL_PREFIX)/share/seerr/
	cp -a $(WORK_DIR)/$(PKG_DIR)/public $(STAGING_INSTALL_PREFIX)/share/seerr/
	cp -a $(WORK_DIR)/$(PKG_DIR)/config $(STAGING_INSTALL_PREFIX)/share/seerr/
	cp -a $(WORK_DIR)/$(PKG_DIR)/node_modules $(STAGING_INSTALL_PREFIX)/share/seerr/
	cp -a $(WORK_DIR)/$(PKG_DIR)/.next $(STAGING_INSTALL_PREFIX)/share/seerr/
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/share/seerr/pages
	cp $(WORK_DIR)/$(PKG_DIR)/next.config.js $(STAGING_INSTALL_PREFIX)/share/seerr/
	cp $(WORK_DIR)/$(PKG_DIR)/jellyseerr-api.yml $(STAGING_INSTALL_PREFIX)/share/seerr/
	cp $(WORK_DIR)/$(PKG_DIR)/committag.json $(STAGING_INSTALL_PREFIX)/share/seerr/
	cp $(WORK_DIR)/$(PKG_DIR)/package.json $(STAGING_INSTALL_PREFIX)/share/seerr/

	# Generate PLIST
	( cd $(STAGING_INSTALL_PREFIX) && find share/seerr -type f -o -type l | sort ) > $(WORK_DIR)/$(PKG_NAME).plist
	printf 'rsc:share/seerr\n' > $(WORK_DIR)/PLIST
