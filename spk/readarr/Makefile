SPK_NAME = readarr
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 1
SPK_ICON = src/readarr.png

MAINTAINER = SynoCommunity
MAINTAINER_URL = https://readarr.com/
DESCRIPTION  = Readarr is an eBook collection manager for Usenet and BitTorrent users. It can monitor multiple RSS feeds for new books and will interface with clients and indexers to grab, sort, and rename them. It can also be configured to automatically upgrade the quality of existing files in the library when a better quality format becomes available.
CHANGELOG = "Initial SynoCommunity release."
DISPLAY_NAME = Readarr
HOMEPAGE = https://readarr.com/
LICENSE  = GPLv3
LICENSE_FILE = $(WORK_DIR)/Readarr/LICENSE.md
HELPURL = https://wiki.servarr.com/readarr/troubleshooting
SUPPORTURL = https://readarr.com/\#support

REQUIRED_DSM = 5.0

# .NET is not supported on PPC, ARM5, ARM7L and x86
UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(i686_ARCHS)

DEPENDS = cross/sqlite cross/curl cross/libstdc++ cross/$(SPK_NAME)

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8787
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

WIZARDS_DIR = src/wizard/

POST_STRIP_TARGET = readarr_extra_install

# use alternate TMPDIR as /tmp might be too small.
USE_ALTERNATE_TMPDIR = 1

include ../../mk/spksrc.spk.mk

PACKAGE_VERSION = $(SPK_NAME_ARCH)-$(SPK_TCVERS)_$(SPK_VERS)-$(SPK_REV)
PACKAGE_AUTHOR = [SynoCommunity](https://synocommunity.com/)

.PHONY: readarr_extra_install
readarr_extra_install:
	@install -m 755 -d $(STAGING_DIR)/app
	@install -m 644 src/config.xml $(STAGING_DIR)/app/config.xml
	@echo "PackageVersion=$(PACKAGE_VERSION)\nPackageAuthor=$(PACKAGE_AUTHOR)" > $(STAGING_DIR)/share/Readarr/package_info
