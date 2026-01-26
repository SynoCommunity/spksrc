PKG_NAME = sjpeg-source
# we need different PKG_NAME for sjpeg and sjpeg-source, because imagemagick depends on both
PKG_REAL_NAME = sjpeg
PKG_VERS = 1
PKG_EXT = tar.gz
# git hash from 2025.06.05
PKG_GIT_HASH = 46da5aec5fce05faabf1facf0066e36e6b1c4dff
PKG_DIST_NAME = $(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/webmproject/sjpeg/archive
PKG_DIST_FILE = $(PKG_REAL_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_REAL_NAME)-$(PKG_GIT_HASH)
EXTRACT_PATH = $(WORK_DIR)/sjpeg-tmp

DEPENDS =

HOMEPAGE = https://github.com/webmproject/sjpeg/
COMMENT  = SimpleJPEG: simple jpeg encoder.
LICENSE  = Apache 2.0

INSTALL_TARGET = sjpeg_source_install

include ../../mk/spksrc.install-resources.mk

.PHONY: sjpeg_source_install
sjpeg_source_install:
	@$(MSG) "Extract the sources only and use githash independent path"
	@rm -rf $(WORK_DIR)/$(PKG_NAME)/
	@mv -f $(EXTRACT_PATH)/$(PKG_DIR) $(WORK_DIR)/$(PKG_NAME)/
