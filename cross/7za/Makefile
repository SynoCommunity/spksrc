PKG_NAME = 7za
PKG_VERS = 24.09
PKG_EXT = tar.xz
PKG_DIST_NAME = 7z$(subst .,,$(PKG_VERS))-src.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/ip7z/7zip/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)/CPP/7zip/Bundles/Alone

# source archive does not have a package named top folder
# https://github.com/ip7z/7zip/issues/45
EXTRACT_PATH = $(WORK_DIR)/$(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# compiler too old
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS)

HOMEPAGE = https://www.7-zip.org/
COMMENT  = 7-Zip is a file archiver with a high compression ratio.
LICENSE = https://github.com/ip7z/7zip/blob/main/DOC/License.txt

CONFIGURE_TARGET = nop
COMPILE_MAKE_OPTIONS = -f makefile.gcc

PATCH_TARGET = 7z_patch
INSTALL_TARGET = 7z_install

include ../../mk/spksrc.cross-cc.mk

# disable unsupported HW capabilities:
ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
# ARMv7 fails with some undefined symbols
ADDITIONAL_CFLAGS += -DHWCAP2_CRC32=0 -DHWCAP2_SHA1=0 -DHWCAP2_SHA2=0 -DHWCAP2_AES=0
endif
ifeq ($(findstring $(ARCH),$(ARMv7L_ARCHS)),$(ARCH))
# ARMv7L is missing one more symbol:
ADDITIONAL_CFLAGS += -DHWCAP_NEON=0
endif

ENV += ADDITIONAL_CFLAGS="$(ADDITIONAL_CFLAGS)"

.PHONY: 7z_patch
7z_patch:
ifneq ($(strip $(PATCHES)),)
	@$(MSG) Make files to patch writable
	chmod +w $(EXTRACT_PATH)/CPP/7zip/7zip_gcc.mak
	chmod +w $(EXTRACT_PATH)/CPP/7zip/Crypto/MyAes.cpp
	chmod +w $(EXTRACT_PATH)/C/XzCrc64Opt.c
	@$(MSG) Run patch in $(EXTRACT_PATH) instead of $(WORK_DIR)/$(PKG_DIR)
	@for patchfile in $(PATCHES) ; \
	do \
	  echo "patch -p$(PATCHES_LEVEL) < $${patchfile}" ; \
	  cat $${patchfile} | (cd $(EXTRACT_PATH) && patch -p$(PATCHES_LEVEL)) ; \
	done
endif

.PHONY: 7z_install
7z_install:
	@$(MSG) Install target file
	@install -d -m 755 $(STAGING_INSTALL_PREFIX)/bin
	@install -m 755 $(WORK_DIR)/$(PKG_DIR)/_o/7za $(STAGING_INSTALL_PREFIX)/bin
