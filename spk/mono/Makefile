SPK_NAME = mono
SPK_VERS = 5.18.0.225
SPK_REV = 12
SPK_ICON = src/mono.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = Cross platform, open source .NET development framework
DISPLAY_NAME = Mono
STARTABLE = no
CHANGELOG = "Update to 5.18.0.225 (Pre-Release)"

HOMEPAGE = http://mono-project.com
LICENSE  = http://www.mono-project.com/docs/faq/licensing

SERVICE_SETUP = src/service-setup.sh

POST_STRIP_TARGET = mono_extra_install
PRE_COPY_TARGET = mono_pre_copy

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

.PHONY: mono_pre_copy
mono_pre_copy: $(INSTALL_PLIST)
	# remove boehm GC references from PLIST if it isn't available on the platform (e.g. rtd1296)
	test -f $(INSTALL_DIR)$(INSTALL_PREFIX)/bin/mono-boehm || sed -i -e '/:bin\/mono-boehm/d' -e '/:lib\/libmonoboehm/d' $(INSTALL_PLIST)
        # remove btls library from PLIST if it isn't available on the platform (e.g. 88f6281)
	test -f $(INSTALL_DIR)$(INSTALL_PREFIX)/lib/libmono-btls-shared.so || sed -i -e '/:lib\/libmono-btls-shared.so/d' $(INSTALL_PLIST)
