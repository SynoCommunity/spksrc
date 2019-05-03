SPK_NAME = minio
SPK_VERS = 2019-05-02T19-07-09Z
SPK_REV = 2
SPK_ICON = src/minio.png
DSM_UI_DIR = app

DEPENDS = cross/busybox cross/$(SPK_NAME)

UNSUPPORTED_ARCHS = $(PPC_ARCHES)

MAINTAINER = minio
DESCRIPTION = The 100% Open Source, Enterprise-Grade, Amazon S3 Compatible Object Storage.
RELOAD_UI = yes
DISPLAY_NAME = minio
CHANGELOG = "Initial version"
HOMEPAGE = https://min.io/
LICENSE = Apache License 2.0
STARTABLE = yes

WIZARDS_DIR = src/wizard/

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 9000
SERVICE_PORT_TITLE = $(DISPLAY_NAME)
SERVICE_WIZARD_GROUP = wizard_group
SERVICE_WIZARD_SHARE = wizard_data_directory

# Use busybox start-stop-daemon support
# Options and environment are provided in service-setup.sh
SERVICE_EXE = $${SYNOPKG_PKGDEST}/bin/minio

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

FWPORTS = src/${SPK_NAME}.sc

POST_STRIP_TARGET = minio_extra_install

BUSYBOX_CONFIG = usrmng daemon nice
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: minio_extra_install
minio_extra_install:
	@echo "===> Copying files"
	install -m 755 -d $(STAGING_DIR)/var
	install -m 600 src/options.conf $(STAGING_DIR)/var/options.conf
