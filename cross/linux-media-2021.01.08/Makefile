PKG_NAME = linux-media
PKG_VERS = 2021.01.08
PKG_EXT = tar.gz
PKG_GIT_HASH = 321af22a3d2f6ed1fb1737c8588c01f6fec8a7b8
PKG_DIST_NAME = $(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/torvalds/linux/archive
PKG_DIST_FILE = linux-$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = linux-$(PKG_GIT_HASH)

DEPENDS =

HOMEPAGE = https://linuxtv.org/
COMMENT  = Linux media subsystem at the commit media_build released as linux-media-2021-01-08-321af22a3d2f.
LICENSE  = GPLv2

# Source only: the media subsystem and the headers media_build bundles with it
MEDIA_PATHS = Makefile drivers/media drivers/staging/media drivers/misc/altera-stapl sound/pci/bt87x.c include
EXTRACT_CMD = $(TAR_CMD) -xzpf $(DIST_FILE) -C $(EXTRACT_PATH) $(addprefix $(PKG_DIR)/,$(MEDIA_PATHS))

INSTALL_TARGET = nop

include ../../mk/spksrc.cross-install.mk
