# shellcheck shell=sh

service_save() {
    echo "Back up /etc"
    $MV "$SYNOPKG_PKGDEST"/etc "$TMP_DIR"
}

service_restore() {
    echo "Restore /etc"
    $RM "$SYNOPKG_PKGDEST"/etc
    $MV "$TMP_DIR"/etc "$SYNOPKG_PKGDEST"
}
