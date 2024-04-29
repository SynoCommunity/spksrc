PKG_NAME = mono
PKG_VERS = 5.8.0.108
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.mono-project.com/sources/mono
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = native/mono_58

HOMEPAGE = https://www.mono-project.com
COMMENT  = Cross platform, open source .NET development framework.
LICENSE  = https://www.mono-project.com/docs/faq/licensing

# Although qoriq can be compiled successfully it won't run as classic floating point unit not available
# For details see: https://github.com/SynoCommunity/spksrc/issues/3470#issuecomment-469391052
UNSUPPORTED_ARCHS = $(PPC_ARCHS)
GNU_CONFIGURE = 1

# force building with BTLS
# needed for platforms compiling with gcc < 4.8
# patches/001-add-boringssl-alignas-support.patch adds the necessary compatibility
CONFIGURE_ARGS = --enable-btls
CONFIGURE_ARGS += --disable-dependency-tracking
CONFIGURE_ARGS += --disable-static
CONFIGURE_ARGS += --without-mcs-docs

# Optimize compilation for size
ADDITIONAL_CFLAGS = -Os

include ../../mk/spksrc.cross-cc.mk
