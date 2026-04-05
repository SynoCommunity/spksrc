PKG_NAME = pngquant
PKG_VERS = 3.0.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/kornelski/pngquant/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib
# with zlib dependency, there is a linker error
#DEPENDS += cross/libpng
DEPENDS += cross/libimagequant-source

HOMEPAGE = https://pngquant.org/
COMMENT  = pngquant is a command-line utility and a library for lossy compression of PNG images.
LICENSE  = GPL

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

include ../../mk/spksrc.common.mk

# Fails on older gcc for its internal dependencies
ifeq ($(call version_lt, $(TC_GCC), 5),1)
ADDITIONAL_CFLAGS = -O3 -std=c99
endif

# Fails with recent libz-sys version 1.1.26
# Enforce a specific libz-sys crate version
CRATE_VERSION_LIBZSYS = 1.1.25
CARGO_INSTALL_ARGS += --locked

POST_EXTRACT_TARGET = pngquant_post_extract

include ../../mk/spksrc.cross-rust.mk

# The archive of pngquant source does not contain libimagequant.
# libimagequant is linked into pngquant source as git submodule.
# Instead of creating a pngquant source package that includes the submodule,
# we created a package cross/libimagequant-source that contains the source.
# To build pngquant, we just have to link the source of libimagequant
# into the pngquant source before building
LIBIMAGEQUANT_SOURCE_FOLDER = $(dir $(wildcard $(WORK_DIR)/libimagequant-*/))
SUBMODULE_FOLDER = $(WORK_DIR)/$(PKG_DIR)/lib

.PHONY: pngquant_post_extract
pngquant_post_extract:
	@$(MSG) "Link libimagequant '$(LIBIMAGEQUANT_SOURCE_FOLDER)' into folder '$(SUBMODULE_FOLDER)'"
	@rm -rf $(SUBMODULE_FOLDER)
	@ln -sf $(LIBIMAGEQUANT_SOURCE_FOLDER) $(SUBMODULE_FOLDER)
	@cd $(WORK_DIR)/$(PKG_DIR) && \
	   CARGO_HOME=$(CARGO_HOME) cargo update libz-sys --precise $(CRATE_VERSION_LIBZSYS)
