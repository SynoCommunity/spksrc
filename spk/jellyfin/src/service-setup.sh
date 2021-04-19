# https://github.com/dotnet/core/issues/4011
[ -z "$DOTNET_BUNDLE_EXTRACT_BASE_DIR" ] && export DOTNET_BUNDLE_EXTRACT_BASE_DIR="${XDG_CACHE_HOME:-"/var/packages/jellyfin/target/var/"}/dotnet_bundle_extract"

JELLYFIN_ARGS="--service \
 --package-name synology \
 -d ${SYNOPKG_PKGVAR}/data \
 -C ${SYNOPKG_PKGVAR}/cache \
 -c ${SYNOPKG_PKGVAR}/config \
 -l ${SYNOPKG_PKGVAR}/log \
 -w ${SYNOPKG_PKGDEST}/web \
 --ffmpeg /var/packages/ffmpeg/target/bin/ffmpeg"

SERVICE_COMMAND="env LD_LIBRARY_PATH=${SYNOPKG_PKGDEST}/lib ${SYNOPKG_PKGDEST}/share/jellyfin ${JELLYFIN_ARGS}"

SVC_BACKGROUND=y
SVC_WRITE_PID=y

GROUP=sc-media

service_postinst ()
{
    if [ "$SYNOPKG_DSM_VERSION_MAJOR" -ge 7 ]; then
        mkdir -p --mode=0777 /var/packages/jellyfin/var/data/transcodes
    fi
}
