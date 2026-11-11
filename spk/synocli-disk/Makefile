SPK_NAME = synocli-disk
SPK_VERS = 4.1
SPK_REV = 16
SPK_ICON = src/synocli-disk.png

# ATTENTION: build order of dependent packages matters
# more DEPENDS further down...
DEPENDS  = cross/ntfs-3g_ntfsprogs cross/e2fsprogs cross/testdisk
DEPENDS += cross/ncdu cross/davfs2 cross/lsscsi cross/ddrescue
DEPENDS += cross/disktype

MAINTAINER = SynoCommunity
DISPLAY_NAME = SynoCli Disk Tools

OPTIONAL_DESC =
SPK_COMMANDS =

include ../../mk/spksrc.common.mk

# Each taken where its own floors admit the arch; descriptions and commands follow
# spksrc.spk.mk. mergerfs comes first: it fails to build once cross/fuse is installed.
$(call depend,cross/mergerfs,nop)
$(call depend,cross/duf,nop)
$(call depend,cross/gdu,nop)
$(call depend,cross/tdu,nop)
$(call depend,cross/dua,nop)
$(call depend,cross/dutree,nop)
$(call depend,cross/smartmontools,nop)
$(call depend,cross/gpart,nop)
$(call depend,cross/fuse3|cross/fuse,nop)
$(call depend,cross/s3backer,nop)
$(call depend,cross/dar,nop)

HOMEPAGE = https://docs.synocommunity.com/packages/synocli-disk/
LICENSE  = Each tool is licensed under its respective license.

DOCS_URL = "\<a target=\"_blank\" href=\"$(HOMEPAGE)\"\>SynoCli Disk Tools\</a\>"

# Remarks: html in DESCRIPTION is not supported
DESCRIPTION = "SynoCli Disk Tools provides a number of small command-line utilities: e2fsprogs, ntfs-3g/ntfsprogs, testdisk, ncdu, davfs2, lsscsi, ddrescue$(OPTIONAL_DESC)."
STARTABLE = no
CHANGELOG  = "1. Update dar from v2.7.19 to v2.8.1 and add SFTP repository support. <br/>"
CHANGELOG += "2. Update davfs2 from v1.7.1 to v1.7.2. <br/>"
CHANGELOG += "3. Update dua from v2.31.0 to v2.32.0 (except for ARMv5, qoriq and x86). <br/>"
CHANGELOG += "4. Update duf from v0.8.1 to v0.9.1. <br/>"
CHANGELOG += "5. Update s3backer from v2.1.5 to v2.1.6. <br/>"
CHANGELOG += "<br/>For package details and specific licences see $(DOCS_URL)".


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

# The optional tools taken above, in the description and the commands.
ifneq ($(filter cross/mergerfs,$(DEPENDS)),)
OPTIONAL_DESC := $(OPTIONAL_DESC)", mergerfs"
SPK_COMMANDS += bin/mergerfs bin/mergerfs-fusermount sbin/mount.mergerfs
endif

ifneq ($(filter cross/duf,$(DEPENDS)),)
OPTIONAL_DESC := $(OPTIONAL_DESC)", duf"
SPK_COMMANDS += bin/duf
endif

ifneq ($(filter cross/gdu,$(DEPENDS)),)
OPTIONAL_DESC := $(OPTIONAL_DESC)", gdu"
SPK_COMMANDS += bin/gdu
endif

ifneq ($(filter cross/tdu,$(DEPENDS)),)
OPTIONAL_DESC := $(OPTIONAL_DESC)", tdu"
SPK_COMMANDS += bin/tdu
endif

ifneq ($(filter cross/dua,$(DEPENDS)),)
OPTIONAL_DESC := $(OPTIONAL_DESC)", dua"
SPK_COMMANDS += bin/dua
endif

ifneq ($(filter cross/dutree,$(DEPENDS)),)
OPTIONAL_DESC := $(OPTIONAL_DESC)", dutree"
SPK_COMMANDS += bin/dutree
endif

ifneq ($(filter cross/smartmontools,$(DEPENDS)),)
OPTIONAL_DESC := $(OPTIONAL_DESC)", smartmontools \(smartctl\)"
# smartctl of this package will not be found by path, because /bin/smartctl is found first
# you have to use smartctl7 (or /usr/local/bin/smartctl or /var/packages/synocli-disk/target/sbin/smartctl)
SPK_COMMANDS += sbin/smartctl7 sbin/smartctl sbin/smartd sbin/update-smart-drivedb
endif

ifneq ($(filter cross/gpart,$(DEPENDS)),)
OPTIONAL_DESC := $(OPTIONAL_DESC)", gpart"
SPK_COMMANDS += sbin/gpart
endif

ifneq ($(filter cross/fuse3,$(DEPENDS)),)
OPTIONAL_DESC := $(OPTIONAL_DESC)", fuse3"
SPK_COMMANDS += bin/fusermount3 sbin/mount.fuse3
endif

ifneq ($(filter cross/s3backer,$(DEPENDS)),)
OPTIONAL_DESC := $(OPTIONAL_DESC)", s3backer"
SPK_COMMANDS += bin/s3backer
endif

ifneq ($(filter cross/fuse,$(DEPENDS)),)
OPTIONAL_DESC := $(OPTIONAL_DESC)", fuse"
SPK_COMMANDS += bin/fusermount bin/ulockmgr_server
endif

ifneq ($(filter cross/dar,$(DEPENDS)),)
OPTIONAL_DESC := $(OPTIONAL_DESC)", dar"
SPK_COMMANDS += bin/dar bin/dar_cp bin/dar_manager bin/dar_slave bin/dar_split bin/dar_xform
endif
