SPK_NAME = kavita
SPK_VERS = 0.7.11.2
SPK_REV = 2
SPK_ICON = src/kavita.png

OPTIONAL_DEPENDS = cross/libstdc++
DEPENDS = cross/kavita

# Arch exclusions for dotnet 6.0
DOTNET_CORE_ARCHS = 1

MAINTAINER = SynoCommunity
MAINTAINER_URL = https://synocommunity.com/
DESCRIPTION  = Kavita is a fast, feature rich, cross platform reading server. Built with a focus for being a full solution for all your reading needs.
CHANGELOG = "Test of release upgrade"
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

POST_STRIP_TARGET = kavita_extra_install

# use alternate TMPDIR as /tmp might be too small and not accessible on DSM >= 7.1.
# TMPDIR is used for kavita built in backup and update
USE_ALTERNATE_TMPDIR = 1

include ../../mk/spksrc.common.mk
ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
# dotnet requires libstdc++ version >= 6.0.22
DEPENDS += cross/libstdc++
endif

include ../../mk/spksrc.spk.mk

.PHONY: kavita_extra_install
kavita_extra_install:
	@$(MSG) "Install appsettings.json."
	@install -m 755 -d $(STAGING_DIR)/var/config
	@install -m 644 src/appsettings.json $(STAGING_DIR)/var/config/appsettings.json
