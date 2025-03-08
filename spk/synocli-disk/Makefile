SPK_NAME = synocli-disk
SPK_VERS = 4.0
SPK_REV = 13
SPK_ICON = src/synocli-disk.png

DEPENDS  = cross/ntfs-3g_ntfsprogs cross/e2fsprogs cross/fuse cross/testdisk
DEPENDS += cross/ncdu cross/davfs2 cross/lsscsi cross/ddrescue
DEPENDS += cross/s3backer

OPTIONAL_DEPENDS  = cross/dar cross/duf cross/gdu cross/tdu
OPTIONAL_DEPENDS += cross/dua cross/dutree
OPTIONAL_DEPENDS += cross/smartmontools

MAINTAINER = SynoCommunity
DISPLAY_NAME = SynoCli Disk Tools

OPTIONAL_DESC =

include ../../mk/spksrc.archs.mk

ifneq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
# Tools built with go are not supported on PPC archs
DEPENDS += cross/duf cross/gdu cross/tdu
OPTIONAL_DESC := $(OPTIONAL_DESC)", duf, gdu, tdu"
endif

ifneq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
# not supported on old PPC archs
DEPENDS += cross/dua cross/dutree
OPTIONAL_DESC := $(OPTIONAL_DESC)", dua, dutree"
endif

ifneq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
DEPENDS += cross/smartmontools
OPTIONAL_DESC := $(OPTIONAL_DESC)", smartmontools \(smartctl\)"
endif

DESCRIPTION = "SynoCli Disk Tools provides a number of small command-line utilities: e2fsprogs, fuse, ntfs-3g/ntfsprogs, testdisk, ncdu, davfs2, lsscsi, ddrescure, s3backer$(OPTIONAL_DESC)."
STARTABLE = no
CHANGELOG  = "1. Add smartmontools 7.4. <br/>"
CHANGELOG += "2. Remove dua for ARMv5 (88f628x cpu). <br/>"
CHANGELOG += "3. Update dar to v2.7.16. <br/>"
CHANGELOG += "4. Update davfs2 to v1.7.1. <br/>"
CHANGELOG += "5. Update ddrescue to v1.29. <br/>"
CHANGELOG += "6. Update dua to v2.30.0. <br/>"
CHANGELOG += "7. Update e2fsprogs to v1.47.2. <br/>"
CHANGELOG += "8. Update gdu to v5.30.1. <br/>"
CHANGELOG += "9. Update ncdu to v1.21. <br/>"
CHANGELOG += "10. Update s3backer to v2.1.3."

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
SPK_COMMANDS += bin/ddrescue bin/ddrescuelog
SPK_COMMANDS += bin/duf bin/gdu bin/tdu
SPK_COMMANDS += bin/dua bin/dutree
SPK_COMMANDS += bin/s3backer

ifneq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
# smartctl of this package will not be found by path, because /bin/smartctl is found first
# you have to use smartctl7 (or /usr/local/bin/smartctl or /var/packages/synocli-disk/target/sbin/smartctl)
SPK_COMMANDS += sbin/smartctl7 sbin/smartctl sbin/smartd sbin/update-smart-drivedb
endif

include ../../mk/spksrc.spk.mk

ifeq ($(call version_ge, $(TC_GCC), 4.9.3),1)
# DAR: Only archs with C++ compiler support for c++14 standard are supported
DEPENDS += cross/dar
OPTIONAL_DESC := $(OPTIONAL_DESC)", dar"
SPK_COMMANDS += bin/dar bin/dar_cp bin/dar_manager bin/dar_slave bin/dar_split bin/dar_xform
endif
