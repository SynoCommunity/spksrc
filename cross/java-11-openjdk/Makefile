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

CONFIGURE_ARGS = --openjdk-target=$(TC_TARGET) \
	--with-boot-jdk=./java-se-7u75-ri \
	--with-version-build=7 \
	--with-version-pre= \
	--with-version-opt=LTS \
	--with-debug-level=release \
	--with-native-debug-symbols=internal \
	--enable-unlimited-crypto \
	--with-zlib=bundled \
	--with-libjpeg=bundled \
	--with-giflib=bundled \
	--with-libpng=bundled \
	--with-lcms=bundled \
	--with-stdc++lib=dynamic \
	--disable-javac-server \
	--with-jvm-features=shenandoahgc,-zgc \
	--disable-warnings-as-errors \
	--with-x=$(INSTALL_DIR)/$(INSTALL_PREFIX) \
	--with-cups=$(INSTALL_DIR)/$(INSTALL_PREFIX) \
	--with-fontconfig=$(INSTALL_DIR)/$(INSTALL_PREFIX) \
	--prefix=$(INSTALL_PREFIX) \
	--exec-prefix=$(INSTALL_PREFIX) \
	ZIPEXE=$(INSTALL_DIR)/$(INSTALL_PREFIX)/bin/zip

PATCHES_LEVEL = 1

include ../../mk/spksrc.cross-cc.mk

.PHONY: $(PKG_NAME)_configure
$(PKG_NAME)_configure:
	$(RUN) wget https://download.java.net/openjdk/jdk7u75/ri/openjdk-7u75-b13-linux-x64-18_dec_2014.tar.gz
	$(RUN) tar xf openjdk-7u75-b13-linux-x64-18_dec_2014.tar.gz
	$(RUN) bash ./configure $(REAL_CONFIGURE_ARGS)

.PHONY: $(PKG_NAME)_pre_compile_target
$(PKG_NAME)_pre_compile_target:
	sed -i -e "s|\$$(INSTALL_PREFIX)|$(STAGING_DIR)|g" $(WORK_DIR)/$(PKG_DIR)/make/Install.gmk

.PHONY: $(PKG_NAME)_post_install_target
$(PKG_NAME)_post_install_target:
	cp -ar $(STAGING_DIR)/* $(INSTALL_DIR)/$(INSTALL_PREFIX)

