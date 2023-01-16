SPK_NAME = mono
SPK_VERS = 5.20.1.34
SPK_REV = 18
SPK_ICON = src/mono.png

DEPENDS = cross/$(SPK_NAME)

REQUIRED_MIN_DSM = 5.0

# Although qoriq can be compiled successfully it won't run as classic floating point unit not available
# For details see: https://github.com/SynoCommunity/spksrc/issues/3470#issuecomment-469391052
UNSUPPORTED_ARCHS = $(PPC_ARCHS)

MAINTAINER = hgy59
DESCRIPTION = Cross platform, open source .NET development framework.
DISPLAY_NAME = Mono
STARTABLE = no
CHANGELOG = "1. Update to version 5.20.1.34<br/>2. Fix workaround for ARMv5 (88f628x archs)<br/>3. Remove static libraries."

HOMEPAGE = https://mono-project.com
LICENSE  = https://www.mono-project.com/docs/faq/licensing

SERVICE_SETUP = src/service-setup.sh

POST_STRIP_TARGET = mono_extra_install

MONO_NATIVE_INSTALL = $(realpath $(WORK_DIR)/../../../native/$(SPK_NAME)/work-native/install)

SPK_COMMANDS = bin/mono bin/mcs bin/gacutil bin/gacutil2 bin/makecert

include ../../mk/spksrc.spk.mk

.PHONY: mono_extra_install
mono_extra_install:
	install -m 755 -d $(STAGING_DIR)/lib $(STAGING_DIR)/etc/mono $(STAGING_DIR)/bin
	cp -nR $(MONO_NATIVE_INSTALL)/usr/local/lib $(STAGING_DIR)/
	cp -nR $(MONO_NATIVE_INSTALL)/usr/local/etc/mono $(STAGING_DIR)/etc/
	cp -nR $(MONO_NATIVE_INSTALL)/usr/local/bin $(STAGING_DIR)/
