SPK_NAME = rustfs
SPK_VERS = 1.0.1
SPK_REV = 1
SPK_ICON = src/rustfs.png
DSM_UI_DIR = app

DEPENDS = cross/rustfs

MAINTAINER = tebbiworld
DESCRIPTION = RustFS is an S3-compatible object storage server written in Rust. It ships a web console for buckets, users, access keys and policies, which makes it a drop-in alternative for users of the archived MinIO package. The S3 API listens on port 9200, the web console on port 9201.
DISPLAY_NAME = RustFS
CHANGELOG = "Initial package: RustFS 1.0.1, built from the upstream prebuilt static-pie musl binaries (x86_64 and aarch64)."
HOMEPAGE = https://rustfs.com/
LICENSE = Apache-2.0

# The rustfs binary is ~250 MB; restrict to recent 64-bit NAS.
OS_MIN_VER = 7.1-42661

WIZARDS_DIR = src/wizard

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_WIZARD_SHARENAME = wizard_data_directory
FWPORTS = src/rustfs.sc

# Web console / admin port (the S3 API port is 9200).
ADMIN_PORT = 9201
ADMIN_URL = /rustfs/console/

POST_STRIP_TARGET = rustfs_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: rustfs_extra_install
rustfs_extra_install:
	@install -d -m 755 $(STAGING_DIR)/var
	@install -m 644 src/environment-variables $(STAGING_DIR)/var/
