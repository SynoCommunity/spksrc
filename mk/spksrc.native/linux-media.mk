###############################################################################
# spksrc.native/linux-media.mk
#
# Builds the linux-media tarball a cross/linux-media-<date> downloads: the media
# subsystem of one mainline commit, packed by the `make tar` of the media_build
# revision of the driver/linuxtv-* tier that unpacks it.
#
# The tarballs are hosted on
#   https://github.com/SynoCommunity/spksrc/releases/tag/linuxtv%2Fmedia_build
# Their content is reproducible, not their bytes (tar timestamps): a rebuilt one
# goes up under a new name, never over a published one.
#
# Variables:
#   LINUX_COMMIT   mainline commit, downloaded as a GitHub archive
#   MEDIA_BUILD    driver/linuxtv-* whose media_build packs it
#
# Result: native/linux-media-<date>/linux-media-<date>-<commit:12>.tar.bz2
###############################################################################

PKG_NAME = linux-media
PKG_EXT = tar.gz
PKG_DIST_NAME = $(LINUX_COMMIT).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/torvalds/linux/archive
PKG_DIST_FILE = linux-$(LINUX_COMMIT).$(PKG_EXT)
PKG_DIR = linux-$(LINUX_COMMIT)

HOMEPAGE = https://linuxtv.org/
LICENSE  = GPLv2

INSTALL_TARGET = linux_media_tarball

include ../../mk/spksrc.native-install.mk

MEDIA_BUILD_DIR = $(WORK_DIR)/media_build

# media_build writes the tarball to $(PWD): a cd, not make -C
.PHONY: linux_media_tarball
linux_media_tarball:
	env -i PATH="$(PATH)" $(MAKE) -C ../../$(MEDIA_BUILD) download
	rm -rf $(MEDIA_BUILD_DIR) && mkdir -p $(MEDIA_BUILD_DIR)
	tar -xzf $(DISTRIB_DIR)/linuxtv-git$$(sed -n 's/^PKG_GIT_HASH = //p' ../../$(MEDIA_BUILD)/Makefile).tar.gz -C $(MEDIA_BUILD_DIR) --strip-components=1
	cd $(MEDIA_BUILD_DIR)/linux && MAKEFLAGS= make tar DIR=$(WORK_DIR)/$(PKG_DIR)
	mv $(MEDIA_BUILD_DIR)/linux/linux-media.tar.bz2 $(CURDIR)/linux-media-$(subst .,-,$(PKG_VERS))-$$(echo $(LINUX_COMMIT) | cut -c1-12).tar.bz2
