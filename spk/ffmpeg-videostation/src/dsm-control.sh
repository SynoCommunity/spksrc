#!/bin/sh

DNAME="ffmpeg-videostation"

start_daemon ()
{
    synoservicectl --stop pkgctl-VideoStation

    source=/var/packages/ffmpeg/target
    destination=/var/packages/VideoStation/target

    for item in 'ffmpeg ffprobe vainfo'
    do
        # In case of NAS powerfailure make sure destination doesn't already
        # exists and original VideoStation ain't already a symbolic limk
        # (do not overwrite backup OR copy symlink)
        [ ! -e $destination/bin/$item.orig -a ! -L $destination/bin/$item ] && mv $destination/bin/$item $destination/bin/$item.orig
    done

    for item in 'ffprobe vainfo'
    do
        # In case of NAS powerfailure make sure source files exist
        # and and destination doesn't exist (do not overwrite)
        [ -e $source/bin/$item -a ! -e $destination/bin/$item ] && ln -sfT $source/bin/$item $destination/bin/$item
    done

    # Download latest version of ffmpeg wrapper from @BenjaminPoncet
    [ ! -e $destination/bin/$ffmpeg ] \
       && curl -o $destination/bin/ffmpeg https://gist.github.com/BenjaminPoncet/bbef9edc1d0800528813e75c1669e57e
    [ $? -eq 0 ] \
       && chmod 0755 $destination/bin/ffmpeg

    # In case of NAS powerfailure make sure:
    # a) backup file doesn't exist & original file does
    [ ! $destination/lib/libsynovte.so.orig -a -s $destination/lib/libsynovte.so ] \
      && sed -i'.old' -e 's/eac3/OFF0/' \
                      -e 's/truehd/IGNORE/' \
                      -e 's/dts/OFF/' \
                      -e 's/main 10/IGNORE0/' \
                      $destination/lib/libsynovte.so

    synoservicectl --start pkgctl-VideoStation
}

stop_daemon ()
{
    synoservicectl --stop pkgctl-VideoStation

    target=/var/packages/VideoStation/target

    for item in 'bin/ffmpeg bin/ffprobe bin/vainfo lib/libsynovte.so'
    do
        # If backup file exist then delete and put backup file in place
        if [ -e $target/$item.orig ]; then
           rm -f $target/$item
           mv $target/$item.orig $target/$item
        fi
    done

    synoservicectl --start pkgctl-VideoStation
}

daemon_status ()
{
    target=/var/packages/VideoStation/target

    test    -L $target/bin/ffmpeg \
         -a -L $target/bin/ffprobe \
         -a -L $target/bin/vainfo \
         -a -e $target/lib/libsynovte.so.orig
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
