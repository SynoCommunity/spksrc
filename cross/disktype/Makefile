PKG_NAME = disktype
PKG_VERS = 9
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/disktype/files/disktype/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://disktype.sourceforge.net/
COMMENT  = Detects the content format of a disk or disk image by checking for signatures of file systems, partition tables, and boot codes.
LICENSE  = MIT

CONFIGURE_TARGET = nop
INSTALL_TARGET = disktype_install

ADDITIONAL_CPPFLAGS = -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64

include ../../mk/spksrc.cross-cc.mk

.PHONY: disktype_install
disktype_install:
	@$(MSG) "Install disktype"
	@install -d $(STAGING_INSTALL_PREFIX)/bin
	@install -m 755 $(WORK_DIR)/$(PKG_DIR)/$(PKG_NAME) $(STAGING_INSTALL_PREFIX)/bin/
