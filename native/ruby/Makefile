PKG_NAME = ruby
PKG_VERS = 3.1.2
PKG_SHORT_VERS = $(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://cache.ruby-lang.org/pub/ruby/$(PKG_SHORT_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = http://www.ruby-lang.org/
COMMENT  = Ruby Programming Language.
LICENSE  = 2-clause BSDL

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-install-doc --prefix=$(STAGING_INSTALL_PREFIX)

INSTALL_TARGET = ruby_install_native

include ../../mk/spksrc.native-cc.mk

.PHONY: ruby_install_native
# Ruby's configure remembers its own --prefix and uses it during `make install`,
# _in addition to_ any prefix/DESTDIR passed to `make install`.
# Without this override, the install ends up nested in a doubled prefix.
ruby_install_native:
	$(RUN) $(MAKE) install
