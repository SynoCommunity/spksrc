PKG_NAME = linux-media-$(PKG_VERS)
PKG_VERS = 2021.01.08
PKG_EXT = tar.bz2
# Built by native/linux-media-2021.01.08: the media subsystem of one mainline commit,
# packed by the media_build of the driver/linuxtv-* that unpacks it
PKG_DIST_NAME = linux-media-2021-01-08-321af22a3d2f.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/SynoCommunity/spksrc/releases/download/linuxtv%2Fmedia_build
PKG_DIR = $(PKG_NAME)

DEPENDS =

HOMEPAGE = https://linuxtv.org/
COMMENT  = Linux media subsystem at the commit media_build released as linux-media-2021-01-08-321af22a3d2f.
LICENSE  = GPLv2

# Kept packed: media_build unpacks it into its own tree
EXTRACT_CMD = install -D -m 644 $(DIST_FILE) $(EXTRACT_PATH)/$(PKG_DIR)/linux-media.tar.bz2

INSTALL_TARGET = nop

include ../../mk/spksrc.cross-install.mk
