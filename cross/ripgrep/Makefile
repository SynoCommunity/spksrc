PKG_NAME = ripgrep
PKG_VERS = 13.0.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/BurntSushi/ripgrep/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# powerpc archs (except qoriq) are not supported
UNSUPPORTED_ARCHS += $(OLD_PPC_ARCHS)

HOMEPAGE = https://github.com/BurntSushi/ripgrep
COMMENT  = ripgrep recursively searches directories for a regex pattern.
LICENSE  = public domain/Unlicense

# Force static build when pcre2 is detected in synocli-file build environment
ENV += PCRE2_SYS_STATIC=1
CARGO_BUILD_ARGS += --features 'pcre2'

include ../../mk/spksrc.cross-rust.mk
