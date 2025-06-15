# configure font variables
export FONTCONFIG_PATH="${SYNOPKG_PKGVAR}/fonts"
export XDG_CACHE_HOME="${SYNOPKG_PKGVAR}/fonts"
export XDG_CONFIG_HOME="${SYNOPKG_PKGDEST}/share/dejavu"
export XDG_DATA_HOME="${SYNOPKG_PKGDEST}/share/dejavu"

JELLYFIN_ARGS="--service \
 --package-name synology \
 -d ${SYNOPKG_PKGVAR}/data \
 -C ${SYNOPKG_PKGVAR}/cache \
 -c ${SYNOPKG_PKGVAR}/config \
 -l ${SYNOPKG_PKGVAR}/log \
 -w ${SYNOPKG_PKGDEST}/web \
 --ffmpeg /var/packages/ffmpeg7/target/bin/ffmpeg"

SERVICE_COMMAND="${SYNOPKG_PKGDEST}/share/jellyfin ${JELLYFIN_ARGS}"

SVC_BACKGROUND=y
SVC_WRITE_PID=y

GROUP=sc-media

service_postinst ()
{
    if [ "$SYNOPKG_DSM_VERSION_MAJOR" -ge 7 ]; then
        mkdir -p --mode=0777 /var/packages/jellyfin/var/data/transcodes
    fi
}
