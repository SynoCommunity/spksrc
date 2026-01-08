PKG_NAME = mp3gain
PKG_VERS = 1.6.2
PKG_EXT = zip
PKG_DIST_NAME = $(PKG_NAME)-$(subst .,_,$(PKG_VERS))-src.$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/mp3gain/files/mp3gain/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

EXTRACT_PATH = $(WORK_DIR)/$(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/mpg123

HOMEPAGE = https://mp3gain.sourceforge.net/
COMMENT  = MP3Gain analyzes and losslessly adjusts mp3 files to a specified target volume.
LICENSE  = LGPLv2

CONFIGURE_TARGET = nop
ENV += INSTALL_PATH=$(STAGING_INSTALL_PREFIX)/bin

include ../../mk/spksrc.cross-cc.mk
