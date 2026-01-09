PKG_NAME = rabbitmq
PKG_VERS = 3.11.28
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-server-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/rabbitmq/rabbitmq-server/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-server-$(PKG_VERS)

BUILD_DEPENDS = native/erlang native/elixir

DEPENDS =

HOMEPAGE = https://www.rabbitmq.com
COMMENT  = RabbitMQ is the most widely deployed open source message broker.
LICENSE  = MPL 2.0

ERLANG_BIN_DIR = $(realpath $(WORK_DIR)/../../../native/erlang/work-native/install/usr/local/bin)
ELIXIR_BIN_DIR = $(realpath $(WORK_DIR)/../../../native/elixir/work-native/install/usr/local/bin)

# Build requires native erlang and elixir
ENV += PATH=$$PATH:$(ERLANG_BIN_DIR):$(ELIXIR_BIN_DIR)

CONFIGURE_TARGET = nop
INSTALL_MAKE_OPTIONS = install DESTDIR=$(INSTALL_DIR) PREFIX=$(INSTALL_PREFIX) RMQ_ROOTDIR=$(INSTALL_PREFIX)

# we need a git tag that matches the rabbitmq version
# to prevent to use an unrelated tag of the spksrc repo (at time of writing this is "mono-5.20.1.34-17dsm7")
# as there are sub projects that take the version from the git repositry with "git describe --tag"
PRE_CONFIGURE_TARGET = rabbitmq_pre_configure
POST_INSTALL_TARGET = rabbitmq_post_install

include ../../mk/spksrc.cross-cc.mk

.PHONY rabbitmq_pre_configure:
rabbitmq_pre_configure:
	@$(MSG) "Temporary create a version tag v$(PKG_VERS)"
	@git tag -f v$(PKG_VERS)

.PHONY rabbitmq_post_install:
rabbitmq_post_install:
	@$(MSG) "Remove the temporary version tag v$(PKG_VERS)"
	@git tag -d v$(PKG_VERS)
	
