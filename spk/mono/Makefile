SPK_NAME = mono
SPK_VERS = 5.20.1.34
SPK_REV = 17
SPK_ICON = src/mono.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = hg59
DESCRIPTION = Cross platform, open source .NET development framework
DISPLAY_NAME = Mono
STARTABLE = no
CHANGELOG = "1. Update to version 5.20.1.34<br/>2. Fix workaround for ARMv5 (88f628x archs)"

HOMEPAGE = https://mono-project.com
LICENSE  = https://www.mono-project.com/docs/faq/licensing

SERVICE_SETUP = src/service-setup.sh

POST_STRIP_TARGET = mono_extra_install

MONO_NATIVE_INSTALL = $(WORK_DIR)/../../../native/$(SPK_NAME)/work-native/install

SPK_COMMANDS = bin/mono bin/mcs bin/gacutil bin/gacutil2 bin/makecert


include ../../mk/spksrc.spk.mk

.PHONY: mono_extra_install
mono_extra_install:
	install -m 755 -d $(STAGING_DIR)/lib
	cp -nR $(MONO_NATIVE_INSTALL)/usr/local/lib $(STAGING_DIR)/
	install -m 755 -d $(STAGING_DIR)/etc/mono
	cp -nR $(MONO_NATIVE_INSTALL)/usr/local/etc/mono $(STAGING_DIR)/etc/
	install -m 755 -d $(STAGING_DIR)/bin
	cp -nR $(MONO_NATIVE_INSTALL)/usr/local/bin $(STAGING_DIR)/
