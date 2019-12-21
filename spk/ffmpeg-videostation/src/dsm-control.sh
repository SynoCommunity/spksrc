#!/bin/sh

DNAME="ffmpeg-videostation"

start_daemon ()
{
    synoservicectl --stop pkgctl-VideoStation

    mv /var/packages/VideoStation/target/bin/ffmpeg /var/packages/VideoStation/target/bin/ffmpeg.old
    mv /var/packages/VideoStation/target/bin/ffprobe /var/packages/VideoStation/target/bin/ffprobe.old
    ln -sf /var/packages/ffmpeg/target/bin/ffmpeg /var/packages/VideoStation/target/bin/ffmpeg
    ln -sf /var/packages/ffmpeg/target/bin/ffprobe /var/packages/VideoStation/target/bin/ffprobe

    cp /var/packages/VideoStation/target/lib/libsynovte.so /var/packages/VideoStation/target/lib/libsynovte.so.old
    sed -i 's/eac3/OFF0/' /var/packages/VideoStation/target/lib/libsynovte.so
    sed -i 's/truehd/IGNORE/' /var/packages/VideoStation/target/lib/libsynovte.so
    sed -i 's/dts/OFF/' /var/packages/VideoStation/target/lib/libsynovte.so
    sed -i 's/main 10/IGNORE/' /var/packages/VideoStation/target/lib/libsynovte.so

    synoservicectl --start pkgctl-VideoStation
}

stop_daemon ()
{
    synoservicectl --stop pkgctl-VideoStation

    rm /var/packages/VideoStation/target/bin/ffmpeg
    rm /var/packages/VideoStation/target/bin/ffprobe

    mv /var/packages/VideoStation/target/bin/ffmpeg.old /var/packages/VideoStation/target/bin/ffmpeg
    mv /var/packages/VideoStation/target/bin/ffprobe.old /var/packages/VideoStation/target/bin/ffprobe
    mv /var/packages/VideoStation/target/lib/libsynovte.so.old /var/packages/VideoStation/target/lib/libsynovte.so

    synoservicectl --start pkgctl-VideoStation
}

daemon_status ()
{
    test -L /var/packages/VideoStation/target/bin/ffmpeg -a -e /var/packages/VideoStation/target/lib/libsynovte.so.old
    return $?
}

case $1 in
    start)
        if daemon_status; then
            echo "${DNAME} is enabled"
            exit 0
        else
            echo "Enabling ${DNAME} ..."
            start_daemon
            exit $?
        fi
        ;;
    stop)
        if daemon_status; then
            echo "Disabling ${DNAME} ..."
            stop_daemon
            exit $?
        else
            echo "${DNAME} is not enabled"
            exit 0
        fi
        ;;
    status)
        if daemon_status; then
            echo "${DNAME} is enabled"
            exit 0
        else
            echo "${DNAME} is not enabled"
            exit 3
        fi
        ;;
    log)
        exit 1
        ;;
    *)
        exit 1
        ;;
esac
