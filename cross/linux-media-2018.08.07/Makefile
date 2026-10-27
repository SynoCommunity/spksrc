PKG_NAME = linux-media-$(PKG_VERS)
PKG_VERS = 2018.08.07
PKG_EXT = tar.bz2
# Built by native/linux-media-2018.08.07: the media subsystem of one mainline commit,
# packed by the media_build of the driver/linuxtv-* that unpacks it
PKG_DIST_NAME = linux-media-2018-08-07-51be5a2b43f8.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/SynoCommunity/spksrc/releases/download/linuxtv%2Fmedia_build
PKG_DIR = $(PKG_NAME)

DEPENDS =

HOMEPAGE = https://linuxtv.org/
COMMENT  = Linux media subsystem at the mainline commit media_build was maintained against on 2018-08-08, the last before the Request API that kernels older than 3.7 cannot build.
LICENSE  = GPLv2

# Kept packed: media_build unpacks it into its own tree
EXTRACT_CMD = install -D -m 644 $(DIST_FILE) $(EXTRACT_PATH)/$(PKG_DIR)/linux-media.tar.bz2

INSTALL_TARGET = nop

include ../../mk/spksrc.cross-install.mk
