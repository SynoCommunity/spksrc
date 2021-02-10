PKG_NAME = elixir
PKG_VERS = 1.8.2
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/elixir-lang/elixir/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = https://elixir-lang.org
COMMENT  = Elixir is a dynamic, functional language designed for building scalable and maintainable applications. Elixir leverages the Erlang VM, known for running low-latency, distributed and fault-tolerant systems, while also being successfully used in web development and the embedded software domain.

LICENSE = Apache License

CONFIGURE_TARGET = elixir_configure
INSTALL_TARGET = elixir_install

include ../../mk/spksrc.native-cc.mk

.PHONY: elixir_configure
elixir_configure:
	$(RUN) echo "No configure needed"

.PHONY: elixir_install
elixir_install:
	$(RUN) make install DESTDIR=$(INSTALL_DIR) INSTALL_PREFIX=

