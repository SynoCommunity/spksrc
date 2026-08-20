PKG_NAME = ripgrep
PKG_VERS = 14.1.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/BurntSushi/ripgrep/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# This is the last version that builds for
# - ARMv5
# - evansport for DSM < 7

DEPENDS = cross/pcre2

# must support -std=C11 or -std=C99
MIN_GCC_VERSION = 4.6

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

CARGO_BUILD_ARGS = --locked
CARGO_BUILD_ARGS += --features pcre2

include ../../mk/spksrc.cross-rust.mk
