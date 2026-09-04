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
# include support for extra encodings
CONFIGURE_ARGS += --enable-extra-encodings
ADDITIONAL_CFLAGS = -O

ICONV_PC = $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/iconv.pc
POST_INSTALL_TARGET = $(ICONV_PC)

include ../../mk/spksrc.cross-cc.mk

# libiconv does not install a pkg-config file
# Required for packages that depend on cross/libarchive, e.g. pixz
$(ICONV_PC):
	@$(MSG) - Creating pkgconfig $(notdir $@)
	@install -d $(dir $@)
	@printf 'prefix=$(INSTALL_PREFIX)\n' > $@
	@printf 'exec_prefix=$${prefix}\n' >> $@
	@printf 'libdir=$${exec_prefix}/lib\n' >> $@
	@printf 'includedir=$${prefix}/include\n' >> $@
	@printf '\n' >> $@
	@printf 'Name: iconv\n' >> $@
	@printf 'Description: character set conversion library\n' >> $@
	@printf 'Version: $(PKG_VERS)\n' >> $@
	@printf 'Cflags: -I$${includedir}\n' >> $@
	@printf 'Libs: -L$${libdir} -liconv\n' >> $@
