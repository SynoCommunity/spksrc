PKG_NAME = qbt-pwhash
PKG_VERS = 1.0.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# Match qbittorrent's unsupported architectures plus 88f6281 (glibc 2.15 < required 2.16)
UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv7L_ARCHS) $(ARMv5_ARCHS)

HOMEPAGE = https://github.com/SynoCommunity/spksrc
COMMENT  = PBKDF2-SHA512 password hash generator for qBittorrent
LICENSE  = MIT

PRE_DOWNLOAD_TARGET = qbt_pwhash_create_tarball
CHECKSUM_TARGET = nop
CARGO_BUILD_ARGS = --locked

include ../../mk/spksrc.cross-rust.mk

.PHONY: qbt_pwhash_create_tarball
qbt_pwhash_create_tarball:
	@$(MSG) Creating source tarball for qbt-pwhash
	@mkdir -p $(DISTRIB_DIR)
	@if [ ! -f "$(DISTRIB_DIR)/$(PKG_DIST_NAME)" ]; then \
		rm -rf /tmp/$(PKG_NAME)-$(PKG_VERS) && \
		cp -r $(CURDIR)/src /tmp/$(PKG_NAME)-$(PKG_VERS) && \
		(cd /tmp && tar czf $(DISTRIB_DIR)/$(PKG_DIST_NAME) $(PKG_NAME)-$(PKG_VERS)) && \
		rm -rf /tmp/$(PKG_NAME)-$(PKG_VERS); \
	fi
