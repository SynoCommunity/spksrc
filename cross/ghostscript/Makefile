PKG_NAME = ghostscript
PKG_REALNAME = ghostpdl
PKG_VERS = 10.05.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_REALNAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs$(subst .,,$(PKG_VERS))
PKG_DIR = $(PKG_REALNAME)-$(PKG_VERS)

# pngrutil.c:(.text+0x3436): undefined reference to `png_init_filter_functions_neon'
UNSUPPORTED_ARCHS = comcerto2k

# ghostscript is almost self contained (and statically linked)
DEPENDS = cross/fontconfig

HOMEPAGE = https://ghostscript.com
COMMENT  = Ghostscript is an interpreter for the PostScript® language and PDF files.
LICENSE  = AGPL 3.0

GNU_CONFIGURE = 1

# tesseract integration requires c++17, but fails to build...
CONFIGURE_ARGS += --without-tesseract

include ../../mk/spksrc.archs.mk
ifeq ($(findstring $(ARCH),comcerto2k),$(ARCH))
CONFIGURE_ARGS += --disable-neon
else ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
# force cross compile
CONFIGURE_ARGS += --build=x86_64-pc-linux-gnu
endif

include ../../mk/spksrc.cross-cc.mk
