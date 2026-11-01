PKG_NAME = inotify-tools
PKG_VERS = 4.26.270
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/inotify-tools/inotify-tools/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# fsnotifywait defaults to fanotify, which requires Linux 2.6.36.
MIN_KERNEL_VERSION = 2.6.36
# fanotify/name_to_handle_at require glibc 2.14.
MIN_GLIBC_VERSION = 2.14

HOMEPAGE = https://github.com/inotify-tools/inotify-tools
COMMENT  = inotify-tools provides command-line programs and a C-compatible library for Linux inotify/fanotify.
LICENSE  = GPLv2

# inotify-tools 4.26 is implemented in Rust.
MIN_RUSTC_VERSION = 1.63
INSTALL_TARGET = inotify_install

include ../../mk/spksrc.cross-rust.mk

.PHONY: inotify_install
inotify_install:
	@$(MSG) "- Build and install inotify-tools"
	$(RUN) $(MAKE) CARGOFLAGS=--locked TARGET=$(RUST_TARGET) ENABLE_STATIC=0 DESTDIR=$(INSTALL_DIR) prefix=$(INSTALL_PREFIX) install
