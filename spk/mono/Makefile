SPK_NAME = mono
SPK_VERS = 4.2.2.30
SPK_REV = 7
SPK_ICON = src/mono.png
BETA = 1

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = Cross platform, open source .NET development framework
DISPLAY_NAME = Mono
STARTABLE = no
CHANGELOG = "Update to 4.2.2.30"

HOMEPAGE = http://mono-project.com
LICENSE  = http://www.mono-project.com/docs/faq/licensing

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = mono_extra_install

BUSYBOX_CONFIG = usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

MONO_NATIVE_INSTALL = $(WORK_DIR)/../../../native/$(SPK_NAME)/work-native/install

include ../../mk/spksrc.spk.mk

.PHONY: mono_extra_install
mono_extra_install:
	install -m 755 -d $(STAGING_DIR)/lib
	cp -nR $(MONO_NATIVE_INSTALL)/usr/local/lib $(STAGING_DIR)/
	install -m 755 -d $(STAGING_DIR)/etc/mono
	cp -nR $(MONO_NATIVE_INSTALL)/usr/local/etc/mono $(STAGING_DIR)/etc/
	install -m 755 -d $(STAGING_DIR)/bin
	cp -nR $(MONO_NATIVE_INSTALL)/usr/local/bin $(STAGING_DIR)/
