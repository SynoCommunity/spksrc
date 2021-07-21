SPK_NAME = rabbitmq
SPK_VERS = 3.8.16
SPK_REV = 4
SPK_ICON = src/rabbitmq.png

DEPENDS = cross/$(SPK_NAME)

SPK_DEPENDS = "erlang<24"

MAINTAINER = DigitalBox98
DESCRIPTION = RabbitMQ is one of the most popular open source message brokers. From T-Mobile to Runtastic, RabbitMQ is used worldwide at small startups and large enterprises. RabbitMQ is lightweight and easy to deploy on premises and in the cloud. It supports multiple messaging protocols. RabbitMQ can be deployed in distributed and federated configurations to meet high-scale, high-availability requirements.
CHANGELOG = "Update RabbitMQ to v3.8.16."

DISPLAY_NAME = RabbitMQ

HOMEPAGE   = https://www.rabbitmq.com
LICENSE    = MPL 2.0

SERVICE_USER   = auto
SERVICE_SETUP  = src/service-setup.sh
STARTABLE      = yes

# Service configuration
CONF_DIR = src/conf/
# Admin link
ADMIN_PORT = 15672

POST_STRIP_TARGET = rabbitmq_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: rabbitmq_extra_install
rabbitmq_extra_install:
	# Create directories
	install -m 755 -d ${STAGING_DIR}/etc/rabbitmq ${STAGING_DIR}/var
	# Install RabbitMQ configurations
	install -m 644 src/etc/rabbitmq-env.conf ${STAGING_DIR}/etc/rabbitmq/rabbitmq-env.conf
	install -m 644 src/rabbitmq.conf ${STAGING_DIR}/var/rabbitmq.conf
	install -m 644 src/enabled_plugins ${STAGING_DIR}/var/enabled_plugins
