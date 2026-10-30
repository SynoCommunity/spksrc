PKG_NAME = sshfs
PKG_VERS = 3.7.6
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libfuse/sshfs/releases/download/sshfs-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/fuse3 cross/glib

# Needs glibc >= 2.18: sshfs.c names AF_VSOCK, which bits/socket.h only carries from
# there on -- measured on x64-5.2 (glibc 2.17), where it stops at "'AF_VSOCK' undeclared".
# This is what the virtual used to express as a DSM 3.0-5.x range, which said nothing
# about the reason and nothing about an arch outside that range. sshfs 3.7.3, the tier
# below, has no AF_VSOCK at all, which is why it serves ARMv5 and its glibc 2.15.
MIN_GLIBC_VERSION = 2.18

UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS)

HOMEPAGE = https://github.com/libfuse/sshfs
COMMENT = sshfs is a network filesystem client to connect to SSH servers.
LICENSE = GPLv2

PRE_CONFIGURE_TARGET = sshfs_add_toolchain_file

include ../../mk/spksrc.cross-meson.mk

.PHONY: sshfs_add_toolchain_file
sshfs_add_toolchain_file:
	@$(MSG) Add header file lacking in some toolchains
	@install -d -m 755 $(STAGING_INSTALL_PREFIX)/include/linux
	@install -m 755 src/vm_sockets.h $(STAGING_INSTALL_PREFIX)/include/linux/
