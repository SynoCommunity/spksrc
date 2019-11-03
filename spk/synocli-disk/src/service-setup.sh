
BIN_COMMANDS="chattr compile_et lsattr mk_cmds uuidgen fusermount ulockmgr_server testdisk photorec fidentify"
BIN_COMMANDS+=" ncdu lsscsi dar dar_cp dar_manager dar_slave dar_split dar_xform"
BINS_COMMANDS="badblocks blkid debugfs dumpe2fs e2freefrag e2fsck e2image e2label e2mmpstatus e2scrub"
BINS_COMMANDS+=" e2scrub_all e2undo e4crypt filefrag findfs fsck fsck.ext2 fsck.ext3 fsck.ext4 logsave mke2fs mkfs.ext2 mkfs.ext3 mkfs.ext4 mklost+found resize2fs tune2fs uuidd"
BINS_COMMANDS+=" mount.davfs umount.davfs"

service_postinst ()
{
    for cmd in $BIN_COMMANDS
    do
        if [ -e "${SYNOPKG_PKGDEST}/bin/$cmd" ]; then
            ln -s "${SYNOPKG_PKGDEST}/bin/$cmd" "/usr/local/bin/$cmd"
        fi
    done

    for cmd in $BINS_COMMANDS
    do
        if [ -e "${SYNOPKG_PKGDEST}/bins/$cmd" ]; then
            ln -s "${SYNOPKG_PKGDEST}/bins/$cmd" "/usr/local/bins/$cmd"
        fi
    done
}

service_postuninst ()
{
    for cmd in $BIN_COMMANDS
        do
        if [ -e "/usr/local/bin/$cmd" ]; then
            rm -f "/usr/local/bin/$cmd"
        fi
    done
    for cmd in $BINS_COMMANDS
        do
        if [ -e "/usr/local/bins/$cmd" ]; then
            rm -f "/usr/local/bins/$cmd"
        fi
    done
}
