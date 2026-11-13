PKG_NAME = pocketmail
PKG_VERS = 0.1.7
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-src.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/yuwashme/pocketmail-releases/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

MIN_RUSTC_VERSION = 1.98
CARGO_BUILD_ARGS = --locked --bin synology-mail-server

HOMEPAGE = https://pocketmail.app/
COMMENT = IMAP mail storage and webmail for Synology NAS
LICENSE = MIT

include ../../mk/spksrc.cross-rust.mk
