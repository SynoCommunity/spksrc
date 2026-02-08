PKG_NAME = libglvnd
PKG_VERS = 1.7.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/NVIDIA/libglvnd/archive/refs/tags
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/NVIDIA/libglvnd
COMMENT = The GL Vendor-Neutral Dispatch library
#LICENSE = Copyright 2013, NVIDIA CORPORATION.

# -----------------------------------------------------------------------------
# Post-extract: create symlink for consistent naming
# -----------------------------------------------------------------------------
POST_EXTRACT_TARGET = libglvnd_post_extract_target
.PHONY: libglvnd_post_extract_target
libglvnd_post_extract_target:
	@cd $(WORK_DIR) && ln -s $(PKG_DIR) OpenGL-Headers

include ../../mk/spksrc.cross-meson.mk
