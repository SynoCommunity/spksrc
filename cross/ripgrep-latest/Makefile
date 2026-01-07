PKG_NAME = ripgrep
PKG_VERS = 15.1.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/BurntSushi/ripgrep/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/pcre2

# powerpc archs (except qoriq) are not supported
UNSUPPORTED_ARCHS  = $(OLD_PPC_ARCHS) 
# Rust edition2024 required (rustc >= 1.85)
UNSUPPORTED_ARCHS += $(ARMv5_ARCHS) $(PPC_ARCHS)
# asm error:
UNSUPPORTED_ARCHS_TCVERSION = evansport-6.2.4

HOMEPAGE = https://github.com/BurntSushi/ripgrep
COMMENT  = ripgrep recursively searches directories for a regex pattern.
LICENSE  = public domain/Unlicense

include ../../mk/spksrc.common.mk
ifeq ($(call version_le, $(TC_GCC), 5.0),1)
# upstream/src/pcre2_script_run.c - error: .... only allowed in C99 or C11 mode
ADDITIONAL_CFLAGS = -std=c11
endif

CARGO_BUILD_ARGS = --locked
CARGO_BUILD_ARGS += --features pcre2

# let rg find libpcre2-* at runtime
ENV += RUSTFLAGS="-Clink-arg=-Wl,--rpath,$(INSTALL_PREFIX)/lib -Clink-arg=-Wl,--rpath-link,$(STAGING_INSTALL_PREFIX)/lib"  

include ../../mk/spksrc.cross-rust.mk
