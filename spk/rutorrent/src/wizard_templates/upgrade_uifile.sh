
{
  echo "["
  if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
    dsm_pre7_permissions_step;
  fi;
  echo "]";
}> "${SYNOPKG_TEMP_LOGFILE}"
