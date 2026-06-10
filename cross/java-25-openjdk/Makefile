PKG_NAME       = java-25-openjdk
JAVA_REPO_NAME = jdk25u
JAVA_NAME      = jdk
JAVA_RELEASE   = 9
JAVA_VERSION   = 25.0.3
PKG_VERS       = $(JAVA_VERSION).$(JAVA_RELEASE)
PKG_EXT        = tar.gz
PKG_DIST_NAME  = $(JAVA_NAME)-$(JAVA_VERSION)+$(JAVA_RELEASE).$(PKG_EXT)
PKG_DIST_SITE  = https://github.com/openjdk/jdk25u/archive
PKG_DIR        = $(JAVA_REPO_NAME)-$(JAVA_NAME)-$(JAVA_VERSION)-$(JAVA_RELEASE)

# gcc < 10.0 is not officially supported
# DSM 7.1 toolchain: WARNING: You are using gcc 8.5.0 which is older than 10.0. This is not a supported configuration.
REQUIRED_MIN_DSM = 7.2
REQUIRED_MIN_DSM = 1.3
# Java 25 does not support 32 bit architectures
# if we really want it, we could try the debian patches for 32-bit support
UNSUPPORTED_ARCHS = $(32bit_ARCHS)

# build instructions:
# https://github.com/openjdk/jdk/blob/master/doc/building.md

BUILD_DEPENDS  = native/openjdk-25
# Dependencies required at build time only:
BUILD_DEPENDS += cross/cups
BUILD_DEPENDS += cross/alsa-lib
BUILD_DEPENDS += cross/libX11
BUILD_DEPENDS += cross/libXrender
BUILD_DEPENDS += cross/libXrandr
BUILD_DEPENDS += cross/libXtst
BUILD_DEPENDS += cross/libXt

# Dependencies used as system dependencies:
DEPENDS  = cross/alsa-lib
DEPENDS += cross/fontconfig
DEPENDS += cross/zlib
DEPENDS += cross/libpng
DEPENDS += cross/libjpeg
DEPENDS += cross/giflib
DEPENDS += cross/lcms2

HOMEPAGE = https://openjdk.org/projects/jdk/25/
COMMENT  = OpenJDK 25 is the open-source reference implementation of version 25 of the Java SE Platform as specified by JSR 396 in the Java Community Process.
LICENSE  = GPLv2 with the Classpath Exception

PRE_CONFIGURE_TARGET = java-25-openjdk_pre_configure
INSTALL_TARGET       = java-25-openjdk_install

CONFIGURE_ARGS  = --openjdk-target=$(TC_TARGET)
CONFIGURE_ARGS += --with-boot-jdk=$(WORK_DIR)/../../../native/openjdk-25/work-native/jdk-25
CONFIGURE_ARGS += --with-version-build=$(JAVA_RELEASE)
CONFIGURE_ARGS += --with-version-pre=
CONFIGURE_ARGS += --with-version-opt=LTS
CONFIGURE_ARGS += --with-native-debug-symbols=none
CONFIGURE_ARGS += --prefix=$(INSTALL_PREFIX)
CONFIGURE_ARGS += --with-zlib=system
CONFIGURE_ARGS += --with-libjpeg=system
CONFIGURE_ARGS += --with-giflib=system
CONFIGURE_ARGS += --with-libpng=system
CONFIGURE_ARGS += --with-lcms=system
CONFIGURE_ARGS += --with-alsa=$(INSTALL_DIR)/$(INSTALL_PREFIX)
CONFIGURE_ARGS += --with-stdc++lib=dynamic
CONFIGURE_ARGS += --disable-javac-server
CONFIGURE_ARGS += --disable-warnings-as-errors
CONFIGURE_ARGS += --with-cups=$(INSTALL_DIR)/$(INSTALL_PREFIX)
CONFIGURE_ARGS += --with-fontconfig=$(INSTALL_DIR)/$(INSTALL_PREFIX)
CONFIGURE_ARGS += --with-freetype=system
CONFIGURE_ARGS += --with-freetype-include=$(INSTALL_DIR)/$(INSTALL_PREFIX)/include/freetype2
CONFIGURE_ARGS += --with-freetype-lib=$(INSTALL_DIR)/$(INSTALL_PREFIX)/lib
CONFIGURE_ARGS += --with-extra-cflags="$(CFLAGS) -fno-stack-protector -Wno-deprecated-declarations"
CONFIGURE_ARGS += --with-extra-cxxflags="$(CPPFLAGS) -fno-stack-protector -Wno-deprecated-declarations"
CONFIGURE_ARGS += --with-extra-ldflags="$(LDFLAGS) -Xlinker -z -Xlinker relro -Xlinker -Bsymbolic-functions"

