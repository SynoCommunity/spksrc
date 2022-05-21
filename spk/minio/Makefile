SPK_NAME = minio
SPK_VERS = 2022.05.19
SPK_REV = 14
SPK_ICON = src/minio.png
DSM_UI_DIR = app

DEPENDS = cross/$(SPK_NAME)

UNSUPPORTED_ARCHS = $(PPC_ARCHS)

MAINTAINER = fgma
DESCRIPTION = MinIO is a high performance object storage server compatible with Amazon S3 APIs.
DISPLAY_NAME = MinIO
CHANGELOG = "Update to MinIO 2022-04-26T01-20-24Z. Multiple minor feature releases and security releases."
LICENSE_FILE = $(WORK_DIR)/src/github.com/minio/minio/LICENSE
HOMEPAGE = https://min.io/
LICENSE = AGPLv3.0

WIZARDS_DIR = src/wizard

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT_TITLE = $(DISPLAY_NAME)
SERVICE_WIZARD_SHARE = wizard_data_directory
USE_DATA_SHARE_WORKER = yes
FWPORTS = src/minio.sc
# Console Port (API Port is 9000)
ADMIN_PORT = 9001

POST_STRIP_TARGET = minio_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: minio_extra_install
minio_extra_install:
	@install -d -m 755 $(STAGING_DIR)/var
	@install -m 644 src/environment-variables $(STAGING_DIR)/var/
