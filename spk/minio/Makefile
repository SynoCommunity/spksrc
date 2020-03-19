SPK_NAME = minio
SPK_VERS = 2020-03-14T02-21-58Z
SPK_REV = 4
SPK_ICON = src/minio.png
DSM_UI_DIR = app

DEPENDS = cross/busybox cross/$(SPK_NAME)

UNSUPPORTED_ARCHS = $(PPC_ARCHES)

MAINTAINER = fgma
DESCRIPTION = The 100% Open Source, Enterprise-Grade, Amazon S3 Compatible Object Storage.
RELOAD_UI = yes
DISPLAY_NAME = MinIO
CHANGELOG = "Update to latest release which includes multiple minor bugfix releases. Breaking Change: Use bulk locks in Multi-object delete."
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
