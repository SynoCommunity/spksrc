PKG_NAME = zdinnav
PKG_VERS = 1.1.2
PKG_EXT = tar.gz
# 压缩包文件名
PKG_DIST_NAME = synology-$(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
# 程序下载地址，最终下载地址：PKG_DIST_SITE/PKG_DIST_NAME
# PKG_DIST_SITE = http://192.168.52.1/chfs/shared
PKG_DIST_SITE=https://github.com/MyTkme/ZdinNav-Link/releases/download/pkg_Synology_$(PKG_VERS)

# 压缩包内的文件夹名称
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/curl

HOMEPAGE = https://github.com/MyTkme/ZdinNav-Link
COMMENT  = ZdinNav Compressed Package Program Files
LICENSE  = Copyright (C) 2026 tkme.

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)
UNSUPPORTED_ARCHS += $(PPC_ARCHS)

URLS          = $(PKG_DIST_SITE)/$(PKG_DIST_NAME)
NAME          = $(PKG_NAME)
COOKIE_PREFIX = $(PKG_NAME)-
ifneq ($(PKG_DIST_FILE),)
LOCAL_FILE    = $(PKG_DIST_FILE)
else
LOCAL_FILE    = $(PKG_DIST_NAME)
endif
DIST_FILE     = $(DISTRIB_DIR)/$(LOCAL_FILE)
DIST_EXT      = $(PKG_EXT)

ifneq ($(ARCH),)
ARCH_SUFFIX = -$(ARCH)-$(TCVERSION)
ifneq ($(ARCH),noarch)
TC = syno$(ARCH_SUFFIX)
endif
endif

include ../../mk/spksrc.directories.mk
include ../../mk/spksrc.common.mk

# 平台对应编译后的关系
# ARM32：ARMv5 / ARMv7L 、ARMv7、i686
# ARM64：ARMv8 (AArch64)
# AMD64：x86_64
ZDINNAV_PLATFORM =
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
# armel 对应 linux-arm
ZDINNAV_PLATFORM = linux-arm
endif
ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
# armhf 对应 linux-arm
ZDINNAV_PLATFORM = linux-arm
endif
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
# arm64 对应 linux-arm64
ZDINNAV_PLATFORM = linux-arm64
endif
ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
# i386 对应 linux-arm
ZDINNAV_PLATFORM = linux-arm
endif
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
# amd64 对应 linux-amd64
ZDINNAV_PLATFORM = linux-amd64
endif
# 不支持这个平台
# ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
# ZDINNAV_PLATFORM = powerpc
# endif
ifeq ($(strip $(ZDINNAV_PLATFORM)),)
$(error Arch $(ARCH) not supported)
endif

CONFIGURE_TARGET = nop
COMPILE_TARGET += dotnet_compile_target

ifeq ($(strip $(INSTALL_TARGET)),)
INSTALL_TARGET = nop 
endif

# 将预编译文件直接拷贝到已编译的路径
.PHONY: dotnet_compile_target
dotnet_compile_target:
	@$(MSG) $(ZDINNAV_PLATFORM) Compiled files copied successfully.
	@mkdir -p $(STAGING_INSTALL_PREFIX)/application/bin/
	cp -r $(WORK_DIR)/$(PKG_DIR)/application/ZdinNav.Api-$(ZDINNAV_PLATFORM)/* $(STAGING_INSTALL_PREFIX)/application/bin/
	mv -f $(STAGING_INSTALL_PREFIX)/application/bin/zdin-nav/ $(STAGING_INSTALL_PREFIX)/application/web

# Include base cross-cc makefile for common functionality
include ../../mk/spksrc.cross-cc.mk

