# Package specific behaviors
# Sourced script by generic installer and start-stop-status scripts

KERNEL_MIN="4.4"
KERNEL_RUNNING=$(uname -r)
STATUS=$(printf '%s\n%s' "${KERNEL_MIN}" "${KERNEL_RUNNING}" | sort -VCr && echo $?)
FFMPEG_VER=$(printf %.1s "$SYNOPKG_PKGVER")
FFMPEG_DIR=/var/packages/ffmpeg${FFMPEG_VER}/target
iHD=${FFMPEG_DIR}/lib/iHD_drv_video.so

###
### Disable Intel iHD driver on older kernels
### $(uname -r) <= ${KERNEL}
###
disable_iHD ()
{
    if [ "${STATUS}" = "0" ]; then
       [ -s ${iHD} ] && mv ${iHD} ${iHD}-DISABLED 2>/dev/null
    fi
}

service_postinst ()
{
    if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ];then
        # setuid for proper vaapi access
        chmod u+s ${FFMPEG_DIR}/bin/ffmpeg
        chmod u+s ${FFMPEG_DIR}/bin/vainfo
    fi

    disable_iHD
}

service_postupgrade ()
{
    if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ];then
        # setuid for proper vaapi access
        chmod u+s ${FFMPEG_DIR}/bin/ffmpeg
        chmod u+s ${FFMPEG_DIR}/bin/vainfo
    fi

    disable_iHD
}
