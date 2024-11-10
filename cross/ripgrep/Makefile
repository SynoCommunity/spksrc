PKG_NAME = ripgrep
PKG_VERS = 14.1.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/BurntSushi/ripgrep/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/pcre

# powerpc archs (except qoriq) are not supported
UNSUPPORTED_ARCHS += $(OLD_PPC_ARCHS)

HOMEPAGE = https://github.com/BurntSushi/ripgrep
COMMENT  = ripgrep recursively searches directories for a regex pattern.
LICENSE  = public domain/Unlicense

include ../../mk/spksrc.common.mk
ifeq ($(call version_le, $(TC_GCC), 5.0),1)
# upstream/src/pcre2_script_run.c - error: .... only allowed in C99 or C11 mode
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
ADDITIONAL_CFLAGS = -std=c99
else
ADDITIONAL_CFLAGS = -std=c11
endif
endif

CARGO_BUILD_ARGS = --features pcre2
# let rg find libpcre2-* at runtime
ENV += RUSTFLAGS="-Clink-arg=-Wl,--rpath,$(INSTALL_PREFIX)/lib -Clink-arg=-Wl,--rpath-link,$(STAGING_INSTALL_PREFIX)/lib"  

include ../../mk/spksrc.cross-rust.mk
