SPK_NAME = minio
SPK_VERS = 2021.10.27
SPK_REV = 10
SPK_ICON = src/minio.png
DSM_UI_DIR = app

DEPENDS = cross/$(SPK_NAME)

UNSUPPORTED_ARCHS = $(PPC_ARCHS)

MAINTAINER = fgma
DESCRIPTION = MinIO is a high performance object storage server compatible with Amazon S3 APIs.
DISPLAY_NAME = MinIO
CHANGELOG = "Update to MinIO 2021-10-27T16-29-42Z. Multiple feature releases and a security bugfix release."
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

include ../../mk/spksrc.spk.mk
