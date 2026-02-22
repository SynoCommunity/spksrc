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
	@( \
		echo "prefix=$(INSTALL_PREFIX)"; \
		echo "exec_prefix=\$${prefix}"; \
		echo "libdir=\$${exec_prefix}/lib"; \
		echo "includedir=\$${prefix}/include"; \
		echo ""; \
		echo "Name: id3tag"; \
		echo "Description: ID3 tag manipulation library"; \
		echo "Version: $(PKG_VERS)"; \
		echo "Libs: -L\$${libdir} -lid3tag"; \
		echo "Cflags: -I\$${includedir}"; \
	) > $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/id3tag.pc
