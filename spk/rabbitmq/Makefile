SPK_NAME = rabbitmq
SPK_VERS = 3.11.20
SPK_REV = 9
SPK_ICON = src/rabbitmq.png
DSM_UI_DIR = app

DEPENDS = cross/rabbitmq
SPK_DEPENDS = "erlang>=25.0:erlang<25.4"

MAINTAINER = DigitalBox98
DESCRIPTION = RabbitMQ is one of the most popular open source message brokers. From T-Mobile to Runtastic, RabbitMQ is used worldwide at small startups and large enterprises. RabbitMQ is lightweight and easy to deploy on premises and in the cloud. It supports multiple messaging protocols. RabbitMQ can be deployed in distributed and federated configurations to meet high-scale, high-availability requirements.
DISPLAY_NAME = RabbitMQ
CHANGELOG = "1. Update RabbitMQ to v3.11.20.<br/>2. Update OpenSSL to v3.1.2."

HOMEPAGE = https://www.rabbitmq.com
LICENSE = MPL 2.0

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
STARTABLE = yes

CONF_DIR = src/conf/

ADMIN_PORT = 15672
ADMIN_URL = /

SPK_COMMANDS = bin/rabbitmqctl bin/rabbitmq-diagnostics bin/rabbitmq-plugins bin/rabbitmq-queues bin/rabbitmq-streams bin/rabbitmq-upgrade

POST_STRIP_TARGET = rabbitmq_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: rabbitmq_extra_install
rabbitmq_extra_install:
	@$(MSG) Install RabbitMQ configuration files
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/bin
	install -m 755 src/bin/* $(STAGING_DIR)/bin/
	install -m 755 -d $(STAGING_DIR)/etc/rabbitmq $(STAGING_DIR)/var
	install -m 644 src/etc/rabbitmq-env.conf $(STAGING_DIR)/etc/rabbitmq/rabbitmq-env.conf
	install -m 644 src/rabbitmq.conf $(STAGING_DIR)/var/rabbitmq.conf
	install -m 644 src/enabled_plugins $(STAGING_DIR)/var/enabled_plugins
