SPK_NAME = minio
SPK_VERS = 2025.10.15
SPK_REV = 17
SPK_ICON = src/minio.png
DSM_UI_DIR = app

DEPENDS = cross/minio cross/minio-client

UNSUPPORTED_ARCHS = $(PPC_ARCHS)

MAINTAINER = fgma
DESCRIPTION = MinIO is a high performance object storage server compatible with Amazon S3 APIs. This Package includes the 'minio-client' \(mc\).
DISPLAY_NAME = MinIO
CHANGELOG = "1. Update to MinIO RELEASE.2025-10-15T17-29-55Z (security fixes, including privilege escalation via STS/service accounts). <br/>2. FS-mode data from old installations cannot be read by newer versions. <br/>3. Upstream MinIO repository has been archived; no further releases are expected."
LICENSE_FILE = $(WORK_DIR)/src/github.com/minio/minio/LICENSE
HOMEPAGE = https://min.io/
LICENSE = AGPLv3.0

WIZARDS_DIR = src/wizard

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_WIZARD_SHARENAME = wizard_data_directory
FWPORTS = src/minio.sc
# Console Port (API Port is 9000)
ADMIN_PORT = 9001

POST_STRIP_TARGET = minio_extra_install

# official binary is "mc" not "minio-client", but "mc" is already used for midnight-commander
SPK_COMMANDS = bin/minio-client

include ../../mk/spksrc.spk.mk

.PHONY: minio_extra_install
minio_extra_install:
	@install -d -m 755 $(STAGING_DIR)/var
	@install -m 644 src/environment-variables $(STAGING_DIR)/var/
