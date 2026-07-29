PKG_NAME = immich-geodata
PKG_VERS = 1
PKG_EXT = zip
PKG_DIST_NAME = cities500.$(PKG_EXT)
PKG_DIST_SITE = http://download.geonames.org/export/dump
# cities500.zip extracts cities500.txt to $(WORK_DIR), not a subdirectory
PKG_DIR =

HOMEPAGE = https://immich.app
COMMENT  = Geodata files for Immich reverse geocoding
LICENSE  = Various

POST_EXTRACT_TARGET = immich_geodata_post_extract
# Upstream geodata files are live datasets that change regularly
# Skip checksum verification since the digests would constantly need updating
CHECKSUM_TARGET = nop
INSTALL_TARGET = immich_geodata_install

ADMIN1_URL = http://download.geonames.org/export/dump/admin1CodesASCII.txt
ADMIN2_URL = http://download.geonames.org/export/dump/admin2Codes.txt
COUNTRIES_URL = https://github.com/nvkelso/natural-earth-vector/raw/master/geojson/ne_10m_admin_0_countries.geojson

include ../../mk/spksrc.cross-install.mk

.PHONY: immich_geodata_post_extract
immich_geodata_post_extract:
	@$(MSG) "Fetching additional geodata files"
	cd $(WORK_DIR)/$(PKG_DIR) && \
		wget -q $(ADMIN1_URL) && \
		wget -q $(ADMIN2_URL) && \
		wget -q $(COUNTRIES_URL)
	date -u +%Y-%m-%dT%H:%M:%S+00:00 > $(WORK_DIR)/$(PKG_DIR)/geodata-date.txt

.PHONY: immich_geodata_install
immich_geodata_install:
	@$(MSG) "Installing geodata files"
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/share/immich/geodata
	for f in cities500.txt admin1CodesASCII.txt admin2Codes.txt ne_10m_admin_0_countries.geojson geodata-date.txt; do \
		[ -f "$(WORK_DIR)/$$f" ] && install -m 644 "$(WORK_DIR)/$$f" $(STAGING_INSTALL_PREFIX)/share/immich/geodata/ ; \
	done
