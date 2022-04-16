# Package specific behaviors
# Sourced script by generic installer and start-stop-status scripts

ARCHS="apollolake geminilake"
UNAME=$(uname -a)
SUPPORTED=FALSE
iHD=/var/packages/ffmpeg/target/lib/iHD_drv_video.so

disable_iHD ()
{
    for arch in ${ARCHS}
    do
       echo ${UNAME} | grep -q ${arch} && SUPPORTED=TRUE
    done

    if [ "${SUPPORTED}" = "FALSE" ]; then
       [ -s ${iHD} ] && mv ${iHD} ${iHD}-DISABLED 2>/dev/null
    fi
}

service_postinst ()
{
    if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ];then
        # setuid for proper vaapi access
        chmod u+s /var/packages/ffmpeg/target/bin/ffmpeg
        chmod u+s /var/packages/ffmpeg/target/bin/vainfo
    fi

    disable_iHD
}

service_postupgrade ()
{
    if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ];then
        # setuid for proper vaapi access
        chmod u+s /var/packages/ffmpeg/target/bin/ffmpeg
        chmod u+s /var/packages/ffmpeg/target/bin/vainfo
    fi

    disable_iHD
}
