PKG_NAME = dvb-apps
PKG_VERS = 1.1.1+rev1500
PKG_EXT = tar.bz2
PKG_DIST_NAME = linuxtv-$(PKG_NAME)_$(PKG_VERS).orig.$(PKG_EXT)
PKG_DIST_SITE = http://deb.debian.org/debian/pool/main/l/linuxtv-dvb-apps
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-3ee111da5b3a
DEPENDS =

HOMEPAGE = https://www.linuxtv.org/wiki/index.php/LinuxTV_dvb-apps
COMMENT  = Linux DVB API applications and useful DVB utilitie
LICENSE  = GPL

CONFIGURE_TARGET = nop

# Applying Debian patches
PATCHES_LEVEL = 1

include ../../mk/spksrc.cross-cc.mk
