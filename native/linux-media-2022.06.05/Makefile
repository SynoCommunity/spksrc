PKG_NAME = linux-media
PKG_VERS = 2022.06.05
PKG_EXT = tar.gz
LINUX_COMMIT = f2906aa863381afb0015a9eb7fefad885d4e5a56
PKG_DIST_NAME = $(LINUX_COMMIT).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/torvalds/linux/archive
PKG_DIST_FILE = linux-$(LINUX_COMMIT).$(PKG_EXT)
PKG_DIR = linux-$(LINUX_COMMIT)

# The media_build revision whose make tar packs this tree
MEDIA_BUILD = driver/linuxtv-4.4

HOMEPAGE = https://linuxtv.org/
COMMENT  = Linux media subsystem at v5.19-rc1, the tree media_build released as linux-media-2022-06-05-f2906aa86338.
LICENSE  = GPLv2

# Rebuilds the tarball driver/linux-media-2022.06.05 downloads from the linuxtv/media_build
# release: media_build's make tar on this commit, archived after install by
# spksrc.build/archive.mk, in this directory
INSTALL_TARGET = linux_media_install
ARCHIVE_NAME = linux-media-2022-06-05-f2906aa86338
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
