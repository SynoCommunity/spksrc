PKG_NAME = urw-base35-fonts
PKG_VERS = 20151005
PKG_EXT = zip
PKG_DIST_NAME = urw-base35-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.icm.edu.pl/pub/unix/postscript/ghostscript/fonts
# download and extract only
EXTRACT_PATH = $(WORK_DIR)/share/fonts

DEPENDS =

# arch independent
override ARCH=

HOMEPAGE = https://www.ghostscript.com/doc/current/Fonts.htm
COMMENT  = Core Font Set containing 35 freely distributable fonts from (URW)++
LICENSE  = GNU AGPLv3

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = urw-base35-fonts


include ../../mk/spksrc.cross-cc.mk

.PHONY: urw-base35-fonts
urw-base35-fonts:
	$(RUN) install -m 755 -d $(STAGING_INSTALL_PREFIX)/share/fonts
	$(RUN) cp share/fonts/* $(STAGING_INSTALL_PREFIX)/share/fonts
