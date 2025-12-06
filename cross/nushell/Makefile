PKG_NAME = nushell
PKG_VERS = 0.108.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/nushell/nushell/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# for nu_plugin_gstat and nu_plugin_query
DEPENDS = cross/openssl3

# some archs are supported under DSM 6, but x64 isn't (BoringSSL issue with ring crates).
# since nushell is a new package, we don't want to support DSM < 7 at all
REQUIRED_MIN_DSM = 7.0

HOMEPAGE = https://www.nushell.sh/
COMMENT  = A new type of shell.
LICENSE  = MIT

CARGO_BUILD_ARGS = --locked

NUSHELL_PLUGINS = inc polars gstat formats query

POST_INSTALL_TARGET = nushell_install_plugins

include ../../mk/spksrc.cross-rust.mk


.PHONY: nushell_install_plugins
nushell_install_plugins:
	@$(MSG) "Install the default plugins '$(NUSHELL_PLUGINS)'"
	@for plugin in $(NUSHELL_PLUGINS); do \
		$(MSG) "- Create plugin $${plugin}" ; \
		$(RUN) cargo +$(TC_RUSTUP_TOOLCHAIN) install --root $(STAGING_INSTALL_PREFIX) --locked nu_plugin_$${plugin} --target $(RUST_TARGET) ; \
	done
