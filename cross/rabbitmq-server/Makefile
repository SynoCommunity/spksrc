PKG_NAME = rabbitmq-server
PKG_VERS = 3.8.12
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/rabbitmq/rabbitmq-server/releases/download/v$(PKG_VERS)/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = native/elixir

DEPENDS = 

HOMEPAGE = https://www.rabbitmq.com
COMMENT  = RabbitMQ is the most widely deployed open source message broker
LICENSE  = GPL Public License

include ../../mk/spksrc.archs.mk

# Build is requiring native for erlang and elixir
ENV += PATH=$(WORK_DIR)/../../../native/erlang/work-native/install/usr/local/bin:$(WORK_DIR)/../../../native/elixir/work-native/install/usr/local/bin:$$PATH

CONFIGURE_TARGET = nop
INSTALL_TARGET = rabbitmq_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: rabbitmq_install
rabbitmq_install:
	$(RUN) DESTDIR=$(INSTALL_DIR) $(MAKE) install PREFIX=$(INSTALL_PREFIX) RMQ_ROOTDIR=$(INSTALL_PREFIX)

