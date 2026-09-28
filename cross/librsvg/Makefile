PKG_NAME = librsvg
PKG_VERS = 2.62.4
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.gnome.org/sources/librsvg/$(word 1, $(subst ., ,$(PKG_VERS))).$(word 2, $(subst ., ,$(PKG_VERS)))
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/cairo cross/glib cross/pango cross/gdk-pixbuf cross/libxml2

# pango
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)
UNSUPPORTED_ARCHS_TCVERSION = x86-5.2

HOMEPAGE = https://wiki.gnome.org/Projects/LibRsvg
COMMENT  = A library to render SVG images to Cairo surfaces.
LICENSE  = LGPLv2.1

CONFIGURE_ARGS += -Dintrospection=disabled
CONFIGURE_ARGS += -Dpixbuf-loader=disabled
CONFIGURE_ARGS += -Ddocs=disabled
CONFIGURE_ARGS += -Dvala=disabled
CONFIGURE_ARGS += -Dtests=false
CONFIGURE_ARGS += -Dtriplet=$(RUST_TARGET)

# cargo-cbuild (for the C library) is not packaged anywhere: install the
# pinned release with the rustup toolchain's cargo, as other network-at-
# build-time Rust tooling in this tree already does. The assignment must
# precede the includes: extract.mk wires the hook when parsed.
POST_EXTRACT_TARGET = librsvg_post_extract

# cargo-cbuild lands in CARGO_HOME/bin, which meson setup must have on
# PATH to find (the framework RUN env does not provide it).
ENV += PATH=$(CARGO_HOME)/bin:$(PATH)

# common.mk must precede env-rust.mk: the RUST_TARGET arch map below
# evaluates arch groups at parse time, before cross-meson.mk runs.
include ../../mk/spksrc.common.mk
include ../../mk/spksrc.cross/env-rust.mk
include ../../mk/spksrc.cross-meson.mk

.PHONY: librsvg_post_extract
librsvg_post_extract:
	# cargo-c with vendored OpenSSL: immune to host OpenSSL layout
	# differences (the framework PKG_CONFIG_LIBDIR hides the host
	# OpenSSL from build scripts, and multiarch header placement
	# varies between images).
	# This builds a HOST tool, so run it under a clean env (env -i)
	# with only host essentials allowed back in: any cross-toolchain
	# redirection (cross CC, target LINKER/RUSTFLAGS, staging
	# pkg-config) would otherwise leak into the host build.
	# Mirrors the framework's own host-tool isolation in depend.mk.
	@$(RUN) env -i PATH="$(CARGO_HOME)/bin:/usr/bin:/bin" HOME="$(HOME)" CARGO_HOME="$(CARGO_HOME)" RUSTUP_HOME="$(RUSTUP_HOME)" cargo install cargo-c --locked --version 0.10.10 --features vendored-openssl
