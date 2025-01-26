PKG_NAME = java-21-openjdk
JAVA_REPO_NAME = jdk21u
JAVA_NAME = jdk
JAVA_RELEASE = 11
JAVA_VERSION = 21.0.5
PKG_VERS = $(JAVA_VERSION).$(JAVA_RELEASE)
PKG_EXT = tar.gz
PKG_DIST_NAME = $(JAVA_NAME)-$(JAVA_VERSION)+$(JAVA_RELEASE).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/openjdk/jdk21u/archive
PKG_DIR = $(JAVA_REPO_NAME)-$(JAVA_NAME)-$(JAVA_VERSION)-$(JAVA_RELEASE)

# build instructions:
# https://openjdk.java.net/groups/build/doc/building.html

BUILD_DEPENDS = native/openjdk-21
# Dependencies required at build time only:
BUILD_DEPENDS += cross/cups
BUILD_DEPENDS += cross/alsa-lib
BUILD_DEPENDS += cross/libX11
BUILD_DEPENDS += cross/libXrender
BUILD_DEPENDS += cross/libXrandr
BUILD_DEPENDS += cross/libXtst
BUILD_DEPENDS += cross/libXt

# REMARKS:
# for a (currently) unknown reason, building in the cross folder fails
# - it does not find system libraries like libjpeg, libpng, ...
# but building as package dependency in the spk folder works.

# Dependencies used as system dependencies:
DEPENDS  = cross/alsa-lib
DEPENDS += cross/fontconfig
DEPENDS += cross/zlib
DEPENDS += cross/libpng
DEPENDS += cross/libjpeg
DEPENDS += cross/giflib
DEPENDS += cross/lcms2

HOMEPAGE = https://openjdk.org/projects/jdk/21/
COMMENT  = OpenJDK 21 is the open-source reference implementation of version 21 of the Java SE Platform as specified by JSR 396 in the Java Community Process.
LICENSE  = GPLv2 with the Classpath Exception

PRE_CONFIGURE_TARGET = java-21-openjdk_pre_configure
PRE_COMPILE_TARGET = java-21-openjdk_pre_compile
POST_INSTALL_TARGET = java-21-openjdk_post_install

CONFIGURE_ARGS  = --openjdk-target=$(TC_TARGET)
CONFIGURE_ARGS += --with-boot-jdk=$(WORK_DIR)/../../../native/openjdk-21/work-native/jdk-21
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
CONFIGURE_ARGS += --disable-manpages
CONFIGURE_ARGS += --with-cacerts-file=/etc/ssl/certs/ca-certificates.crt
CONFIGURE_ARGS += --with-cacerts-src=/etc/ssl/certs
# Disable all GUI related
CONFIGURE_ARGS += --enable-headless-only
# customize for SynoCommunity
CONFIGURE_ARGS += --with-vendor-name=SynoCommunity
CONFIGURE_ARGS += --with-vendor-url=https://synocommunity.com/package/java-21-openjdk
CONFIGURE_ARGS += --with-vendor-bug-url=https://github.com/SynoCommunity/spksrc/issues
CONFIGURE_ARGS += --with-vendor-vm-bug-url=https://github.com/SynoCommunity/spksrc/issues

# arguments not taken from environment
CONFIGURE_ARGS += READELF=$(READELF)
CONFIGURE_ARGS += AR=$(AR)
CONFIGURE_ARGS += STRIP=$(STRIP)
CONFIGURE_ARGS += NM=$(TC_PATH)/$(TC_PREFIX)nm
CONFIGURE_ARGS += OBJCOPY=$(OBJCOPY)
CONFIGURE_ARGS += OBJDUMP=$(OBJDUMP)

# Build images twice, second time with newly built JDK
COMPILE_MAKE_OPTIONS += product-images

# debian patches
# https://udd.debian.org/patches.cgi?src=openjdk-21&version=21.0.5%2B11-1
PATCHES_LEVEL = 1

# Filter out any -jN since java's configure will autodetect number of CPU's
# Use make JOBS=N to set number of CPU's in this package
DISABLE_PARALLEL_MAKE = 1
COMPILE_MAKE_OPTIONS += JOBS=$(NCPUS)

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
# force cross compilation
CONFIGURE_ARGS += --build=x86_64-pc-linux-gnu
PLIST_TRANSFORM = sed -e '/lib\/libjsvml/d' -e '/lib\/server\/classes/d' -e '/jmods\/jdk.internal.vm/d'

# ABI profile for ARM builds:
#   arm-vfp-sflt, arm-vfp-hflt, arm-sflt, armv5-vfp-sflt, armv6-vfp-hflt, aarch64
else ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --with-abi-profile=aarch64
PLIST_TRANSFORM = sed -e '/lib\/libjsvml/d' -e '/lib\/server\/classes/d'
else ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --with-abi-profile=arm-vfp-hflt
PLIST_TRANSFORM = sed -e '/lib\/libjsvml/d' -e '/lib\/server\/classes/d' -e '/jmods\/jdk.internal.vm/d'
endif

.PHONY: java-21-openjdk_pre_configure
java-21-openjdk_pre_configure:
	@$(MSG) "- Make configure script executable"
	@cd $(WORK_DIR)/$(PKG_DIR) && chmod +x ./configure

.PHONY: java-21-openjdk_pre_compile
java-21-openjdk_pre_compile:
	@$(MSG) "- Force openjdk to install into the package install folder"
	@sed -i -e "s|\$$(INSTALL_PREFIX)|$(STAGING_INSTALL_PREFIX)|g" $(WORK_DIR)/$(PKG_DIR)/make/Install.gmk

.PHONY: java-21-openjdk_post_install
java-21-openjdk_post_install:
	@$(MSG) "- Link binaries into bin folder"
	@cd $(STAGING_INSTALL_PREFIX)/bin && ln -sf ../jvm/openjdk-$(JAVA_VERSION)/bin/* .
	@$(MSG) "- Add license files"
	@cp -pf $(WORK_DIR)/$(PKG_DIR)/LICENSE                   $(STAGING_INSTALL_PREFIX)/jvm/openjdk-$(JAVA_VERSION)/
	@cp -pf $(WORK_DIR)/$(PKG_DIR)/ADDITIONAL_LICENSE_INFO   $(STAGING_INSTALL_PREFIX)/jvm/openjdk-$(JAVA_VERSION)/
	@cp -pf $(WORK_DIR)/$(PKG_DIR)/ASSEMBLY_EXCEPTION        $(STAGING_INSTALL_PREFIX)/jvm/openjdk-$(JAVA_VERSION)/
