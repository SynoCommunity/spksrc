PKG_NAME = elixir
PKG_VERS = 1.12.3
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/elixir-lang/elixir/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = native/erlang

HOMEPAGE = https://elixir-lang.org
COMMENT  = Elixir is a dynamic, functional language designed for building scalable and maintainable applications. Elixir leverages the Erlang VM, known for running low-latency, distributed and fault-tolerant systems, while also being successfully used in web development and the embedded software domain.

LICENSE = Apache 2.0

ERLANG_BIN_DIR = $(realpath $(WORK_DIR)/../../../native/erlang/work-native/install/usr/local/bin)

CONFIGURE_TARGET = nop
INSTALL_MAKE_OPTIONS = install DESTDIR=$(INSTALL_DIR) PREFIX=$(INSTALL_PREFIX)

ENV += PATH=$$PATH:$(ERLANG_BIN_DIR)

include ../../mk/spksrc.native-cc.mk
