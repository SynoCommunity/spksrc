SPK_NAME = lidarr
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 7
SPK_ICON = src/lidarr.png

MAINTAINER = Team Lidarr
MAINTAINER_URL = https://lidarr.audio/
DESCRIPTION  = Lidarr is a music collection manager for Usenet and BitTorrent users. It can monitor multiple RSS feeds for new tracks from your favorite artists and will grab, sort and rename them. It can also be configured to automatically upgrade the quality of files already downloaded when a better quality format becomes available.
CHANGELOG = "Update Lidarr to .NET"
DISPLAY_NAME = Lidarr
HOMEPAGE = https://lidarr.audio/
LICENSE  = GPLv3
LICENSE_FILE = $(WORK_DIR)/Lidarr/LICENSE.md
HELPURL = https://wiki.servarr.com/Lidarr_Troubleshooting
SUPPORTURL = https://lidarr.audio/\#support

REQUIRED_DSM = 5.0

# Mono not supported on ppc platforms. C.f. cross/mono/Makefile and references therein for details.
UNSUPPORTED_ARCHS = $(PPC_ARCHS)

OPTIONAL_DEPENDS = cross/libstdc++ cross/$(SPK_NAME) cross/$(SPK_NAME)-mono
DEPENDS = cross/sqlite 

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8686
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

WIZARDS_DIR = src/wizard/

# Mono build for unsupported .NET archs
include ../../mk/spksrc.archs.mk
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(i686_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
DEPENDS += cross/$(SPK_NAME)-mono
SERVICE_SETUP = src/service-setup-mono.sh
CHANGELOG = "no change"
SPK_DEPENDS = "mono>3.6:chromaprint>=1.5"
else
DEPENDS += cross/libstdc++ cross/$(SPK_NAME)
endif

POST_STRIP_TARGET = lidarr_extra_install

include ../../mk/spksrc.spk.mk

PACKAGE_VERSION = $(SPK_NAME_ARCH)-$(SPK_TCVERS)_$(SPK_VERS)-$(SPK_REV)
PACKAGE_AUTHOR = [Team Lidarr](https://lidarr.audio/)

.PHONY: lidarr_extra_install
lidarr_extra_install:
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/config.xml $(STAGING_DIR)/app/config.xml
	@echo "PackageVersion=$(PACKAGE_VERSION)\nPackageAuthor=$(PACKAGE_AUTHOR)" > $(STAGING_DIR)/share/Lidarr/package_info
