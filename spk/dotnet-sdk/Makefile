SPK_NAME = dotnet-sdk
SPK_VERS = 5.0.8
SPK_REV = 1
SPK_ICON = src/dotnet.png

MAINTAINER = SynoCommunity
DESCRIPTION = .NET SDK
DISPLAY_NAME = .NET SDK
STARTABLE = no
CHANGELOG = "Initial version"

HOMEPAGE = https://dotnet.microsoft.com/
LICENSE  = https://github.com/dotnet/core/blob/master/LICENSE.TXT

SERVICE_SETUP = src/service-setup.sh

SPK_COMMANDS = dotnet

PRE_COPY_TARGET = dotnet_extra_install
include ../../mk/spksrc.spk.mk

dotnet_extra_install:
	install -m 755 -d $(STAGING_DIR)
	install -m 755 -d $(INSTALL_DIR)/var/packages/$(SPK_NAME)/target
	cd $(STAGING_DIR)/ && wget "https://dotnet.microsoft.com/download/dotnet-core/scripts/v1/dotnet-install.sh"
	install -m 755 $(STAGING_DIR)/dotnet-install.sh $(INSTALL_DIR)/var/packages/$(SPK_NAME)/target/dotnet-install.sh
