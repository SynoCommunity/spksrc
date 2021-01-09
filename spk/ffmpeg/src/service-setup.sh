# Package specific behaviors
# Sourced script by generic installer and start-stop-status scripts

service_postinst ()
{
    if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ];then
        # setuid for proper vaapi access
        chmod u+s /var/packages/ffmpeg/target/bin/ffmpeg
        chmod u+s /var/packages/ffmpeg/target/bin/vainfo
    fi
}

service_postupgrade ()
{
    if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ];then
        # setuid for proper vaapi access
        chmod u+s /var/packages/ffmpeg/target/bin/ffmpeg
        chmod u+s /var/packages/ffmpeg/target/bin/vainfo
    fi
}
