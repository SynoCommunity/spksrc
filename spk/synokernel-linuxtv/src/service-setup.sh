INI="/usr/local/${SYNOPKG_PKGNAME}/etc/${SYNOPKG_PKGNAME}.ini"
CFG="/usr/local/${SYNOPKG_PKGNAME}/etc/${SYNOPKG_PKGNAME}.cfg"
UDEV=60-${SYNOPKG_PKGNAME}.rules

write_config() {
   # Drop variables based on .cfg file to
   # generate the .ini configuration file
   # based on user option selection
   echo "default=true" > ${INI}
   for option in $(cat ${CFG} | grep -v -e default -e '^#' | tr -d '\\' | grep '^[A-z0-9].*=' | cut -f1 -d"=" | sort -u); do
      var=${option%%=*}
      [ -n "${!var}" ] \
         && echo "${var}=${!var}" >> ${INI} \
         || echo "${var}=false"   >> ${INI}
   done
}

service_postinst() {
    [ ! -f ${INI} ] && mkdir -p /usr/local/${SYNOPKG_PKGNAME}/etc
    write_config
}

service_preupgrade() {
    [ -f ${INI} ] && mv ${INI} /tmp/${SYNOPKG_PKGNAME}.ini
}

service_postupgrade() {
    if [ ! -f ${INI} ]; then
        mkdir -p /usr/local/${SYNOPKG_PKGNAME}/etc
        mv /tmp/${SYNOPKG_PKGNAME}.ini /usr/local/${SYNOPKG_PKGNAME}/etc
    fi
    write_config
}

service_postuninst ()
{
    # ensure to remove rules for USB serial permissions, created at service start
    rm -f /lib/udev/rules.d/${UDEV} >> "${INST_LOG}"
    exit 0
}
