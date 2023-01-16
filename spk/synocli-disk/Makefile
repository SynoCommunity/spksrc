SPK_NAME = synocli-disk
SPK_VERS = 3.3
SPK_REV = 9
SPK_ICON = src/synocli-disk.png

DEPENDS  = cross/ntfs-3g_ntfsprogs cross/e2fsprogs cross/fuse cross/testdisk
DEPENDS += cross/ncdu cross/davfs2 cross/lsscsi cross/ddrescue
OPTIONAL_DEPENDS  = cross/dar cross/duf cross/gdu cross/tdu
OPTIONAL_DEPENDS += cross/dua cross/dutree

MAINTAINER = SynoCommunity
DISPLAY_NAME = SynoCli Disk Tools

OPTIONAL_DESC =

include ../../mk/spksrc.archs.mk

ifneq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
# DAR: archs without C++11 support are not supported
DEPENDS += cross/dar
OPTIONAL_DESC := $(OPTIONAL_DESC)", dar"
endif

ifneq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
# Tools built with go are not supported on PPC archs
DEPENDS += cross/duf cross/gdu cross/tdu
OPTIONAL_DESC := $(OPTIONAL_DESC)", duf, gdu, tdu"
endif

ifneq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
# not supported on old PPC archs
DEPENDS += cross/dua cross/dutree
OPTIONAL_DESC := $(OPTIONAL_DESC)", dua, dutree"
endif

DESCRIPTION = "SynoCli Disk Tools provides a set of small command-line utilities: e2fsprogs, fuse, ntfs-3g/ntfsprogs, testdisk, ncdu, davfs2, lsscsi, ddrescure$(OPTIONAL_DESC)."
STARTABLE = no
CHANGELOG = "1. Update dar for public key encryption and for largefile support on 32bit archs.<br/>2. Update ncdu to v1.17.<br/>3. Update e2fsprogs to v1.46.5.<br/>4. Update ddrescure to v1.26.<br/>5. Update dua to v.2.17.2.<br/>6. Update dutree to v.0.2.18."

HOMEPAGE = https://github.com/SynoCommunity/spksrc/wiki/FAQ-SynoCliDisk
LICENSE  = Each tool is licensed under it\'s respective license.

SPK_COMMANDS  = bin/chattr bin/compile_et bin/lsattr bin/mk_cmds
SPK_COMMANDS += sbin/badblocks sbin/blkid sbin/debugfs
SPK_COMMANDS += sbin/dumpe2fs sbin/e2freefrag sbin/e2fsck sbin/e2image sbin/e2label
SPK_COMMANDS += sbin/e2mmpstatus sbin/e2scrub sbin/e2scrub_all sbin/e2undo sbin/e4crypt sbin/filefrag sbin/findfs
SPK_COMMANDS += sbin/fsck sbin/fsck.ext2 sbin/fsck.ext3 sbin/fsck.ext4
SPK_COMMANDS += sbin/logsave sbin/mke2fs sbin/mkfs.ext2 sbin/mkfs.ext3 sbin/mkfs.ext4
SPK_COMMANDS += sbin/mklost+found sbin/resize2fs sbin/tune2fs
SPK_COMMANDS += sbin/mkntfs sbin/ntfsclone sbin/ntfscp sbin/ntfslabel sbin/ntfsresize sbin/ntfsundelete
SPK_COMMANDS += bin/ntfs-3g.probe bin/ntfscat bin/ntfscluster bin/ntfscmp bin/ntfsfix bin/ntfsinfo bin/ntfsls
SPK_COMMANDS += bin/lowntfs-3g bin/ntfs-3g

SPK_COMMANDS += bin/fusermount bin/ulockmgr_server
SPK_COMMANDS += bin/testdisk bin/photorec bin/fidentify
SPK_COMMANDS += bin/ncdu
SPK_COMMANDS += sbin/mount.davfs sbin/umount.davfs
SPK_COMMANDS += bin/lsscsi
SPK_COMMANDS += bin/dar bin/dar_cp bin/dar_manager bin/dar_slave bin/dar_split bin/dar_xform
SPK_COMMANDS += bin/ddrescue bin/ddrescuelog
SPK_COMMANDS += bin/duf bin/gdu bin/tdu
SPK_COMMANDS += bin/dua bin/dutree

include ../../mk/spksrc.spk.mk
