PKG_NAME = linux-media
PKG_VERS = 2021.01.08
PKG_EXT = tar.gz
LINUX_COMMIT = 321af22a3d2f6ed1fb1737c8588c01f6fec8a7b8
PKG_DIST_NAME = $(LINUX_COMMIT).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/torvalds/linux/archive
PKG_DIST_FILE = linux-$(LINUX_COMMIT).$(PKG_EXT)
PKG_DIR = linux-$(LINUX_COMMIT)

# The media_build revision whose make tar packs this tree
MEDIA_BUILD = driver/linuxtv-3.10

HOMEPAGE = https://linuxtv.org/
COMMENT  = Linux media subsystem at the commit media_build released as linux-media-2021-01-08-321af22a3d2f.
LICENSE  = GPLv2

# Rebuilds the tarball driver/linux-media-2021.01.08 downloads from the linuxtv/media_build
# release: media_build's make tar on this commit, archived after install by
# spksrc.build/archive.mk, in this directory
INSTALL_TARGET = linux_media_install
ARCHIVE_NAME = linux-media-2021-01-08-321af22a3d2f
ARCHIVE_EXT = tar.bz2
ARCHIVE_DIR = $(WORK_DIR)/media
ARCHIVE_KEEP = .

include ../../mk/spksrc.native-install.mk

# media_build writes the tarball to $(PWD): a cd, not make -C
.PHONY: linux_media_install
linux_media_install:
	env -i PATH="$(PATH)" $(MAKE) -C ../../$(MEDIA_BUILD) download
	rm -rf $(WORK_DIR)/media_build $(WORK_DIR)/media
	mkdir -p $(WORK_DIR)/media_build $(WORK_DIR)/media
	tar -xzf $(DISTRIB_DIR)/linuxtv-git$$(sed -n 's/^PKG_GIT_HASH = //p' ../../$(MEDIA_BUILD)/Makefile).tar.gz -C $(WORK_DIR)/media_build --strip-components=1
	cd $(WORK_DIR)/media_build/linux && MAKEFLAGS= make tar DIR=$(WORK_DIR)/$(PKG_DIR)
	tar -xjf $(WORK_DIR)/media_build/linux/linux-media.tar.bz2 -C $(WORK_DIR)/media
