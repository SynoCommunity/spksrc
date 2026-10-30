PKG_NAME = linux-media-$(PKG_VERS)
PKG_VERS = 2022.06.05
PKG_EXT = tar.bz2
# Built by native/linux-media-2022.06.05: the media subsystem of one mainline commit,
# packed by the media_build of the driver/linuxtv-* that unpacks it
PKG_DIST_NAME = linux-media-2022-06-05-f2906aa86338.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/SynoCommunity/spksrc/releases/download/linuxtv%2Fmedia_build
PKG_DIR = $(PKG_NAME)

HOMEPAGE = https://linuxtv.org/
COMMENT  = Linux media subsystem at v5.19-rc1, the tree media_build released as linux-media-2022-06-05-f2906aa86338.
LICENSE  = GPLv2

# Kept packed, in the directory of each kernel: media_build unpacks it into its own tree
EXTRACT_CMD = install -D -m 644 $(DIST_FILE) $(WORK_DIR)/$(PKG_DIR)/linux-media.tar.bz2

CONFIGURE_TARGET = nop
COMPILE_TARGET   = nop
INSTALL_TARGET   = nop

include ../../mk/spksrc.driver.mk
