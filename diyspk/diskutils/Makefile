SPK_NAME = diskutils
SPK_VERS = 1.46.5
SPK_REV = 1
SPK_ICON = src/diskutils.png

DEPENDS  = cross/e2fsprogs cross/screen

MAINTAINER = Diaoul
DESCRIPTION = Low level utilities to manage your hard disk drives. This package contains e2fsprogs and screen.
DESCRIPTION_FRE = Utilitaires bas niveau pour gérer vos disques durs. Ce package contient e2fsprogs et screen.
STARTABLE = no

HOMEPAGE   = 
LICENSE    =

SPK_COMMANDS  = bin/screen
SPK_COMMANDS += sbin/badblocks sbin/blkid sbin/debugfs sbin/dumpe2fs sbin/e2freefrag sbin/e2fsck sbin/e2image
SPK_COMMANDS += sbin/e2label sbin/e2mmpstatus sbin/e2scrub sbin/e2scrub_all sbin/e2undo sbin/e4crypt sbin/filefrag
SPK_COMMANDS += sbin/findfs sbin/fsck sbin/fsck.ext2 sbin/fsck.ext3 sbin/fsck.ext4 sbin/logsave sbin/mke2fs sbin/mkfs.ext2
SPK_COMMANDS += sbin/mkfs.ext3 sbin/mkfs.ext4 sbin/mklost+found sbin/resize2fs sbin/tune2fs sbin/uuidd
# avoid link to e4defrag
#SPK_COMMANDS += sbin/e4defrag

include ../../mk/spksrc.spk.mk
