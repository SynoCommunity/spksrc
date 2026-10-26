PKG_NAME = linux-media-$(PKG_VERS)
PKG_VERS = 2018.08.07
PKG_EXT = tar.gz
PKG_GIT_HASH = 51be5a2b43f86af40b3fb78d7e4a22b5357fbc0d
PKG_DIST_NAME = $(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/torvalds/linux/archive
PKG_DIST_FILE = linux-$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = linux-$(PKG_GIT_HASH)

DEPENDS =

HOMEPAGE = https://linuxtv.org/
COMMENT  = Linux media subsystem at the mainline commit media_build was maintained against on 2018-08-08, the last before the Request API that kernels older than 3.7 cannot build.
LICENSE  = GPLv2

# Source only: the media subsystem and the headers media_build bundles with it
MEDIA_PATHS = Makefile drivers/media drivers/staging/media drivers/misc/altera-stapl sound/pci/bt87x.c include
EXTRACT_CMD = $(TAR_CMD) -xzpf $(DIST_FILE) -C $(EXTRACT_PATH) $(addprefix $(PKG_DIR)/,$(MEDIA_PATHS))

INSTALL_TARGET = nop

include ../../mk/spksrc.cross-install.mk
