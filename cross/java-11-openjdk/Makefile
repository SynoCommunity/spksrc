PKG_NAME = java-11-openjdk
JAVA_REPO_NAME = jdk11u
JAVA_NAME = jdk
JAVA_RELEASE = 7
JAVA_VERSION = 11.0.12
PKG_VERS = $(JAVA_VERSION).$(JAVA_RELEASE)
PKG_EXT = tar.gz
PKG_DIST_NAME = $(JAVA_NAME)-$(JAVA_VERSION)+$(JAVA_RELEASE).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/openjdk/$(JAVA_REPO_NAME)/archive/refs/tags
PKG_DIR = $(JAVA_REPO_NAME)-$(JAVA_NAME)-$(JAVA_VERSION)-$(JAVA_RELEASE)

# build instructions:
# https://openjdk.java.net/groups/build/doc/building.html

BUILD_DEPENDS = native/openjdk-11 native/zip
# Dependencies are required at build time only.
BUILD_DEPENDS += cross/cups
BUILD_DEPENDS += cross/alsa-lib
BUILD_DEPENDS += cross/fontconfig
BUILD_DEPENDS += cross/libX11 cross/libXext cross/libXrender cross/libXrandr cross/libXtst cross/libXt
# libffi is required by the Zero version of Hotspot.
BUILD_DEPENDS += cross/libffi
DEPENDS += cross/zlib
DEPENDS += cross/libpng
DEPENDS += cross/libjpeg
DEPENDS += cross/giflib
DEPENDS += cross/lcms2

ZIP_BIN_DIR = $(realpath $(WORK_DIR)/../../../native/zip/work-native/install/usr/local/bin)
ENV += PATH=$$PATH:$(ZIP_BIN_DIR)

HOMEPAGE = http://openjdk.java.net/
COMMENT  = OpenJDK 11 is the open-source reference implementation of version 11 of the Java SE Platform as specified by by JSR 384 in the Java Community Process.
LICENSE  = ASL 1.1 and ASL 2.0 and BSD and BSD with advertising and GPL+ and GPLv2 and GPLv2 with exceptions and IJG and LGPLv2+ and MIT and MPLv2.0 and Public Domain and W3C and zlib

# Use our own configure since the one supplied by openjdk has no shebang
CONFIGURE_TARGET    = java-11-openjdk_configure

# Force openjdk to install into the package install folder
PRE_COMPILE_TARGET  = java-11-openjdk_pre_compile

# Fix symlinks
POST_INSTALL_TARGET = java-11-openjdk_post_compile

CONFIGURE_ARGS  = --openjdk-target=$(TC_TARGET)
CONFIGURE_ARGS += --with-boot-jdk=$(WORK_DIR)/../../../native/openjdk-11/work-native/jdk-11
CONFIGURE_ARGS += --with-version-build=$(JAVA_RELEASE)
CONFIGURE_ARGS += --with-version-pre=
CONFIGURE_ARGS += --with-version-opt=LTS
CONFIGURE_ARGS += --with-debug-level=release
CONFIGURE_ARGS += --with-native-debug-symbols=none
CONFIGURE_ARGS += --enable-unlimited-crypto
CONFIGURE_ARGS += --with-zlib=system
CONFIGURE_ARGS += --with-libjpeg=system
CONFIGURE_ARGS += --with-giflib=system
CONFIGURE_ARGS += --with-libpng=system
CONFIGURE_ARGS += --with-lcms=system
CONFIGURE_ARGS += --with-stdc++lib=dynamic
CONFIGURE_ARGS += --disable-javac-server
CONFIGURE_ARGS += --with-jvm-variants=zero
CONFIGURE_ARGS += --with-jvm-features=shenandoahgc,-zgc
CONFIGURE_ARGS += --disable-warnings-as-errors
CONFIGURE_ARGS += --with-x=$(INSTALL_DIR)/$(INSTALL_PREFIX)
CONFIGURE_ARGS += --with-cups=$(INSTALL_DIR)/$(INSTALL_PREFIX)
CONFIGURE_ARGS += --with-fontconfig=$(INSTALL_DIR)/$(INSTALL_PREFIX)
CONFIGURE_ARGS += --with-freetype-include=$(INSTALL_DIR)/$(INSTALL_PREFIX)/include/freetype2
CONFIGURE_ARGS += --with-freetype-lib=$(INSTALL_DIR)/$(INSTALL_PREFIX)/lib
CONFIGURE_ARGS += --prefix=$(INSTALL_PREFIX)
CONFIGURE_ARGS += --with-extra-cflags="$(CFLAGS) -fno-stack-protector -Wno-deprecated-declarations"
CONFIGURE_ARGS += --with-extra-cxxflags="$(CPPFLAGS) -fno-stack-protector -Wno-deprecated-declarations"
CONFIGURE_ARGS += --with-extra-ldflags="$(LDFLAGS) -Xlinker -z -Xlinker relro -Xlinker -Bsymbolic-functions"
CONFIGURE_ARGS += --enable-libffi-bundling
CONFIGURE_ARGS += --with-libffi=$(INSTALL_DIR)/$(INSTALL_PREFIX)
CONFIGURE_ARGS += --enable-aot=no
CONFIGURE_ARGS += --disable-manpages
CONFIGURE_ARGS += --disable-hotspot-gtest
# Disable all GUI related
CONFIGURE_ARGS += --enable-headless-only

PATCHES_LEVEL = 1

# Build images twice, second time with newly built JDK
COMPILE_MAKE_OPTIONS += product-images

ADDITIONAL_CFLAGS = -Os

# Filter out any -jN since java's configure will autodetect number of CPU's
# Use make JOBS=N to set number of CPU's in this package
DISABLE_PARALLEL_MAKE = 1
COMPILE_MAKE_OPTIONS += JOBS=$(NCPUS)

include ../../mk/spksrc.cross-cc.mk

.PHONY: java-11-openjdk_configure
# Use CONFIGURE_ARGS instead of REAL_CONFIGURE_ARGS to ignore TC_CONFIGURE_ARGS
# Disables the normal host build target triplets since openjdk use its own openjdk-target
java-11-openjdk_configure:
	$(RUN) bash ./configure $(CONFIGURE_ARGS)

.PHONY: java-11-openjdk_pre_compile
# As DESTDIR is not supported we must patch the make file for make install.
java-11-openjdk_pre_compile:
	sed -i -e "s|\$$(INSTALL_PREFIX)|$(STAGING_INSTALL_PREFIX)|g" $(WORK_DIR)/$(PKG_DIR)/make/Install.gmk

.PHONY: java-11-openjdk_post_compile
java-11-openjdk_post_compile:
	cd $(STAGING_INSTALL_PREFIX)/bin ; \
	ln -sf ../jvm/openjdk-$(JAVA_VERSION)/bin/* .
