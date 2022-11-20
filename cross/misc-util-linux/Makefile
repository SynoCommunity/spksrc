PKG_NAME = misc-util-linux
PKG_REAL_NAME = util-linux
PKG_VERS = 2.38.1
PKG_VERS_MAJOR = $(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_REAL_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.kernel.org/pub/linux/utils/$(PKG_REAL_NAME)/v$(PKG_VERS_MAJOR)
# use dedicated folder to build independent of other libraries built from util-linux (i.e. libuuid, libblkid)
PKG_DIR = $(PKG_NAME)/$(PKG_REAL_NAME)-$(PKG_VERS)
EXTRACT_PATH = $(WORK_DIR)/$(PKG_NAME)

DEPENDS = cross/ncursesw

HOMEPAGE = https://github.com/karelzak/util-linux
COMMENT  = Random collection of Linux utilities. We use this only to build ... out of util-linux.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static --without-ncurses --without-python --disable-asciidoc

CONFIGURE_ARGS += --disable-makeinstall-chown
CONFIGURE_ARGS += --disable-makeinstall-setuid
CONFIGURE_ARGS += --disable-use-tty-group

# Create some of the util-linux tools for synocli-misc
# There is no configure option to enable the text utils we want
# So we must disable what we do not want (or fails to build)
#CONFIGURE_ARGS += --disable-all-programs
CONFIGURE_ARGS += --disable-eject
CONFIGURE_ARGS += --disable-libblkid
CONFIGURE_ARGS += --disable-libuuid
CONFIGURE_ARGS += --disable-libfdisk
CONFIGURE_ARGS += --disable-fdisks
CONFIGURE_ARGS += --disable-mount
CONFIGURE_ARGS += --disable-losetup
CONFIGURE_ARGS += --disable-zramctl
CONFIGURE_ARGS += --disable-fsck
CONFIGURE_ARGS += --disable-partx
CONFIGURE_ARGS += --disable-uuidd
CONFIGURE_ARGS += --disable-uuidgen
CONFIGURE_ARGS += --disable-blkid
CONFIGURE_ARGS += --disable-wipefs
CONFIGURE_ARGS += --disable-mountpoint
CONFIGURE_ARGS += --disable-fallocate
CONFIGURE_ARGS += --disable-unshare
CONFIGURE_ARGS += --disable-nsenter
CONFIGURE_ARGS += --disable-setpriv
CONFIGURE_ARGS += --disable-hardlink
CONFIGURE_ARGS += --disable-agetty

CONFIGURE_ARGS += --disable-libmount
CONFIGURE_ARGS += --disable-lsfd
CONFIGURE_ARGS += --disable-mkfs
CONFIGURE_ARGS += --disable-swapon
CONFIGURE_ARGS += --disable-schedutils

ADDITIONAL_CFLAGS = -Wno-unused-parameter

# avoid compile errors for some archs:
ADDITIONAL_CFLAGS += -DFIEMAP_EXTENT_SHARED=0x00002000
ADDITIONAL_CFLAGS += -DSFD_CLOEXEC=02000000

include ../../mk/spksrc.cross-cc.mk
