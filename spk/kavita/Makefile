SPK_NAME = kavita
SPK_VERS = 0.9.0
SPK_REV = 16
SPK_ICON = src/kavita.png

DEPENDS = cross/kavita

# Arch exclusions for dotnet
DOTNET_CORE_ARCHS = 1

# Kavita v0.8.9 updated to .NET 10 and requires glibc 2.27 which is not available in DSM 7.1 and SRM 1.2
REQUIRED_MIN_DSM = 7.2
REQUIRED_MIN_SRM = 1.3

MAINTAINER = SynoCommunity
MAINTAINER_URL = https://synocommunity.com/
DESCRIPTION  = Kavita is a fast, feature rich, cross platform reading server. Built with a focus for being a full solution for all your reading needs.
CHANGELOG = "Update Kavita to v0.9.0"
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

POST_STRIP_TARGET = kavita_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: kavita_extra_install
kavita_extra_install:
	@$(MSG) "Install appsettings.json."
	@install -m 755 -d $(STAGING_DIR)/var/config
	@install -m 644 src/appsettings.json $(STAGING_DIR)/var/config/appsettings.json
