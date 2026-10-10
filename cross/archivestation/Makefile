PKG_NAME = archivestation
PKG_VERS = 1.0.2
UPSTREAM_REV = 2
PKG_EXT = tar.gz
PKG_DIST_NAME = ArchiveStation-$(PKG_VERS)-$(UPSTREAM_REV)-source.tar.gz
PKG_DIST_SITE = https://github.com/jbdemonte/synology-archive-downloader/releases/download/v$(PKG_VERS)-$(UPSTREAM_REV)
PKG_DIST_FILE = $(PKG_DIST_NAME)
PKG_DIR = ArchiveStation-$(PKG_VERS)-$(UPSTREAM_REV)-source

HOMEPAGE = https://github.com/jbdemonte/synology-archive-downloader
COMMENT = Internet Archive downloader integrated into the DSM desktop.
LICENSE = MIT

INSTALL_TARGET = archivestation_install

ARCHIVESTATION_DESTDIR ?= $(STAGING_INSTALL_PREFIX)
ARCHIVESTATION_VERSION ?= $(PKG_VERS)-1

include ../../mk/spksrc.cross-install.mk

.PHONY: archivestation_install archivestation_stage
archivestation_install archivestation_stage:
	python3 $(WORK_DIR)/$(PKG_DIR)/scripts/stage_synology.py \
		--destination $(ARCHIVESTATION_DESTDIR) \
		--version "$(ARCHIVESTATION_VERSION)" \
		--package-id archivestation --python-relative env/bin/python3
