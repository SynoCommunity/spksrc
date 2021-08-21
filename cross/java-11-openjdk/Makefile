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

DEPENDS = cross/cups cross/fontconfig cross/expat
BUILD_DEPENDS = cross/libX11 cross/libXrender cross/libXtst cross/libXt cross/libXrandr cross/alsa-lib cross/zip

include ../../mk/spksrc.archs.mk
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(PPC_ARCHS)),$(ARCH))
BUILD_DEPENDS += cross/libffi
endif

HOMEPAGE = http://openjdk.java.net/
COMMENT  = The OpenJDK 11 runtime environment. Version $(PKG_VERS)
LICENSE  = ASL 1.1 and ASL 2.0 and BSD and BSD with advertising and GPL+ and GPLv2 and GPLv2 with exceptions and IJG and LGPLv2+ and MIT and MPLv2.0 and Public Domain and W3C and zlib

# Disable the normal host build target triplets since openjdk use its own openjdk-target
TC_CONFIGURE_ARGS =

# Use our own configure since the on supplied by openjdk has no shebang
CONFIGURE_TARGET    = $(PKG_NAME)_configure

# openjdk's make also run the install part and spksrc.plist.mk gets confused
PRE_COMPILE_TARGET  = $(PKG_NAME)_pre_compile

# copy the staged files to final installation so spksrc.plist.mk can run as normal
POST_INSTALL_TARGET = $(PKG_NAME)_post_install

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
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(PPC_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --with-jvm-variants=zero
endif
CONFIGURE_ARGS += ZIPEXE=$(INSTALL_DIR)/$(INSTALL_PREFIX)/bin/zip

PATCHES_LEVEL = 1

COMPILE_MAKE_OPTIONS += bootcycle-images

ADDITIONAL_CFLAGS = -Os

PLIST_TRANSFORM = cat
# AOT is not available on i686_ARCHS and GENERIC_ARMv7_ARCH
ifeq ($(findstring $(ARCH), $(i686_ARCHS) $(GENERIC_ARMv7_ARCH)),$(ARCH))
	PLIST_TRANSFORM = sed -e '/.*aot.*/d' \
		-e '/.*jdk.internal.vm.*/d' \
		-e '/.*jquery-migrate.md.*/d'
endif

# AOT and HotSpot are not available on ARMv5_ARCHS
ifeq ($(findstring $(ARCH), $(ARMv5_ARCHS) $(PPC_ARCHS)),$(ARCH))
	PLIST_TRANSFORM = sed -e '/.*aot.*/d' \
		-e '/.*jhsdb.*/d' \
		-e '/.*classlist.*/d' \
		-e '/.*libsaproc.*/d' \
		-e '/.*jdk.hotspot.agent.*/d' \
		-e '/.*jdk.internal.vm.*/d' \
		-e '/.*jquery-migrate.md.*/d'
endif

# AOT and HotSpot are not available on  ARMv7L_ARCHS
ifeq ($(findstring $(ARCH), $(ARMv7L_ARCHS)),$(ARCH))
	PLIST_TRANSFORM = sed -e '/.*aot.*/d' \
		-e '/.*jdk.hotspot.agent.*/d' \
		-e '/.*jdk.internal.vm.*/d' \
		-e '/.*jquery-migrate.md.*/d'
endif

include ../../mk/spksrc.cross-cc.mk

.PHONY: $(PKG_NAME)_configure
$(PKG_NAME)_configure:
	$(RUN) wget https://download.java.net/openjdk/jdk11/ri/openjdk-11+28_linux-x64_bin.tar.gz
	$(RUN) tar xf openjdk-11+28_linux-x64_bin.tar.gz
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
	$(RUN) sed -i -e "s|-Wno-format-zero-length||g" make/autoconf/flags-cflags.m4
endif
	$(RUN) bash ./configure $(REAL_CONFIGURE_ARGS)

.PHONY: $(PKG_NAME)_pre_compile
$(PKG_NAME)_pre_compile:
	sed -i -e "s|\$$(INSTALL_PREFIX)|$(STAGING_DIR)|g" $(WORK_DIR)/$(PKG_DIR)/make/Install.gmk

.PHONY: $(PKG_NAME)_post_install
$(PKG_NAME)_post_install:
	cp -ar $(STAGING_DIR)/* $(INSTALL_DIR)/$(INSTALL_PREFIX)

