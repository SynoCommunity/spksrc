# https://github.com/dotnet/core/issues/4011
[ -z "$DOTNET_BUNDLE_EXTRACT_BASE_DIR" ] && export DOTNET_BUNDLE_EXTRACT_BASE_DIR="${XDG_CACHE_HOME:-"/var/packages/jellyfin/target/var/"}/dotnet_bundle_extract"

JELLYFIN_ARGS="--service \
 --package-name synology \
 -d ${SYNOPKG_PKGDEST}/var/data \
 -C ${SYNOPKG_PKGDEST}/var/cache \
 -c ${SYNOPKG_PKGDEST}/var/config \
 -l ${SYNOPKG_PKGDEST}/var/log \
 -w ${SYNOPKG_PKGDEST}/web \
 --ffmpeg /var/packages/ffmpeg/target/bin/ffmpeg"

SERVICE_COMMAND="env LD_LIBRARY_PATH=${SYNOPKG_PKGDEST}/lib ${SYNOPKG_PKGDEST}/share/jellyfin ${JELLYFIN_ARGS}"

SVC_BACKGROUND=y
SVC_WRITE_PID=y

GROUP=sc-media

service_postinst ()
{
    # allow ffmpeg access
    chmod 775 /volume1/@appstore/jellyfin/var/data/transcodes
}
