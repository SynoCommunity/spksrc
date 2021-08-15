PKG_NAME = java-1.8.0-openjdk
PKG_VERS = 312.2
PKG_EXT = tar.gz
PKG_DIST_NAME = jdk8u
PKG_DIST_SITE = https://hg.openjdk.java.net/jdk8u
PKG_HG_REV = jdk8u312-b02
PKG_DIST_FILE = $(PKG_NAME)-r$(PKG_HG_REV).$(PKG_EXT)
PKG_DOWNLOAD_METHOD = hg
PKG_DIR = $(PKG_NAME)-r$(PKG_HG_REV)
CHECKSUM_TARGET = nop

DEPENDS = cross/cups cross/fontconfig cross/expat
BUILD_DEPENDS = cross/libX11 cross/libXrender cross/libXtst cross/libXt cross/libXrandr cross/alsa-lib cross/libpng cross/libjpeg

HOMEPAGE = http://openjdk.java.net/
COMMENT  = The OpenJDK 8 runtime environment
LICENSE  = ASL 1.1 and ASL 2.0 and BSD and BSD with advertising and GPL+ and GPLv2 and GPLv2 with exceptions and IJG and LGPLv2+ and MIT and MPLv2.0 and Public Domain and W3C and zlib

# Disable the normal host build target triplets since openjdk use its own openjdk-target
TC_CONFIGURE_ARGS =

# Use our own configure since the on supplied by openjdk has no shebang
CONFIGURE_TARGET    = $(PKG_NAME)_configure

# openjdk's make also run the install part and spksrc.plist.mk gets confused
PRE_COMPILE_TARGET  = $(PKG_NAME)_pre_compile_target

# copy the staged files to final installation so spksrc.plist.mk can run as normal
POST_INSTALL_TARGET = $(PKG_NAME)_post_install_target

POST_EXTRACT_TARGET = $(PKG_NAME)_post_extract_target

CONFIGURE_ARGS = --openjdk-target=$(TC_TARGET) \
	--with-boot-jdk=./java-se-7u75-ri \
	--enable-jfr \
	--with-native-debug-symbols=internal \
	--with-milestone=fcs \
	--with-update-version=312 \
	--with-build-number=b02 \
	--with-vendor-name=SynoCommunity \
	--with-vendor-url=https://synocommunity.com/ \
	--with-vendor-bug-url=https://github.com/SynoCommunity/spksrc/issues \
	--with-vendor-vm-bug-url=https://github.com/SynoCommunity/spksrc/issues \
	--with-debug-level=release \
	--enable-unlimited-crypto \
	--with-zlib=bundled \
	--with-libjpeg=system \
	--with-giflib=bundled \
	--with-libpng=system \
	--with-lcms=bundled \
	--with-stdc++lib=dynamic \
	--with-x \
	--with-freetype-include=$(INSTALL_DIR)$(INSTALL_PREFIX)/include/freetype2 \
	--with-freetype-lib=$(INSTALL_DIR)$(INSTALL_PREFIX)/lib \
	--x-includes=$(INSTALL_DIR)$(INSTALL_PREFIX)/include \
	--x-libraries=$(INSTALL_DIR)$(INSTALL_PREFIX)/lib \
	--with-cups=$(INSTALL_DIR)$(INSTALL_PREFIX) \
	--with-fontconfig=$(INSTALL_DIR)$(INSTALL_PREFIX) \
	'--with-extra-ldflags=-L$(INSTALL_DIR)$(INSTALL_PREFIX)/lib'

ifeq ($(findstring $(ARCH), ppc824x ppc853x),$(ARCH))
ifneq (5,$(firstword $(sort $(TCVERSION) 5)))
# toolchains before version 5 require the old linux quota version
# related issue: https://github.com/transmission/transmission/issues/591
ADDITIONAL_CFLAGS = -D_LINUX_QUOTA_VERSION=1
endif
endif
PATCHES_LEVEL = 1

include ../../mk/spksrc.cross-cc.mk

.PHONY: $(PKG_NAME)_configure
$(PKG_NAME)_configure:
	$(RUN) bash ./configure $(REAL_CONFIGURE_ARGS)

.PHONY: $(PKG_NAME)_pre_compile_target
$(PKG_NAME)_pre_compile_target:
	sed -i -e "s|\$$(INSTALL_PREFIX)|$(STAGING_DIR)|g" $(WORK_DIR)/$(PKG_DIR)/jdk/make/BuildJdk.gmk

.PHONY: $(PKG_NAME)_post_install_target
$(PKG_NAME)_post_install_target:
	cp -ar $(STAGING_DIR)/* $(INSTALL_DIR)/$(INSTALL_PREFIX)

.PHONY: $(PKG_NAME)_post_extract_target
 $(PKG_NAME)_post_extract_target:
	$(RUN) hg init
	$(RUN) echo "[paths]" > .hg/hgrc
	$(RUN) echo "default         = $(PKG_DIST_SITE)/$(PKG_DIST_NAME)/" >> .hg/hgrc
	$(RUN) sh ./get_source.sh
	$(RUN) wget https://download.java.net/openjdk/jdk7u75/ri/openjdk-7u75-b13-linux-x64-18_dec_2014.tar.gz
	$(RUN) tar xf openjdk-7u75-b13-linux-x64-18_dec_2014.tar.gz
