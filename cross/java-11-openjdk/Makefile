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

BUILD_DEPENDS = native/openjdk-11 native/zip
# cups, cups dependencies and X11 dependencies are required at build time only.
BUILD_DEPENDS += cross/cups cross/libX11 cross/libXrender cross/libXtst cross/libXt cross/libXrandr cross/alsa-lib cross/fontconfig

include ../../mk/spksrc.archs.mk
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(PPC_ARCHS)),$(ARCH))
BUILD_DEPENDS += cross/libffi
endif

ZIP_BIN_DIR = $(realpath $(WORK_DIR)/../../../native/zip/work-native/install/usr/local/bin)
ENV += PATH=$$PATH:$(ZIP_BIN_DIR)

HOMEPAGE = http://openjdk.java.net/
COMMENT  = The OpenJDK 11 runtime environment. Version $(PKG_VERS)
LICENSE  = ASL 1.1 and ASL 2.0 and BSD and BSD with advertising and GPL+ and GPLv2 and GPLv2 with exceptions and IJG and LGPLv2+ and MIT and MPLv2.0 and Public Domain and W3C and zlib

# Use our own configure since the on supplied by openjdk has no shebang
CONFIGURE_TARGET    = java-11-openjdk_configure

# openjdk's make also run the install part and spksrc.plist.mk gets confused
PRE_COMPILE_TARGET  = java-11-openjdk_pre_compile

# copy the staged files to final installation so spksrc.plist.mk can run as normal
POST_INSTALL_TARGET = java-11-openjdk_post_install

CONFIGURE_ARGS  = --openjdk-target=$(TC_TARGET)
CONFIGURE_ARGS += --with-boot-jdk=$(WORK_DIR)/../../../native/openjdk-11/work-native/jdk-11
CONFIGURE_ARGS += --with-version-build=$(JAVA_RELEASE)
CONFIGURE_ARGS += --with-version-pre=
CONFIGURE_ARGS += --with-version-opt=LTS
CONFIGURE_ARGS += --with-debug-level=release
CONFIGURE_ARGS += --with-native-debug-symbols=none
CONFIGURE_ARGS += --enable-unlimited-crypto
CONFIGURE_ARGS += --with-zlib=bundled
CONFIGURE_ARGS += --with-libjpeg=bundled
CONFIGURE_ARGS += --with-giflib=bundled
CONFIGURE_ARGS += --with-libpng=bundled
CONFIGURE_ARGS += --with-lcms=bundled
CONFIGURE_ARGS += --with-stdc++lib=dynamic
CONFIGURE_ARGS += --disable-javac-server
CONFIGURE_ARGS += --with-jvm-features=shenandoahgc,-zgc
CONFIGURE_ARGS += --disable-warnings-as-errors
CONFIGURE_ARGS += --with-x=$(INSTALL_DIR)/$(INSTALL_PREFIX)
CONFIGURE_ARGS += --with-cups=$(INSTALL_DIR)/$(INSTALL_PREFIX)
CONFIGURE_ARGS += --with-fontconfig=$(INSTALL_DIR)/$(INSTALL_PREFIX)
CONFIGURE_ARGS += --prefix=$(INSTALL_PREFIX)
CONFIGURE_ARGS += --with-extra-cflags="$(CFLAGS)"
CONFIGURE_ARGS += --with-extra-cxxflags="$(CPPFLAGS)"
CONFIGURE_ARGS += --with-extra-ldflags="$(LDFLAGS)"
CONFIGURE_ARGS += --enable-aot=no
CONFIGURE_ARGS += --disable-manpages
CONFIGURE_ARGS += --disable-hotspot-gtest
CONFIGURE_ARGS += --with-jvm-variants=zero

PATCHES_LEVEL = 1

# Build the JDK image
COMPILE_MAKE_OPTIONS += images

ADDITIONAL_CFLAGS = -Os

PLIST_TRANSFORM = cat
# Some HotSpot components are not available on ARMv5_ARCHS, ARMv7L_ARCHS and PPC_ARCHS
ifeq ($(findstring $(ARCH), $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(PPC_ARCHS)),$(ARCH))
	PLIST_TRANSFORM = sed -e '/.*jhsdb.*/d' \
		-e '/.*classlist.*/d' \
		-e '/.*libsaproc.*/d' \
		-e '/.*jdk.hotspot.agent.*/d'
endif

include ../../mk/spksrc.cross-cc.mk

.PHONY: java-11-openjdk_configure
# use CONFIGURE_ARGS instead of REAL_CONFIGURE_ARGS
# to disable the normal host build target triplets since openjdk use its own openjdk-target
java-11-openjdk_configure:
	$(RUN) bash ./configure $(CONFIGURE_ARGS)

.PHONY: java-11-openjdk_pre_compile
java-11-openjdk_pre_compile:
	sed -i -e "s|\$$(INSTALL_PREFIX)|$(STAGING_DIR)|g" $(WORK_DIR)/$(PKG_DIR)/make/Install.gmk

.PHONY: java-11-openjdk_post_install
java-11-openjdk_post_install:
	cp -ar $(STAGING_DIR)/* $(INSTALL_DIR)/$(INSTALL_PREFIX)

