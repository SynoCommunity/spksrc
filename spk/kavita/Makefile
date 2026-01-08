SPK_NAME = kavita
SPK_VERS = 0.8.8.3
SPK_REV = 14
SPK_ICON = src/kavita.png

DEPENDS = cross/kavita cross/libe_sqlite3

# Arch exclusions for dotnet
DOTNET_CORE_ARCHS = 1

# Requires glibc 2.28 which is not available in DSM 6 and SRM 1.2
REQUIRED_MIN_DSM = 7.0
REQUIRED_MIN_SRM = 1.3

MAINTAINER = SynoCommunity
MAINTAINER_URL = https://synocommunity.com/
DESCRIPTION  = Kavita is a fast, feature rich, cross platform reading server. Built with a focus for being a full solution for all your reading needs.
CHANGELOG = "Update Kavita to v0.8.8.3"
DISPLAY_NAME = Kavita
HOMEPAGE = https://www.kavitareader.com/
LICENSE  = GPLv3
LICENSE_FILE = $(WORK_DIR)/Kavita/LICENSE.txt
HELPURL = https://wiki.kavitareader.com/

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 5500
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

WIZARDS_DIR = src/wizard/

POST_STRIP_TARGET = kavita_custom_libe_sqlite3 kavita_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: kavita_custom_libe_sqlite3
kavita_custom_libe_sqlite3:
	@$(MSG) "Replace libe_sqlite3 with version built for DSM"
	mv -f $(STAGING_DIR)/lib/libe_sqlite3.so $(STAGING_DIR)/share/libe_sqlite3.so

.PHONY: kavita_extra_install
kavita_extra_install:
	@$(MSG) "Install appsettings.json."
	@install -m 755 -d $(STAGING_DIR)/var/config
	@install -m 644 src/appsettings.json $(STAGING_DIR)/var/config/appsettings.json
