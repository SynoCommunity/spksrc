SPK_NAME = mono
SPK_VERS = 6.12.0.199
SPK_REV = 21
SPK_ICON = src/mono.png

DEPENDS = cross/mono

# Although qoriq can be compiled successfully it won't run as classic floating point unit not available
# For details see: https://github.com/SynoCommunity/spksrc/issues/3470#issuecomment-469391052
UNSUPPORTED_ARCHS = $(PPC_ARCHS)

MAINTAINER = hgy59
DESCRIPTION = Cross platform, open source .NET development framework.
DISPLAY_NAME = Mono
STARTABLE = no
CHANGELOG = "Update to version 6.12.0.199."

HOMEPAGE = https://mono-project.com
LICENSE  = https://www.mono-project.com/docs/faq/licensing

SERVICE_SETUP = src/service-setup.sh

POST_STRIP_TARGET = mono_extra_install

MONO_NATIVE_INSTALL = $(realpath $(WORK_DIR)/../../../native/mono/work-native/install)

SPK_COMMANDS = bin/mono bin/mcs bin/gacutil bin/gacutil2 bin/makecert

include ../../mk/spksrc.spk.mk

.PHONY: mono_extra_install
mono_extra_install:
	@install -m 755 -d $(STAGING_DIR)/lib $(STAGING_DIR)/etc/mono $(STAGING_DIR)/bin $(STAGING_DIR)/var
	@install -m 755 src/update_ca_certificates.sh       $(STAGING_DIR)/var/
	@cp -nR $(MONO_NATIVE_INSTALL)/usr/local/lib        $(STAGING_DIR)/
	@cp -nR $(MONO_NATIVE_INSTALL)/usr/local/etc/mono   $(STAGING_DIR)/etc/
	@cp -nR $(MONO_NATIVE_INSTALL)/usr/local/bin        $(STAGING_DIR)/
