SPK_NAME = rabbitmq-server
SPK_VERS = 3.8.12
SPK_REV = 3
SPK_ICON = src/rabbitmq.png

DEPENDS = cross/$(SPK_NAME)

SPK_DEPENDS = "erlang"

MAINTAINER = DigitalBox98
DESCRIPTION = RabbitMQ is one of the most popular open source message brokers. From T-Mobile to Runtastic, RabbitMQ is used worldwide at small startups and large enterprises. RabbitMQ is lightweight and easy to deploy on premises and in the cloud. It supports multiple messaging protocols. RabbitMQ can be deployed in distributed and federated configurations to meet high-scale, high-availability requirements.

DISPLAY_NAME = RabbitMQ Server

HOMEPAGE   = http://www.rabbitmq.com
LICENSE    = MPL

SERVICE_USER         = auto
SERVICE_SETUP        = src/service-setup.sh
STARTABLE            = yes

# Service configuration
SERVICE_PORT = 15672
SERVICE_PORT_TITLE = RabbitMQ Server(HTTP)

# Admin link
ADMIN_PORT = $(SERVICE_PORT)

POST_STRIP_TARGET = rabbitmq_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: rabbitmq_extra_install
rabbitmq_extra_install:
	$(RUN) patch -i $(WORK_DIR)/../poststrip_patches/001_rabbitmq-server.patch $(STAGING_DIR)/lib/rabbitmq_server-$(SPK_VERS)/sbin/rabbitmq-server
	install -m 755 -d ${STAGING_DIR}/etc/
	install -m 755 -d ${STAGING_DIR}/etc/rabbitmq/	
	install -m 755 -d ${STAGING_DIR}/etc/var/
	install -m 755 -d ${STAGING_DIR}/etc/var/lib/
	install -m 755 -d ${STAGING_DIR}/etc/var/lib/rabbitmq
	install -m 755 -d ${STAGING_DIR}/etc/var/lib/rabbitmq/mnesia
	# RabbitMQ Config
	echo "loopback_users.guest = false \n" > ${STAGING_DIR}/etc/rabbitmq/rabbitmq.conf
	echo "log.dir = /var/packages/rabbitmq-server/var/" >> ${STAGING_DIR}/etc/rabbitmq/rabbitmq.conf
	# RabbitMQ ENV variables
	echo "RABBITMQ_CONFIG_FILE=${INSTALL_PREFIX}/etc/rabbitmq/rabbitmq.conf" > ${STAGING_DIR}/etc/rabbitmq/rabbitmq-env.conf
	echo "RABBITMQ_MNESIA_BASE=${INSTALL_PREFIX}/etc/var/lib/rabbitmq/mnesia" >> ${STAGING_DIR}/etc/rabbitmq/rabbitmq-env.conf
	echo "RABBITMQ_LOG_BASE=/var/packages/rabbitmq-server/var" >> ${STAGING_DIR}/etc/rabbitmq/rabbitmq-env.conf
	echo "RABBITMQ_ENABLED_PLUGINS_FILE=${INSTALL_PREFIX}/etc/rabbitmq/enabled_plugins" >> ${STAGING_DIR}/etc/rabbitmq/rabbitmq-env.conf

