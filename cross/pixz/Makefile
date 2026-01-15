PKG_NAME = pixz
PKG_VERS = 1.0.7
# above will break cross-compile https://github.com/vasi/pixz/issues/67
#  - patch: https://github.com/vasi/pixz/commit/4ddfdca8416a008819d08d14d6a6f4796aef7857
# or should we pull from master? no release in almost 4 years
#PKG_VERS = d0e61be32968b2c6a532612b4080dee656ce5db6
#PKG_EXT = tar.gz
#PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
#PKG_DIST_SITE = https://github.com/vasi/pixz/archive
#PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)

PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/vasi/pixz/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =  cross/xz
DEPENDS += cross/libarchive

COMMENT = Parallel, indexed xz compressor
HOMEPAGE = https://github.com/vasi/pixz
LICENSE = 2-Clause BSD

PATCHES_LEVEL = 1

PRE_CONFIGURE_TARGET = pixz_pre_configure
GNU_CONFIGURE = 1

CONFIGURE_ARGS = --without-manpage

# avoid check for src/pixz.1 with AC_CHECK_FILE (can't be used when cross-compiling)
CONFIGURE_ARGS += ac_cv_file_src_pixz_1=no

include ../../mk/spksrc.cross-cc.mk

.PHONY: pixz_pre_configure
pixz_pre_configure:
	@$(MSG) Rebuild configure due to patched configure.ac
	@$(RUN) autoreconf -fi
