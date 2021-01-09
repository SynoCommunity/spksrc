# shellcheck shell=sh

service_save() {
  {
    echo "Back up /etc"
    $MV "$SYNOPKG_PKGDEST"/etc "$TMP_DIR"
  } >>"$INST_LOG" 2>&1
}

service_restore() {
  {
    echo "Restore /etc"
    $RM "$SYNOPKG_PKGDEST"/etc
    $MV "$TMP_DIR"/etc "$SYNOPKG_PKGDEST"
  } >>"$INST_LOG" 2>&1
}
