PKG_NAME = pngquant
PKG_VERS = 3.0.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/kornelski/pngquant/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# seems to be the same bug as in former cross/bat (see #6052)
DEPENDS = cross/zlib-ng
# with zlib dependency, there is a linker error
#DEPENDS += cross/libpng
DEPENDS += cross/libimagequant-source

HOMEPAGE = https://pngquant.org/
COMMENT  = pngquant is a command-line utility and a library for lossy compression of PNG images.
LICENSE  = GPL

GNU_CONFIGURE = 1
ADDITIONAL_CFLAGS = -O3 -std=c11

PRE_COMPILE_TARGET = pngquant_pre_compile

include ../../mk/spksrc.cross-rust.mk

# The archive of pngquant source does not contain libimagequant.
# libimagequant is linked into pngquant source as git submodule.
# Instead of creating a pngquant source package that includes the submodule,
# we created a package cross/libimagequant-source that contains the source.
# To build pngquant, we just have to link the source of libimagequant
# into the pngquant source before building
LIBIMAGEQUANT_SOURCE_FOLDER = $(dir $(wildcard $(WORK_DIR)/libimagequant-*/))
SUBMODULE_FOLDER = $(WORK_DIR)/$(PKG_DIR)/lib

.PHONY: pngquant_pre_compile
pngquant_pre_compile:
	@$(MSG) "Link libimagequant '$(LIBIMAGEQUANT_SOURCE_FOLDER)' into folder '$(SUBMODULE_FOLDER)'"
	@rm -rf $(SUBMODULE_FOLDER)
	@ln -sf $(LIBIMAGEQUANT_SOURCE_FOLDER) $(SUBMODULE_FOLDER)
