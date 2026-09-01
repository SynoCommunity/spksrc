PKG_NAME = libiconv
PKG_VERS = 1.19
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/libiconv
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.gnu.org/software/libiconv
COMMENT  = GNU libiconv provides an implementation of the iconv() function and the iconv program for character set conversion. For use on systems which don't have one, or whose implementation cannot convert from/to Unicode. 
LICENSE  = GNU GPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static
ADDITIONAL_CFLAGS = -O

POST_INSTALL_TARGET = libiconv_pc

include ../../mk/spksrc.cross-cc.mk

# libiconv does not install a pkg-config file
# Required for packages that depend on cross/libarchive, e.g. pixz
PHONY: libiconv_pc
libiconv_pc:
	@mkdir -p $(STAGING_INSTALL_PREFIX)/lib/pkgconfig
	@( \
		echo "prefix=$(INSTALL_PREFIX)"; \
		echo "exec_prefix=\$${prefix}"; \
		echo "libdir=\$${exec_prefix}/lib"; \
		echo "includedir=\$${prefix}/include"; \
		echo ""; \
		echo "Name: iconv"; \
		echo "Description: character set conversion library"; \
		echo "Version: $(PKG_VERS)"; \
		echo "Cflags: -I\$${includedir}"; \
		echo "Libs: -L\$${libdir} -liconv"; \
	) > $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/iconv.pc
