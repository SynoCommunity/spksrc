PKG_NAME = mono
PKG_VERS_MAJOR = 5.4.1
PKG_VERS_MINOR = 6
PKG_VERS = $(PKG_VERS_MAJOR).$(PKG_VERS_MINOR)
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.mono-project.com/sources/mono
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = native/$(PKG_NAME)

HOMEPAGE = http://www.mono-project.com
COMMENT  = Cross platform, open source .NET development framework
LICENSE  = http://www.mono-project.com/docs/faq/licensing

REQUIRED_DSM = 5.0
UNSUPPORTED_ARCHS = $(PPC_ARCHES)
GNU_CONFIGURE = 1

# force building with BTLS
# needed for platforms compiling with gcc < 4.8
# patches/001-add-boringssl-alignas-support.patch adds the necessary compatibility
CONFIGURE_ARGS = --enable-btls

include ../../mk/spksrc.cross-cc.mk
