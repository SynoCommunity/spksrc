PKG_NAME = rabbitmq
PKG_VERS = 3.8.23
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-server-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/rabbitmq/rabbitmq-server/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-server-$(PKG_VERS)

BUILD_DEPENDS = native/erlang native/elixir native/rsync native/zip

DEPENDS =

HOMEPAGE = https://www.rabbitmq.com
COMMENT  = RabbitMQ is the most widely deployed open source message broker.
LICENSE  = MPL 2.0

ERLANG_BIN_DIR = $(realpath $(WORK_DIR)/../../../native/erlang/work-native/install/usr/local/bin)
ELIXIR_BIN_DIR = $(realpath $(WORK_DIR)/../../../native/elixir/work-native/install/usr/local/bin)
RSYNC_BIN_DIR = $(realpath $(WORK_DIR)/../../../native/rsync/work-native/install/usr/local/bin)
ZIP_BIN_DIR = $(realpath $(WORK_DIR)/../../../native/zip/work-native/install/usr/local/bin)

# Build requires native erlang and elixir
# Install requires native rsync and zip
ENV += PATH=$$PATH:$(ERLANG_BIN_DIR):$(ELIXIR_BIN_DIR):$(RSYNC_BIN_DIR):$(ZIP_BIN_DIR)

CONFIGURE_TARGET = nop
INSTALL_MAKE_OPTIONS = install DESTDIR=$(INSTALL_DIR) PREFIX=$(INSTALL_PREFIX) RMQ_ROOTDIR=$(INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk
