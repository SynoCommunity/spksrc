PKG_NAME       = java-25-openjdk
JAVA_REPO_NAME = jdk25u
JAVA_NAME      = jdk
JAVA_RELEASE   = 1
JAVA_VERSION   = 25.0.5.0.3
JAVA_MAJOR   = $(firstword $(subst ., ,$(JAVA_VERSION)))
PKG_VERS       = $(JAVA_VERSION).$(JAVA_RELEASE)
PKG_EXT        = tar.gz
PKG_DIST_NAME  = $(JAVA_NAME)-$(JAVA_VERSION)+$(JAVA_RELEASE).$(PKG_EXT)
PKG_DIST_SITE  = https://github.com/openjdk/jdk25u/archive
PKG_DIR        = $(JAVA_REPO_NAME)-$(JAVA_NAME)-$(JAVA_VERSION)-$(JAVA_RELEASE)

# configure warns below gcc 10 ("not a supported configuration") but builds with 8.5,
# the DSM 7.1 toolchains.
MIN_GCC_VERSION = 8.5

include ../../mk/spksrc.common.mk

# build instructions:
# https://github.com/openjdk/jdk/blob/master/doc/building.md

# Dependencies required at build time only:
BUILD_DEPENDS  = native/openjdk-25
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
# a font for AWT text: DSM has none, and fontconfig finds it through etc/fonts/conf.d
DEPENDS += cross/dejavu
DEPENDS += cross/zlib
DEPENDS += cross/libpng
DEPENDS += cross/libjpeg
DEPENDS += cross/giflib
DEPENDS += cross/lcms2

# Zero, the 32-bit VM below, calls native code through libffi
ifneq ($(filter $(ARCH),$(32bit_ARCHS)),)
DEPENDS += cross/libffi
endif

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
CONFIGURE_ARGS += --disable-dtrace
CONFIGURE_ARGS += --disable-precompiled-headers

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
COMPILE_ARGS += jdk-image

# debian patches
# https://udd.debian.org/patches.cgi?src=openjdk-25&version=25.0.3%2B9-2~deb13u1
PATCHES_LEVEL = 1

# The JDK runs its own parallel make, with the job count configure derives from the
# CPUs and memory: keep spksrc's -jN, and its NCPUS (then 1), out of it.
DISABLE_PARALLEL_MAKE = 1

include ../../mk/spksrc.cross-cc.mk

# The PLIST names the install directory openjdk-@JAVA_VERSION@.
PLIST_TRANSFORM = sed -e 's%@JAVA_VERSION@%$(JAVA_VERSION)%'

##
## 32-bit: Zero, the interpreter-only VM, as Debian builds armhf and i386. The x86_32 port
## is gone since JDK 25 (JEP 503) and ARM32 execution is broken (JDK-8321125).
##
ifneq ($(filter $(ARCH),$(32bit_ARCHS)),)
CONFIGURE_ARGS += --with-jvm-variants=zero
CONFIGURE_ARGS += --with-libffi=$(INSTALL_DIR)/$(INSTALL_PREFIX)

PLIST_TRANSFORM += -e 's%lib/server/%lib/zero/%' -e '/lib\/zero\/classes/d'
PLIST_TRANSFORM += -e '/lib\/libjsvml/d' -e '/lib\/libsimdsort/d' -e '/lib\/libsleef/d'
PLIST_TRANSFORM += -e '/jmods\/jdk.internal.vm.ci/d' -e '/jmods\/jdk.graal.compiler/d'
# no serviceability agent (jhsdb) on Zero
PLIST_TRANSFORM += -e '/bin\/jhsdb/d' -e '/lib\/libsaproc/d' -e '/jmods\/jdk.hotspot.agent/d'

ifneq ($(filter $(ARCH),$(ARMv7_ARCHS)),)
CONFIGURE_ARGS += --with-abi-profile=arm-vfp-hflt
endif

ifneq ($(filter $(ARCH),$(i686_ARCHS)),)
CONFIGURE_ARGS += --build=x86_64-pc-linux-gnu
endif
endif   # 32-bit

##
## 64-bit: Server, the HotSpot JIT VM; each arch drops the vector libraries it does not build.
##
ifneq ($(filter $(ARCH),$(64bit_ARCHS)),)

# remove targets not created for aarch64
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --with-abi-profile=aarch64
PLIST_TRANSFORM += -e '/lib\/libjsvml/d' -e '/lib\/libsimdsort/d' -e '/lib\/server\/classes/d'
endif

# remove targets not created for x64
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
PLIST_TRANSFORM += -e '/lib\/libsleef/d'
endif
endif   # 64-bit

.PHONY: java-25-openjdk_pre_configure
java-25-openjdk_pre_configure:
	@$(MSG) "- Make configure script executable"
	@cd $(WORK_DIR)/$(PKG_DIR) && chmod +x ./configure

# linux-<cpu>-server-release, or linux-<cpu>-zero-release on 32-bit
JDK_IMAGE_DIR=$(WORK_DIR)/$(PKG_DIR)/build/linux-*-release/images/jdk
.PHONY: java-25-openjdk_install
java-25-openjdk_install:
	@$(MSG) "- Install jdk"
	@mkdir -p $(STAGING_INSTALL_PREFIX)/jvm/openjdk-$(JAVA_VERSION)/
	@cp -rpf $(JDK_IMAGE_DIR)/* $(STAGING_INSTALL_PREFIX)/jvm/openjdk-$(JAVA_VERSION)/
	@$(MSG) "- Link binaries into bin folder"
	@cd $(STAGING_INSTALL_PREFIX)/bin && ln -sf ../jvm/openjdk-$(JAVA_VERSION)/bin/* .
	@$(MSG) "- Version links: jvm/openjdk-$(JAVA_MAJOR) as a stable JAVA_HOME, and java$(JAVA_MAJOR), javac$(JAVA_MAJOR), jar$(JAVA_MAJOR)"
	@cd $(STAGING_INSTALL_PREFIX)/jvm && ln -sfn openjdk-$(JAVA_VERSION) openjdk-$(JAVA_MAJOR)
	@cd $(STAGING_INSTALL_PREFIX)/bin && for c in java javac jar; do ln -sf ../jvm/openjdk-$(JAVA_MAJOR)/bin/$$c $$c$(JAVA_MAJOR); done
	@$(MSG) "- Add license files"
	@cp -pf $(WORK_DIR)/$(PKG_DIR)/LICENSE                   $(STAGING_INSTALL_PREFIX)/jvm/openjdk-$(JAVA_VERSION)/
	@cp -pf $(WORK_DIR)/$(PKG_DIR)/ADDITIONAL_LICENSE_INFO   $(STAGING_INSTALL_PREFIX)/jvm/openjdk-$(JAVA_VERSION)/
	@cp -pf $(WORK_DIR)/$(PKG_DIR)/ASSEMBLY_EXCEPTION        $(STAGING_INSTALL_PREFIX)/jvm/openjdk-$(JAVA_VERSION)/
	@$(MSG) "- Point fontconfig at the bundled DejaVu fonts"
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/etc/fonts/conf.d
	@printf '%s\n' '<?xml version="1.0"?>' '<!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">' '<fontconfig>' \
	  '  <dir>$(INSTALL_PREFIX)/share/dejavu/fonts</dir>' \
	  '  <include ignore_missing="yes">$(INSTALL_PREFIX)/share/dejavu/fontconfig</include>' \
	  '</fontconfig>' > $(STAGING_INSTALL_PREFIX)/etc/fonts/conf.d/60-dejavu.conf
