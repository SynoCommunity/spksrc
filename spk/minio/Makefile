SPK_NAME = minio
SPK_VERS = 2020-04-23T00-58-49Z
SPK_REV = 5
SPK_ICON = src/minio.png
DSM_UI_DIR = app

DEPENDS = cross/busybox cross/$(SPK_NAME)

UNSUPPORTED_ARCHS = $(PPC_ARCHES)
GENERIC_ARCHS = ARM7

MAINTAINER = fgma
DESCRIPTION = MinIO is a high performance object storage server compatible with Amazon S3 APIs.
RELOAD_UI = yes
DISPLAY_NAME = MinIO
CHANGELOG = "Critical security release to address authentication bypass issue in admin API. Please upgrade immediately. Breaking Change related to force deletion of non-empty bucket. So, rolling upgrade is not supported."
HOMEPAGE = https://min.io/
LICENSE = Apache License 2.0
STARTABLE = yes

WIZARDS_DIR = src/wizard/

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 9000
SERVICE_PORT_TITLE = $(DISPLAY_NAME)
SERVICE_WIZARD_SHARE = wizard_data_directory

# Use busybox start-stop-daemon support
# Options and environment are provided in service-setup.sh
SERVICE_EXE = $${SYNOPKG_PKGDEST}/bin/minio

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

BUSYBOX_CONFIG = usrmng daemon nice
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk
