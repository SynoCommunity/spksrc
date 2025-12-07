# PHP 8.4.15 SPK Package for Synology NAS
# spksrc-compliant Makefile

SPK_NAME = php84
SPK_VERS = 8.4.15
SPK_REV = 1
SPK_ICON = src/php84.png

# Cross-compilation dependency
DEPENDS = cross/php84

# Exclude non-x86_64 architectures
UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARM_ARCHS) $(ARMv7_ARCHS) $(ARMv7L_ARCHS) $(ARMv8_ARCHS) $(i686_ARCHS)

# DSM 7.2+ required
REQUIRED_MIN_DSM = 7.2

# Package metadata
MAINTAINER = SynoCommunity
DESCRIPTION = PHP 8.4.15 Hypertext Preprocessor with Extension Manager. Includes 163 extensions organized by theme with a graphical management interface.
DESCRIPTION_FRE = PHP 8.4.15 avec gestionnaire d extensions. Inclut 163 extensions organisees par theme avec une interface de gestion graphique.
DISPLAY_NAME = PHP 8.4
CHANGELOG = Initial spksrc release with Extension Manager
HOMEPAGE = https://www.php.net
LICENSE = PHP-3.01

# Service configuration - PHP-FPM daemon
STARTABLE = yes
SERVICE_SETUP = src/service-setup.sh
SERVICE_USER = auto
SERVICE_PORT = 9000
SERVICE_PORT_TITLE = PHP-FPM

# Commands to link in /usr/local/bin
SPK_COMMANDS = bin/php bin/phpize bin/php-config bin/pear bin/pecl sbin/php-fpm

# DSM UI integration - ExtJS application (not URL shortcut)
DSM_UI_DIR = app
DSM_UI_CONFIG = src/app/config
DSM_APP_NAME = SYNO.SDS.PHP84Manager.Application

# Wizard for installation
WIZARDS_DIR = src/wizard7/

# Additional configuration files
CONF_DIR = src/conf/

# Post-strip target to install Extension Manager UI
POST_STRIP_TARGET = php84_install_ui

include ../../mk/spksrc.common.mk
include ../../mk/spksrc.spk.mk

.PHONY: php84_install_ui
php84_install_ui:
	@$(MSG) "Installing Extension Manager UI"
	install -m 755 -d $(STAGING_DIR)/app
	install -m 755 -d $(STAGING_DIR)/app/images
	install -m 755 -d $(STAGING_DIR)/app/cgi
	install -m 644 src/app/config $(STAGING_DIR)/app/
	install -m 644 src/app/PHP84Manager.js $(STAGING_DIR)/app/
	install -m 644 src/app/style.css $(STAGING_DIR)/app/
	cp -a src/app/images/* $(STAGING_DIR)/app/images/
	install -m 755 src/app/index.cgi $(STAGING_DIR)/app/
	install -m 755 src/app/cgi/*.cgi $(STAGING_DIR)/app/cgi/
