PKG_NAME = archivestation
PKG_VERS = 1.0.0
PKG_EXT = tar.gz
PKG_DIST_NAME = ArchiveStation-$(PKG_VERS)-1-source.tar.gz
PKG_DIST_SITE = https://github.com/jbdemonte/synology-archive-downloader/releases/download/v$(PKG_VERS)-1
PKG_DIST_FILE = $(PKG_DIST_NAME)
PKG_DIR = ArchiveStation-$(PKG_VERS)-1-source

HOMEPAGE = https://github.com/jbdemonte/synology-archive-downloader
COMMENT = Internet Archive downloader integrated into the DSM desktop.
LICENSE = MIT

INSTALL_TARGET = archivestation_install

include ../../mk/spksrc.cross-install.mk

.PHONY: archivestation_install
archivestation_install:
	python3 $(CURDIR)/src/install.py $(WORK_DIR)/$(PKG_DIR) $(STAGING_INSTALL_PREFIX)
