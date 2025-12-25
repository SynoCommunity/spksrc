PKG_NAME = irssi
PKG_VERS = 1.4.5
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/irssi/irssi/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/glib cross/ncursesw cross/openssl3

HOMEPAGE = http://www.irssi.org/
COMMENT  = Irssi is a terminal based IRC client for UNIX systems. It also supports SILC and ICB protocols via plugins.
LICENSE  = GPLv2

AUTODL_NAME = autodl-irssi
AUTODL_VERS = 2.6.2
AUTODL_DIST_NAME = $(AUTODL_NAME)-v$(AUTODL_VERS).zip
AUTODL_DIST_SITE = https://github.com/autodl-community/autodl-irssi/releases/download/$(AUTODL_VERS)
AUTODL_DIST_FILE = $(DISTRIB_DIR)/$(AUTODL_DIST_NAME)
AUTODL_EXTRACT_DIR = $(WORK_DIR)/autodl-src
AUTODL_SHA256 = 7b76ca81cd84ecfd40ccfc3a671fdc201fd59720de4b5ae3ee754baa42c54294

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --without-perl

POST_DOWNLOAD_TARGET += download_autodl
POST_INSTALL_TARGET += install_autodl

include ../../mk/spksrc.cross-cc.mk

download_autodl:
	@mkdir -p "$(DISTRIB_DIR)"
	@if [ ! -f "$(AUTODL_DIST_FILE)" ]; then \
		$(MSG) "Downloading $(AUTODL_DIST_NAME)"; \
		wget --secure-protocol=TLSv1_2 --timeout=30 --tries=3 --waitretry=15 --retry-connrefused --max-redirect=20 --content-disposition --retry-on-http-error=429,500,502,503,504 -nv -O "$(AUTODL_DIST_FILE).part" "$(AUTODL_DIST_SITE)/$(AUTODL_DIST_NAME)"; \
		mv "$(AUTODL_DIST_FILE).part" "$(AUTODL_DIST_FILE)"; \
	fi
	@$(MSG) "Verifying checksum for $(AUTODL_DIST_NAME)"; \
	if ! printf '%s  %s\n' "$(AUTODL_SHA256)" "$(AUTODL_DIST_FILE)" | sha256sum -c - >/dev/null 2>&1; then \
		$(MSG) "Checksum mismatch for $(AUTODL_DIST_NAME); removing"; \
		rm -f "$(AUTODL_DIST_FILE)"; \
		exit 1; \
	fi

install_autodl:
	$(RUN) /bin/sh -c '\
	set -eu; \
	rm -rf "$(AUTODL_EXTRACT_DIR)"; \
	mkdir -p "$(AUTODL_EXTRACT_DIR)"; \
	unzip -q "$(AUTODL_DIST_FILE)" -d "$(AUTODL_EXTRACT_DIR)"; \
	install -m 0755 -d $(INSTALL_DIR)$(INSTALL_PREFIX)/share/irssi/scripts $(INSTALL_DIR)$(INSTALL_PREFIX)/share/irssi/scripts/autorun; \
	rm -rf $(INSTALL_DIR)$(INSTALL_PREFIX)/share/irssi/scripts/autodl-irssi; \
	install -m 0755 -d $(INSTALL_DIR)$(INSTALL_PREFIX)/share/irssi/scripts/autodl-irssi; \
	cp -a "$(AUTODL_EXTRACT_DIR)/AutodlIrssi" $(INSTALL_DIR)$(INSTALL_PREFIX)/share/irssi/scripts/autodl-irssi/; \
	install -m 0644 "$(AUTODL_EXTRACT_DIR)/autodl-irssi.pl" $(INSTALL_DIR)$(INSTALL_PREFIX)/share/irssi/scripts/; \
	install -m 0644 "$(AUTODL_EXTRACT_DIR)/autodl-irssi.pl" $(INSTALL_DIR)$(INSTALL_PREFIX)/share/irssi/scripts/autorun/; \
	'
