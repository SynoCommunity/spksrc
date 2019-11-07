SBIN_COMMANDS="badblocks blkid debugfs dumpe2fs e2freefrag e2fsck e2image e2label e2mmpstatus e2scrub"
SBIN_COMMANDS+=" e2scrub_all e2undo e4crypt filefrag findfs fsck fsck.ext2 fsck.ext3 fsck.ext4 logsave mke2fs mkfs.ext2 mkfs.ext3 mkfs.ext4 mklost+found resize2fs tune2fs uuidd"

service_postinst ()
{
    for cmd in $SBIN_COMMANDS
    do
        if [ -e "${SYNOPKG_PKGDEST}/sbin/$cmd" ]; then
            ln -s "${SYNOPKG_PKGDEST}/sbin/$cmd" "/usr/local/sbin/$cmd"
        fi
    done
}

service_postuninst ()
{
    for cmd in $SBIN_COMMANDS
    do
        if [ -L "/usr/local/sbin/$cmd" ]; then
            rm -f "/usr/local/sbin/$cmd"
        fi
    done
}