# Disable all GUI related
CONFIGURE_ARGS += --enable-headless-only
# customize for SynoCommunity
CONFIGURE_ARGS += --with-vendor-name=SynoCommunity
CONFIGURE_ARGS += --with-vendor-url=https://synocommunity.com/package/java-25-openjdk
CONFIGURE_ARGS += --with-vendor-bug-url=https://github.com/SynoCommunity/spksrc/issues
CONFIGURE_ARGS += --with-vendor-vm-bug-url=https://github.com/SynoCommunity/spksrc/issues

# arguments not taken from environment
CONFIGURE_ARGS += READELF=$(TC_PATH)/$(TC_PREFIX)readelf
CONFIGURE_ARGS += AR=$(TC_PATH)/$(TC_PREFIX)ar
CONFIGURE_ARGS += STRIP=$(TC_PATH)/$(TC_PREFIX)strip
CONFIGURE_ARGS += NM=$(TC_PATH)/$(TC_PREFIX)nm
CONFIGURE_ARGS += OBJCOPY=$(TC_PATH)/$(TC_PREFIX)objcopy
CONFIGURE_ARGS += OBJDUMP=$(TC_PATH)/$(TC_PREFIX)objdump

# Build image twice, second time with newly built JDK
COMPILE_MAKE_OPTIONS += jdk-image

# debian patches
# https://udd.debian.org/patches.cgi?src=openjdk-25&version=25.0.3%2B9-2~deb13u1
PATCHES_LEVEL = 1

# Filter out any -jN since java's configure will autodetect number of CPU's
# Use make JOBS=N to set number of CPU's in this package
DISABLE_PARALLEL_MAKE = 1
COMPILE_MAKE_OPTIONS += JOBS=$(NCPUS)

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --with-abi-profile=aarch64
# remove targets not created for aarch64
PLIST_TRANSFORM = sed -e '/lib\/libjsvml/d' -e '/lib\/libsimdsort/d' -e '/lib\/server\/classes/d'
else
# remove targets not created for x64
PLIST_TRANSFORM = sed -e '/lib\/libsleef/d'
endif

.PHONY: java-25-openjdk_pre_configure
java-25-openjdk_pre_configure:
	@$(MSG) "- Make configure script executable"
	@cd $(WORK_DIR)/$(PKG_DIR) && chmod +x ./configure

JDK_IMAGE_DIR=$(WORK_DIR)/$(PKG_DIR)/build/linux-*-server-release/images/jdk
.PHONY: java-25-openjdk_install
java-25-openjdk_install:
	@$(MSG) "- Install jdk"
	@mkdir -p $(STAGING_INSTALL_PREFIX)/jvm/openjdk-$(JAVA_VERSION)/
	@cp -rpf $(JDK_IMAGE_DIR)/* $(STAGING_INSTALL_PREFIX)/jvm/openjdk-$(JAVA_VERSION)/
	@$(MSG) "- Link binaries into bin folder"
	@cd $(STAGING_INSTALL_PREFIX)/bin && ln -sf ../jvm/openjdk-$(JAVA_VERSION)/bin/* .
	@$(MSG) "- Add license files"
	@cp -pf $(WORK_DIR)/$(PKG_DIR)/LICENSE                   $(STAGING_INSTALL_PREFIX)/jvm/openjdk-$(JAVA_VERSION)/
	@cp -pf $(WORK_DIR)/$(PKG_DIR)/ADDITIONAL_LICENSE_INFO   $(STAGING_INSTALL_PREFIX)/jvm/openjdk-$(JAVA_VERSION)/
	@cp -pf $(WORK_DIR)/$(PKG_DIR)/ASSEMBLY_EXCEPTION        $(STAGING_INSTALL_PREFIX)/jvm/openjdk-$(JAVA_VERSION)/
