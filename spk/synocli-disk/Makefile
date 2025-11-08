SPK_NAME = synocli-disk
SPK_VERS = 4.1
SPK_REV = 16
SPK_ICON = src/synocli-disk.png

# ATTENTION: build order of dependent packages matters
# more DEPENDS further down...
DEPENDS  = cross/ntfs-3g_ntfsprogs cross/e2fsprogs cross/testdisk
DEPENDS += cross/ncdu cross/davfs2 cross/lsscsi cross/ddrescue
DEPENDS += cross/disktype

OPTIONAL_DEPENDS  = cross/duf cross/gdu cross/tdu
OPTIONAL_DEPENDS += cross/dua cross/dua_2.30.0 cross/dutree
OPTIONAL_DEPENDS += cross/smartmontools
OPTIONAL_DEPENDS += cross/mergerfs
OPTIONAL_DEPENDS += cross/gpart
OPTIONAL_DEPENDS += cross/dar

MAINTAINER = SynoCommunity
DISPLAY_NAME = SynoCli Disk Tools

OPTIONAL_DESC =
SPK_COMMANDS =

include ../../mk/spksrc.archs.mk

ifneq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
# Tools built with go are not supported on PPC archs
DEPENDS += cross/duf cross/gdu cross/tdu
OPTIONAL_DESC := $(OPTIONAL_DESC)", duf, gdu, tdu"
SPK_COMMANDS += bin/duf bin/gdu bin/tdu
endif

ifneq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
# not supported on old PPC archs
OPTIONAL_DESC := $(OPTIONAL_DESC)", dua, dutree"
SPK_COMMANDS += bin/dua bin/dutree
ifneq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(PPC_ARCHS)),$(ARCH))
DEPENDS += cross/dua cross/dutree
else
# older version of dua for ARMv5 and qoriq
DEPENDS += cross/dua_2.30.0 cross/dutree
endif
endif


ifneq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
DEPENDS += cross/smartmontools
OPTIONAL_DESC := $(OPTIONAL_DESC)", smartmontools \(smartctl\)"
# smartctl of this package will not be found by path, because /bin/smartctl is found first
# you have to use smartctl7 (or /usr/local/bin/smartctl or /var/packages/synocli-disk/target/sbin/smartctl)
SPK_COMMANDS += sbin/smartctl7 sbin/smartctl sbin/smartd sbin/update-smart-drivedb
endif

ifneq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
DEPENDS += cross/gpart
OPTIONAL_DESC := $(OPTIONAL_DESC)", gpart"
SPK_COMMANDS += sbin/gpart

DEPENDS += cross/fuse3
DEPENDS += cross/s3backer
OPTIONAL_DESC := $(OPTIONAL_DESC)", fuse3, s3backer"
SPK_COMMANDS += bin/fusermount3 sbin/mount.fuse3
SPK_COMMANDS += bin/s3backer

else
DEPENDS += cross/fuse
OPTIONAL_DESC := $(OPTIONAL_DESC)", fuse"
SPK_COMMANDS += bin/fusermount bin/ulockmgr_server
endif

HOMEPAGE = https://github.com/SynoCommunity/spksrc/wiki/FAQ-SynoCliDisk
LICENSE  = Each tool is licensed under it\'s respective license.

WIKI_URL = "\<a target=\"_blank\" href=\"$(HOMEPAGE)\"\>FAQ SynoCliDisk\</a\>"

# Remarks: html in DESCRIPTION is not supported
DESCRIPTION = "SynoCli Disk Tools provides a number of small command-line utilities: e2fsprogs, ntfs-3g/ntfsprogs, testdisk, ncdu, davfs2, lsscsi, ddrescure$(OPTIONAL_DESC)."
STARTABLE = no
CHANGELOG  = "1. Update dar from v2.7.19 to v2.8.1 and add SFTP repository support. <br/>"
CHANGELOG += "2. Update davfs2 from v1.7.1 to v1.7.2. <br/>"
CHANGELOG += "3. Update dua from v2.31.0 to v2.32.0 (except for ARMv5 and qoriq). <br/>"
CHANGELOG += "4. Update duf from v0.8.1 to v0.9.1. <br/>"
CHANGELOG += "5. Update s3backer from v2.1.5 to v2.1.6. <br/>"
CHANGELOG += "<br/>For package details and specific licences see $(WIKI_URL)".


SPK_COMMANDS += bin/chattr bin/compile_et bin/lsattr bin/mk_cmds
SPK_COMMANDS += sbin/badblocks sbin/blkid sbin/debugfs
SPK_COMMANDS += sbin/dumpe2fs sbin/e2freefrag sbin/e2fsck sbin/e2image sbin/e2label
SPK_COMMANDS += sbin/e2mmpstatus sbin/e2scrub sbin/e2scrub_all sbin/e2undo sbin/e4crypt sbin/filefrag sbin/findfs
SPK_COMMANDS += sbin/fsck sbin/fsck.ext2 sbin/fsck.ext3 sbin/fsck.ext4
SPK_COMMANDS += sbin/logsave sbin/mke2fs sbin/mkfs.ext2 sbin/mkfs.ext3 sbin/mkfs.ext4
SPK_COMMANDS += sbin/mklost+found sbin/resize2fs sbin/tune2fs
SPK_COMMANDS += sbin/mkntfs sbin/ntfsclone sbin/ntfscp sbin/ntfslabel sbin/ntfsresize sbin/ntfsundelete
SPK_COMMANDS += bin/ntfs-3g.probe bin/ntfscat bin/ntfscluster bin/ntfscmp bin/ntfsfix bin/ntfsinfo bin/ntfsls
SPK_COMMANDS += bin/lowntfs-3g bin/ntfs-3g

SPK_COMMANDS += bin/testdisk bin/photorec bin/fidentify
SPK_COMMANDS += bin/ncdu
SPK_COMMANDS += sbin/mount.davfs sbin/umount.davfs
SPK_COMMANDS += bin/lsscsi
SPK_COMMANDS += bin/ddrescue bin/ddrescuelog
SPK_COMMANDS += bin/disktype

include ../../mk/spksrc.spk.mk

ifneq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(PPC_ARCHS)),$(ARCH))
ifeq ($(call version_ge, $(TC_GCC), 4.8),1)
DEPENDS += cross/mergerfs
OPTIONAL_DESC := $(OPTIONAL_DESC)", mergerfs"
SPK_COMMANDS += bin/mergerfs bin/mergerfs-fusermount sbin/mount.mergerfs
endif
endif

ifeq ($(call version_ge, $(TC_GCC), 4.9.3),1)
# DAR: Only archs with C++ compiler support for c++14 standard are supported
DEPENDS += cross/dar
OPTIONAL_DESC := $(OPTIONAL_DESC)", dar"
SPK_COMMANDS += bin/dar bin/dar_cp bin/dar_manager bin/dar_slave bin/dar_split bin/dar_xform
endif
