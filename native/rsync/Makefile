PKG_NAME = rsync
PKG_VERS = 3.1.3
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_SITE = https://download.samba.org/pub/$(PKG_NAME)/src
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)

HOMEPAGE = https://rsync.samba.org/
COMMENT  = Rsync is a fast and extraordinarily versatile file copying tool. It can copy locally, to/from another host over any remote shell, or to/from a remote rsync daemon. It offers a large number of options that control every aspect of its behavior and permit very flexible specification of the set of files to be copied. It is famous for its delta-transfer algorithm, which reduces the amount of data sent over the network by sending only the differences between the source files and the existing files in the destination. Rsync is widely used for backups and mirroring and as an improved copy command for everyday use. 
LICENSE  = GPLv3

GNU_CONFIGURE = 1

include ../../mk/spksrc.native-cc.mk
