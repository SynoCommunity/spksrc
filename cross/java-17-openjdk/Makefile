PKG_NAME = java-17-openjdk
JAVA_REPO_NAME = jdk17u
JAVA_NAME = jdk
JAVA_RELEASE = 7
JAVA_VERSION = 17.0.16
PKG_VERS = $(JAVA_VERSION).$(JAVA_RELEASE)
PKG_EXT = tar.gz
PKG_DIST_NAME = $(JAVA_NAME)-$(JAVA_VERSION)+$(JAVA_RELEASE).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/openjdk/$(JAVA_REPO_NAME)/archive
PKG_DIR = $(JAVA_REPO_NAME)-$(JAVA_NAME)-$(JAVA_VERSION)-$(JAVA_RELEASE)

# build instructions:
# https://openjdk.java.net/groups/build/doc/building.html

BUILD_DEPENDS = native/openjdk-17
# Dependencies required at build time only:
BUILD_DEPENDS += cross/cups
BUILD_DEPENDS += cross/alsa-lib
BUILD_DEPENDS += cross/libX11
BUILD_DEPENDS += cross/libXrender

# Dependencies used as system dependencies:
DEPENDS  = cross/alsa-lib
DEPENDS += cross/fontconfig
DEPENDS += cross/zlib
DEPENDS += cross/libpng
DEPENDS += cross/libjpeg
DEPENDS += cross/giflib
DEPENDS += cross/lcms2

HOMEPAGE = https://openjdk.org/projects/jdk/17/
COMMENT  = OpenJDK 17 is the open-source reference implementation of version 17 of the Java SE Platform as specified by JSR 390 in the Java Community Process.
LICENSE  = GPLv2 with the Classpath Exception

# Make configure script executable
PRE_CONFIGURE_TARGET = java-17-openjdk_pre_configure

# Force openjdk to install into the package install folder
PRE_COMPILE_TARGET = java-17-openjdk_pre_compile

# Fix symlinks
POST_INSTALL_TARGET = java-17-openjdk_post_compile

CONFIGURE_ARGS  = --openjdk-target=$(TC_TARGET)
CONFIGURE_ARGS += --with-boot-jdk=$(WORK_DIR)/../../../native/openjdk-17/work-native/jdk-17
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
CONFIGURE_ARGS += --with-extra-cflags="$(CFLAGS) $(ADDITIONAL_CFLAGS) -fno-stack-protector -Wno-deprecated-declarations"
CONFIGURE_ARGS += --with-extra-cxxflags="$(CPPFLAGS) $(ADDITIONAL_CPPFLAGS) -fno-stack-protector -Wno-deprecated-declarations"
CONFIGURE_ARGS += --with-extra-ldflags="$(LDFLAGS) $(ADDITIONAL_LDFLAGS) -ljpeg -Xlinker -z -Xlinker relro -Xlinker -Bsymbolic-functions"
CONFIGURE_ARGS += --disable-manpages
# Disable all GUI related
CONFIGURE_ARGS += --enable-headless-only
# customize for SynoCommunity
CONFIGURE_ARGS += --with-vendor-name=SynoCommunity
CONFIGURE_ARGS += --with-vendor-url=https://synocommunity.com/package/java-17-openjdk
CONFIGURE_ARGS += --with-vendor-bug-url=https://github.com/SynoCommunity/spksrc/issues
CONFIGURE_ARGS += --with-vendor-vm-bug-url=https://github.com/SynoCommunity/spksrc/issues

# arguments not taken from environment
CONFIGURE_ARGS += READELF=$(TC_PATH)/$(TC_PREFIX)readelf
CONFIGURE_ARGS += AR=$(TC_PATH)/$(TC_PREFIX)ar
CONFIGURE_ARGS += STRIP=$(TC_PATH)/$(TC_PREFIX)strip
CONFIGURE_ARGS += NM=$(TC_PATH)/$(TC_PREFIX)nm
CONFIGURE_ARGS += OBJCOPY=$(TC_PATH)/$(TC_PREFIX)objcopy
CONFIGURE_ARGS += OBJDUMP=$(TC_PATH)/$(TC_PREFIX)objdump

# Build images twice, second time with newly built JDK
COMPILE_MAKE_OPTIONS += product-images

PATCHES_LEVEL = 1

ADDITIONAL_CFLAGS = -O2

# Filter out any -jN since java's configure will autodetect number of CPU's
# Use make JOBS=N to set number of CPU's in this package
DISABLE_PARALLEL_MAKE = 1
COMPILE_MAKE_OPTIONS += JOBS=$(NCPUS)

include ../../mk/spksrc.cross-cc.mk

ifneq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
# "Intel Short Vector Math Library (SVML)" is built for x64 only
PLIST_TRANSFORM = sed -e '/lib\/libjsvml.so/d'
endif

.PHONY: java-17-openjdk_pre_configure
java-17-openjdk_pre_configure:
	@$(MSG) "- Make configure script executable"
	@cd $(WORK_DIR)/$(PKG_DIR) && chmod +x ./configure

.PHONY: java-17-openjdk_pre_compile
# As DESTDIR is not supported we must patch the make file for make install.
java-17-openjdk_pre_compile:
	sed -i -e "s|\$$(INSTALL_PREFIX)|$(STAGING_INSTALL_PREFIX)|g" $(WORK_DIR)/$(PKG_DIR)/make/Install.gmk

.PHONY: java-17-openjdk_post_compile
java-17-openjdk_post_compile:
	@$(MSG) Link binaries into version independent bin folder
	@cd $(STAGING_INSTALL_PREFIX)/bin && ln -sf ../jvm/openjdk-$(JAVA_VERSION)/bin/* .
	@$(MSG) Install license files
	@cp -pf $(WORK_DIR)/$(PKG_DIR)/LICENSE                   $(STAGING_INSTALL_PREFIX)/jvm/openjdk-$(JAVA_VERSION)/
	@cp -pf $(WORK_DIR)/$(PKG_DIR)/ADDITIONAL_LICENSE_INFO   $(STAGING_INSTALL_PREFIX)/jvm/openjdk-$(JAVA_VERSION)/
	@cp -pf $(WORK_DIR)/$(PKG_DIR)/ASSEMBLY_EXCEPTION        $(STAGING_INSTALL_PREFIX)/jvm/openjdk-$(JAVA_VERSION)/
