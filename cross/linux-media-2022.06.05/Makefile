PKG_NAME = linux-media-$(PKG_VERS)
PKG_VERS = 2022.06.05
PKG_EXT = tar.gz
PKG_GIT_HASH = f2906aa863381afb0015a9eb7fefad885d4e5a56
PKG_DIST_NAME = $(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/torvalds/linux/archive
PKG_DIST_FILE = linux-$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = linux-$(PKG_GIT_HASH)

DEPENDS =

HOMEPAGE = https://linuxtv.org/
COMMENT  = Linux media subsystem at v5.19-rc1, the tree media_build released as linux-media-2022-06-05-f2906aa86338.
LICENSE  = GPLv2

# Source only: the media subsystem and the headers media_build bundles with it
MEDIA_PATHS = Makefile drivers/media drivers/staging/media drivers/misc/altera-stapl sound/pci/bt87x.c include
EXTRACT_CMD = $(TAR_CMD) -xzpf $(DIST_FILE) -C $(EXTRACT_PATH) $(addprefix $(PKG_DIR)/,$(MEDIA_PATHS))

INSTALL_TARGET = nop

include ../../mk/spksrc.cross-install.mk
