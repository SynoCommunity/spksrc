PKG_NAME = libimagequant
PKG_VERS = 4.4.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/ImageOptim/libimagequant/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://pngquant.org/lib/
COMMENT  = Small, portable C library for high-quality conversion of RGBA images to 8-bit indexed-color (palette) images.
LICENSE  = GPLv3

# Upstream rust-version for libimagequant 4.x
MIN_RUSTC_VERSION = 1.65

INSTALL_TARGET = libimagequant_install
POST_EXTRACT_TARGET = libimagequant_post_extract

# 0.10.10 needs Rust 1.83; 0.10.9 is the newest compatible with Rust 1.82.
CARGO_C_MIN_VERSION = 0.10.9

include ../../mk/spksrc.cross-rust.mk

ENV += PATH=$(CARGO_HOME)/bin:$(PATH)

.PHONY: libimagequant_post_extract libimagequant_install

# The checked-in lock pins the graph tested with the legacy Rust toolchains.
# Regenerate it whenever PKG_VERS changes.
libimagequant_post_extract:
	@cp $(CURDIR)/src/Cargo.lock $(WORK_DIR)/$(PKG_DIR)/Cargo.lock
	@have=$$($(CARGO_HOME)/bin/cargo-cinstall --version 2>/dev/null | awk '{print $$2}' | cut -d+ -f1); \
	use= ; \
	case "$$have" in 0.10.*) \
	  [ "$$(printf '%s\n' $(CARGO_C_MIN_VERSION) "$$have" | sort -V | tail -1)" = "$$have" ] && use=1 ;; \
	esac ; \
	if [ -z "$$use" ]; then \
	  $(MSG) "Installing cargo-c >= $(CARGO_C_MIN_VERSION) (found: $${have:-none})" ; \
	  $(RUN) env -i PATH="$(CARGO_HOME)/bin:/usr/bin:/bin" HOME="$(HOME)" CARGO_HOME="$(CARGO_HOME)" RUSTUP_HOME="$(RUSTUP_HOME)" cargo install cargo-c --locked --force --version $(CARGO_C_MIN_VERSION) --features vendored-openssl ; \
	fi

libimagequant_install:
	@$(MSG) "Installing libimagequant $(PKG_VERS) with cargo-c"
	@$(RUN) cargo cinstall --locked --release --target $(RUST_TARGET) \
	  --manifest-path imagequant-sys/Cargo.toml \
	  --prefix=$(INSTALL_PREFIX) \
	  --libdir=$(INSTALL_PREFIX)/lib \
	  --includedir=$(INSTALL_PREFIX)/include \
	  --pkgconfigdir=$(INSTALL_PREFIX)/lib/pkgconfig \
	  --destdir=$(INSTALL_DIR)
