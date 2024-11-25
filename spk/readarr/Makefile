SPK_NAME = readarr
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 4
SPK_ICON = src/readarr.png

OPTIONAL_DEPENDS = cross/libstdc++
DEPENDS = cross/readarr

# Arch exclusions for dotnet 6.0
DOTNET_SERVARR_ARCHS = 1

MAINTAINER = SynoCommunity
MAINTAINER_URL = https://synocommunity.com/
DESCRIPTION  = Readarr is an ebook and audiobook collection manager for Usenet and BitTorrent users. It can monitor multiple RSS feeds for new books from your favorite authors and will grab, sort, and rename them.
CHANGELOG = "1. Update Readarr to v0.4.1.2648."
DISPLAY_NAME = Readarr
HOMEPAGE = https://readarr.com/
LICENSE  = GPLv3
LICENSE_FILE = $(WORK_DIR)/Readarr/LICENSE.md
HELPURL = https://wiki.servarr.com/readarr/troubleshooting

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8787
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

WIZARDS_DIR = src/wizard/

POST_STRIP_TARGET = readarr_extra_install

# use alternate TMPDIR as /tmp might be too small and not accessible on DSM >= 7.1.
# TMPDIR is used for readarr built in backup and update
USE_ALTERNATE_TMPDIR = 1

include ../../mk/spksrc.common.mk
ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
# dotnet requires libstdc++ version >= 6.0.22
DEPENDS += cross/libstdc++
endif

include ../../mk/spksrc.spk.mk

PACKAGE_VERSION = $(SPK_NAME_ARCH)-$(SPK_TCVERS)_$(SPK_VERS)-$(SPK_REV)
PACKAGE_AUTHOR = [SynoCommunity](https://synocommunity.com/)

.PHONY: readarr_extra_install
readarr_extra_install:
	@$(MSG) "Install config.xml and provide package_info."
	@install -m 755 -d $(STAGING_DIR)/var/.config/Readarr
	@install -m 644 src/config.xml $(STAGING_DIR)/var/.config/Readarr/config.xml
	@echo "PackageVersion=$(PACKAGE_VERSION)\nPackageAuthor=$(PACKAGE_AUTHOR)" > $(STAGING_DIR)/share/Readarr/package_info
