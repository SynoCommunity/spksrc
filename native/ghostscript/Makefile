PKG_NAME = ghostscript
PKG_VERS = 9.50
GS_VER = $(subst .,,$(PKG_VERS))
PKG_ARCH = linux-x86_64
PKG_EXT = tgz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-$(PKG_ARCH).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs$(GS_VER)
PKG_DIR =  $(PKG_NAME)-$(PKG_VERS)-$(PKG_ARCH)

HOMEPAGE = https://www.ghostscript.com/index.html
COMMENT  = An interpreter for the PostScript language and for PDF.
LICENSE  = GPL Ghostscript, AGPL

INSTALL_TARGET = ghostscript_install

include ../../mk/spksrc.native-install.mk

.PHONY: ghostscript_install
ghostscript_install:
	install -d -m 755 $(STAGING_INSTALL_PREFIX)/bin
	$(RUN) install -m 755 gs-$(GS_VER)-$(PKG_ARCH) $(STAGING_INSTALL_PREFIX)/bin/gs
