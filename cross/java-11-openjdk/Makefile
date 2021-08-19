PKG_NAME = java-11-openjdk
PKG_VERS = 11.0
JAVA_MINOR = 12
JAVA_RELEASE = 7
JAVA_VERS = $(PKG_VERS).$(JAVA_MINOR)+$(JAVA_RELEASE)
PKG_EXT = tar.gz
PKG_DIST_NAME = jdk-$(JAVA_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/openjdk/jdk11u/archive/refs/tags
PKG_DIR = jdk11u-jdk-$(PKG_VERS).$(JAVA_MINOR)-$(JAVA_RELEASE)

DEPENDS = cross/cups cross/fontconfig cross/expat
BUILD_DEPENDS = cross/libX11 cross/libXrender cross/libXtst cross/libXt cross/libXrandr cross/alsa-lib cross/zip
ifeq ($(findstring $(ARCH),hi3535 qotiq 88f6281),$(ARCH))
BUILD_DEPENDS += cross/libffi
endif

HOMEPAGE = http://openjdk.java.net/
COMMENT  = The OpenJDK 11 runtime environment
LICENSE  = ASL 1.1 and ASL 2.0 and BSD and BSD with advertising and GPL+ and GPLv2 and GPLv2 with exceptions and IJG and LGPLv2+ and MIT and MPLv2.0 and Public Domain and W3C and zlib

# Disable the normal host build target triplets since openjdk use its own openjdk-target
TC_CONFIGURE_ARGS =

# Use our own configure since the on supplied by openjdk has no shebang
CONFIGURE_TARGET    = $(PKG_NAME)_configure

# openjdk's make also run the install part and spksrc.plist.mk gets confused
PRE_COMPILE_TARGET  = $(PKG_NAME)_pre_compile_target

# copy the staged files to final installation so spksrc.plist.mk can run as normal
POST_INSTALL_TARGET = $(PKG_NAME)_post_install_target

CONFIGURE_ARGS  = --openjdk-target=$(TC_TARGET)
CONFIGURE_ARGS += --with-boot-jdk=./jdk-11
CONFIGURE_ARGS += --with-version-build=7
CONFIGURE_ARGS += --with-version-pre=
CONFIGURE_ARGS += --with-version-opt=LTS
CONFIGURE_ARGS += --with-debug-level=release
CONFIGURE_ARGS += --with-native-debug-symbols=internal
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
CONFIGURE_ARGS += --exec-prefix=$(INSTALL_PREFIX)
ifeq ($(findstring $(ARCH),hi3535 qoriq 88f6281),$(ARCH))
CONFIGURE_ARGS += --with-jvm-variants=zero
endif
CONFIGURE_ARGS += ZIPEXE=$(INSTALL_DIR)/$(INSTALL_PREFIX)/bin/zip

PATCHES_LEVEL = 1

COMPILE_MAKE_OPTIONS += bootcycle-images

PLIST_TRANSFORM = cat
ifeq ($(findstring $(ARCH), 88f6281),$(ARCH))
	PLIST_TRANSFORM = sed -e '/.*aot.*/d'
	#PLIST_TRANSFORM = sed -e '/:bin\/mono-boehm/d' -e '/:lib\/libmonoboehm/d'
endif

include ../../mk/spksrc.cross-cc.mk

.PHONY: $(PKG_NAME)_configure
$(PKG_NAME)_configure:
	$(RUN) wget https://download.java.net/openjdk/jdk11/ri/openjdk-11+28_linux-x64_bin.tar.gz
	$(RUN) tar xf openjdk-11+28_linux-x64_bin.tar.gz
ifeq ($(findstring $(ARCH),88f6281),$(ARCH))
	$(RUN) sed -i -e "s|-Wno-format-zero-length||g" make/autoconf/flags-cflags.m4
endif
	$(RUN) bash ./configure $(REAL_CONFIGURE_ARGS)

.PHONY: $(PKG_NAME)_pre_compile_target
$(PKG_NAME)_pre_compile_target:
	sed -i -e "s|\$$(INSTALL_PREFIX)|$(STAGING_DIR)|g" $(WORK_DIR)/$(PKG_DIR)/make/Install.gmk

.PHONY: $(PKG_NAME)_post_install_target
$(PKG_NAME)_post_install_target:
	cp -ar $(STAGING_DIR)/* $(INSTALL_DIR)/$(INSTALL_PREFIX)

