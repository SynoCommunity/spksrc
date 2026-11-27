PKG_NAME = rustfs
PKG_VERS = 1.0.1
PKG_EXT = zip
PKG_DIST_NAME = $(PKG_NAME)-linux-$(PKG_DIST_ARCH)-musl-v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/rustfs/rustfs/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)
EXTRACT_PATH = $(WORK_DIR)/$(PKG_DIR)

HOMEPAGE = https://rustfs.com/
COMMENT  = RustFS is an S3-compatible object storage server written in Rust.
LICENSE  = Apache-2.0

INSTALL_TARGET = rustfs_install

# Prebuilt, statically linked (static-pie) musl binaries are published by
# upstream only for x86_64 and aarch64. Building from source needs a very large
# amount of build resources, so the package ships these binaries as-is.
# Multi-file digests: one dist file per architecture.
PKG_DIST_ARCH_LIST = x86_64 aarch64

include ../../mk/spksrc.common.mk

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
PKG_DIST_ARCH = x86_64
else ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
PKG_DIST_ARCH = aarch64
endif

# No prebuilt RustFS binary is published for the other architectures.
ifeq ($(PKG_DIST_ARCH),)
UNSUPPORTED_ARCHS += $(ARCH)
UNSUPPORTED_ARCHS_REASON = no prebuilt RustFS binary is published for this arch
endif

include ../../mk/spksrc.cross-install.mk

.PHONY: rustfs_install
rustfs_install:
	@$(MSG) Install rustfs server binary
	@install -d -m 755 $(STAGING_INSTALL_PREFIX)/bin
	@install -m 755 $(EXTRACT_PATH)/rustfs $(STAGING_INSTALL_PREFIX)/bin/rustfs
