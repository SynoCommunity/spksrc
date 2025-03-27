PKG_NAME = python_matter_server
PKG_VERS = 7.0.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/p/python_matter_server
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# Custom build of the pure python wheel "python_matter_server"
# we want to reference a custom version of home-assistant-chip-core, that
# provides custom (configurable) configuration directory
ifeq ($(HOMEASSISTANT_CHIP_CORE_VERSION),)
$(error HOMEASSISTANT_CHIP_CORE_VERSION is not defined)
endif

# replace the original version with the custom version (must be compatible with original)
HOMEASSISTANT_CHIP_CORE_ORIGINAL_VERSION = 2024.11.4

HOMEPAGE = https://github.com/home-assistant-libs/python-matter-server
COMMENT  = Python server to interact with Matter.
LICENSE  = Apache 2.0

PRE_CONFIGURE_TARGET = python_matter_server_pre_configure	

include ../../mk/spksrc.python-wheel.mk

.PHONY: python_matter_server_pre_configure
python_matter_server_pre_configure:
	@$(MSG) "Patch pyproject.toml to use custom version of home-assistant-chip-core"
	sed "s/home-assistant-chip-core==2024.11.4/home-assistant-chip-core==$(HOMEASSISTANT_CHIP_CORE_VERSION)/g" -i.bak $(WORK_DIR)/$(PKG_DIR)/pyproject.toml
	@$(MSG) "Patch for version check to avoid 'CHIP Core version does not match CHIP Clusters version.'"
	sed "s/return package_version(CHIP_CORE_PKG_NAME)/return \"$(HOMEASSISTANT_CHIP_CORE_ORIGINAL_VERSION)\"/g" -i.bak $(WORK_DIR)/$(PKG_DIR)/matter_server/common/helpers/util.py
