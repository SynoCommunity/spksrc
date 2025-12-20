SPK_NAME = pelican_panel
SPK_VERS = 1.0.0
SPK_REV = 12
SPK_ICON = src/PACKAGE_ICON.PNG
DSM_UI_DIR = app

# No cross-compilation needed - Docker-based package
DEPENDS =

# Require DSM 7.0+ for Container Manager
REQUIRED_MIN_DSM = 7.0
# Container Manager (Docker) is required
SPK_DEPENDS = "ContainerManager"

# Only x86_64 supported (Docker images)
UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7_ARCHS) $(ARMv7L_ARCHS) $(i686_ARCHS)

MAINTAINER = SynoCommunity
MAINTAINER_URL = https://github.com/SynoCommunity
DESCRIPTION = Pelican Panel is a free, open-source game server management panel built with PHP, React, and Go. It includes Wings daemon for server management.
DESCRIPTION_FRE = Pelican Panel est un panneau de gestion de serveurs de jeux gratuit et open-source construit avec PHP, React et Go. Il inclut le daemon Wings pour la gestion des serveurs.
DISPLAY_NAME = Pelican Panel
CHANGELOG = "1. Initial release with Panel and Wings support."

HOMEPAGE = https://pelican.dev
LICENSE = MIT

# Service configuration
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SSS_SCRIPT = src/dsm-control.sh
STARTABLE = yes

# Wizard for installation
WIZARDS_DIR = src/wizard/

# Ports (SERVICE_PORT for firewall, no ADMIN_PORT - handled by .url in config)
SERVICE_PORT = 8080
SERVICE_PORT_TITLE = Pelican Panel (HTTP)

# Additional ports for Wings
SERVICE_PORT_01 = 8445
SERVICE_PORT_TITLE_01 = Wings API (HTTPS)
SERVICE_PORT_02 = 2022
SERVICE_PORT_TITLE_02 = Wings SFTP

# Configuration directory
CONF_DIR = src/conf/

# DSM UI integration
DSM_UI_CONFIG = src/app/config

# Override copy target since we have no cross dependencies
COPY_TARGET = pelican_copy_target

# Post-strip target for installing files
POST_STRIP_TARGET = pelican_extra_install

# noarch since we just deploy Docker config files
override ARCH = noarch

include ../../mk/spksrc.spk.mk

# ===========================================
# Auto-increment version management
# ===========================================
# Usage:
#   make bump         - Increment SPK_REV and build
#   make bump-only    - Just increment SPK_REV without building

.PHONY: bump bump-only

bump-only:
	@./scripts/bump-revision.sh

bump: bump-only
	@$(MAKE) noarch-7.0

# Custom copy target - create empty staging directory
.PHONY: pelican_copy_target
pelican_copy_target:
	@$(MSG) "Creating staging directory for pelican_panel"
	@mkdir -p $(STAGING_DIR)

.PHONY: pelican_extra_install
pelican_extra_install:
	@$(MSG) "Installing Pelican Panel files"
	# Create bin directory for executables
	install -m 755 -d $(STAGING_DIR)/bin
	install -m 755 src/bin/loading-proxy.py $(STAGING_DIR)/bin/
	install -m 755 src/wings-config-watcher.sh $(STAGING_DIR)/bin/
	# Create share directory for config templates
	install -m 755 -d $(STAGING_DIR)/share
	install -m 755 -d $(STAGING_DIR)/share/docker
	install -m 755 -d $(STAGING_DIR)/share/patches
	# Install Docker compose file
	install -m 644 src/docker/compose.yaml $(STAGING_DIR)/share/docker/
	# Install environment template
	install -m 644 src/panel.env.example $(STAGING_DIR)/share/
	# Install Wings config template
	install -m 644 src/wings.config.example.yml $(STAGING_DIR)/share/
	# Install patches for Panel
	install -m 644 src/patches/*.php $(STAGING_DIR)/share/patches/ 2>/dev/null || true
	# Install loading page
	install -m 644 src/loading.html $(STAGING_DIR)/share/
	# Create app directory for DSM UI
	install -m 755 -d $(STAGING_DIR)/app
	install -m 755 -d $(STAGING_DIR)/app/images
	install -m 644 src/app/config $(STAGING_DIR)/app/
	install -m 644 src/app/*.html $(STAGING_DIR)/app/ 2>/dev/null || true
	install -m 644 src/app/*.js $(STAGING_DIR)/app/ 2>/dev/null || true
	install -m 755 src/app/*.cgi $(STAGING_DIR)/app/ 2>/dev/null || true
	install -m 644 src/app/*.sc $(STAGING_DIR)/app/ 2>/dev/null || true
	install -m 644 src/app/images/*.png $(STAGING_DIR)/app/images/ 2>/dev/null || true
