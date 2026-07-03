SPK_NAME = mono
SPK_VERS = 5.8.0.108
SPK_REV = 11
SPK_ICON = src/mono.png

DEPENDS = cross/mono_58

REQUIRED_MIN_DSM = 5.0

# Although qoriq can be compiled successfully it won't run as classic floating point unit not available
# For details see: https://github.com/SynoCommunity/spksrc/issues/3470#issuecomment-469391052
UNSUPPORTED_ARCHS = $(PPC_ARCHS)

MAINTAINER = SynoCommunity
DESCRIPTION = Cross platform, open source .NET development framework.
DISPLAY_NAME = Mono
STARTABLE = no
CHANGELOG = "Update to 5.8.0.108 (Release)"

HOMEPAGE = https://mono-project.com
LICENSE  = https://www.mono-project.com/docs/faq/licensing

SERVICE_SETUP = src/service-setup.sh

POST_STRIP_TARGET = mono_extra_install
PRE_COPY_TARGET = mono_pre_copy

MONO_NATIVE_INSTALL = $(realpath $(WORK_DIR)/../../../native/mono_58/work-native/install)

SPK_COMMANDS = bin/mono bin/mcs bin/gacutil bin/gacutil2 bin/makecert

include ../../mk/spksrc.spk.mk

.PHONY: mono_extra_install
mono_extra_install:
	install -m 755 -d $(STAGING_DIR)/lib $(STAGING_DIR)/etc/mono $(STAGING_DIR)/bin
	cp -nR $(MONO_NATIVE_INSTALL)/usr/local/lib $(STAGING_DIR)/
	cp -nR $(MONO_NATIVE_INSTALL)/usr/local/etc/mono $(STAGING_DIR)/etc/
	cp -nR $(MONO_NATIVE_INSTALL)/usr/local/bin $(STAGING_DIR)/

.PHONY: mono_pre_copy
mono_pre_copy: $(INSTALL_PLIST)
	# remove boehm GC references from PLIST if not built for the platform (e.g. rtd1296)
	test -f $(INSTALL_DIR)$(INSTALL_PREFIX)/bin/mono-boehm || sed -i -e '/:bin\/mono-boehm/d' -e '/:lib\/libmonoboehm/d' $(INSTALL_PLIST)
