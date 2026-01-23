PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"
SSLH="${SYNOPKG_PKGDEST}/bin/sslh"
CFG_FILE="${SYNOPKG_PKGVAR}/sslh.cfg"
SERVICE_COMMAND="${SSLH} --config=${CFG_FILE}"


create_sslh_link ()
{
  _target=${1}
  if [ -z "${_target}" ]; then
    _target=sslh-fork
  fi

  echo "install ${_target} as sslh"
  cd ${SYNOPKG_PKGDEST}/bin && ln -sf ${_target} ${SSLH}
}

service_postinst ()
{
   if [ "${wizard_sslh_select}" = "true" ]; then
      create_sslh_link "sslh-select"
   elif [ "${wizard_sslh_ev}" = "true" ]; then
      create_sslh_link "sslh-ev"
   else
      create_sslh_link "sslh-fork"
   fi
}
