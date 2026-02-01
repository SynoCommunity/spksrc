PKG_NAME = libid3tag
PKG_VERS = 0.15.1b
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://downloads.sourceforge.net/project/mad/libid3tag/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.underbit.com/products/mad/
COMMENT  = ID3 tag manipulation library, part of MAD: MPEG Audio Decoder.
LICENSE  = GPL

GNU_CONFIGURE = 1
POST_INSTALL_TARGET += libid3tag_pc

include ../../mk/spksrc.cross-cc.mk

# libid3tag does not install a pkg-config file
# Required for Meson-based consumers (e.g. MPD)
libid3tag_pc:
	@mkdir -p $(STAGING_INSTALL_PREFIX)/lib/pkgconfig
	@echo 'prefix=$(INSTALL_PREFIX)' >  $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/id3tag.pc
	@echo 'exec_prefix=$${prefix}' >> $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/id3tag.pc
	@echo 'libdir=$${exec_prefix}/lib' >> $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/id3tag.pc
	@echo 'includedir=$${prefix}/include' >> $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/id3tag.pc
	@echo '' >> $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/id3tag.pc
	@echo 'Name: id3tag' >> $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/id3tag.pc
	@echo 'Description: ID3 tag manipulation library' >> $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/id3tag.pc
	@echo 'Version: $(PKG_VERS)' >> $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/id3tag.pc
	@echo 'Libs: -L$${libdir} -lid3tag' >> $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/id3tag.pc
	@echo 'Cflags: -I$${includedir}' >> $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/id3tag.pc
