SPK_NAME = nushell
SPK_VERS = 0.108.0
SPK_REV = 1
SPK_ICON = src/nushell.png

DEPENDS = cross/nushell

REQUIRED_MIN_DSM = 7.0

MAINTAINER = SynoCommunity
DESCRIPTION = A new type of shell. This package includes the nushell plugins 'inc' 'polars' 'gstat' 'formats' and 'query' and a script 'nu_install_plugins.sh'.
DISPLAY_NAME = nu
STARTABLE = no
CHANGELOG = "Initial package release"

HOMEPAGE = https://www.nushell.sh/
LICENSE = MIT

POST_STRIP_TARGET = nushell_extra_install

SPK_COMMANDS = bin/nu bin/nu_install_plugins.sh

include ../../mk/spksrc.spk.mk

.PHONY: nushell_extra_install
# some plugins need rpath to find shared libraries (of openssl) in the lib folder of the package
nushell_extra_install:
	@$(MSG) "- Add library rpath to plugins."
	patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/bin/nu_plugin_*
	@$(MSG) "- Add plugin install script."
	install -m 755 src/nu_install_plugins.sh $(STAGING_DIR)/bin/
