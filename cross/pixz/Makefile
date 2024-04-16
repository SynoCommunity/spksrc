PKG_NAME = pixz
PKG_REPO = https://github.com/vasi/$(PKG_NAME)

PKG_VERS = 1.0.7
# above will break cross-compile https://github.com/vasi/pixz/issues/67
#  - patch: https://github.com/vasi/pixz/commit/4ddfdca8416a008819d08d14d6a6f4796aef7857
# or should we pull from master? no release in almost 4 years
#PKG_VERS = d0e61be32968b2c6a532612b4080dee656ce5db6
#PKG_DIST_SITE = $(PKG_REPO)/archive
#PKG_EXT = tar.gz
#PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)

PKG_DIST_SITE = $(PKG_REPO)/releases/download/v$(PKG_VERS)
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)

PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

COMMENT = Parallel, indexed xz compressor
HOMEPAGE = $(PKG_REPO)
LICENSE = FreeBSD 2-Clause "Simplified"

DEPENDS =  cross/xz
DEPENDS += cross/libarchive

PATCHES_LEVEL = 1

PRE_CONFIGURE_TARGET = pixz_pre_configure
GNU_CONFIGURE = 1
CONFIGURE_ARGS += --without-manpage

include ../../mk/spksrc.cross-cc.mk

.PHONY: pixz_pre_configure
# must rebuild configure after patching configure.ac
pixz_pre_configure:
	@$(RUN) autoreconf -fi
# below only in gh/source archive; not release
#	@$(RUN) ./autogen.sh
