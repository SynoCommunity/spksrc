SPK_NAME = minio
SPK_VERS = 2021.10.23
SPK_REV = 10
SPK_ICON = src/minio.png
DSM_UI_DIR = app

DEPENDS = cross/$(SPK_NAME)

UNSUPPORTED_ARCHS = $(PPC_ARCHS)

MAINTAINER = fgma
DESCRIPTION = MinIO is a high performance object storage server compatible with Amazon S3 APIs.
DISPLAY_NAME = MinIO
CHANGELOG = "Update to MinIO 2021-10-23T03-28-24Z. Multiple feature releases and a security bugfix release."
LICENSE_FILE = $(WORK_DIR)/src/github.com/minio/minio/LICENSE
HOMEPAGE = https://min.io/
LICENSE = AGPLv3.0

WIZARDS_DIR = src/wizard/

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 9000
SERVICE_PORT_TITLE = $(DISPLAY_NAME)
SERVICE_WIZARD_SHARE = wizard_data_directory

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

include ../../mk/spksrc.spk.mk
