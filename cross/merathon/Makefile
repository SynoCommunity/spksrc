PKG_NAME = merathon
PKG_VERS = 2.19.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/J-Dudek/merathon/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl3

# Highest rust-version among the dependencies of the server build (notify-types)
MIN_RUSTC_VERSION = 1.91

HOMEPAGE = https://github.com/J-Dudek/merathon
COMMENT = Git client with commit graph, interactive rebase, worktrees and GitHub / GitLab pull requests. This is its server edition: it serves the web interface to your browser.
LICENSE = MIT

# The crate is in a sub-directory of the repository, and the server edition has no Tauri (no window, no webkit)
RUST_SRC_DIR = $(WORK_DIR)/$(PKG_DIR)/git-client/src-tauri
CARGO_BUILD_ARGS = --locked --no-default-features --features server --bin merathon-server

ENV += OPENSSL_DIR=$(STAGING_INSTALL_PREFIX)

include ../../mk/spksrc.cross-rust.mk
