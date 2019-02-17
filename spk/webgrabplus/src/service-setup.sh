# Package specific behaviors
# Sourced script by generic installer and start-stop-status scripts

WEBGRABFILE="${SYNOPKG_PKGDEST}/bin/run.sh"
TVGRABFILE="${SYNOPKG_PKGDEST}/bin/tv_grab_wg++"
LOGFILE="${SYNOPKG_PKGDEST}/var/WebGrab++.log.txt"
HOMEDIR="${SYNOPKG_PGKDEST}/var"

service_postinst ()
{
    # Ensure files in bin are executable
    chmod +x ${TVGRABFILE}
    chmod +x ${WEBGRABFILE}

    # Create relevant links
    $LN ${WEBGRABFILE} /usr/local/bin/webgrabplus
    touch ${LOGFILE}
    $LN ${LOGFILE} /usr/local/webgrabplus/var/webgrabplus.log

    # Download latest siteini packages from github if wanted
    if [ ${check_gitdl} == "true" ]; then
        echo "Download and install latest EPG (siteini) packages from github" >> ${INST_LOG}
        wget https://github.com/SilentButeo2/webgrabplus-siteinipack/archive/master.tar.gz -O ${HOMEDIR}/siteini.tar.gz > /dev/null
        tar xvzf ${HOMEDIR}/siteini.tar.gz -C ${HOMEDIR} > /dev/null
        $CP ${HOMEDIR}/webgrabplus-siteinipack-master/siteini.pack/* ${HOMEDIR}/siteini.pack
        $RM ${HOMEDIR}/webgrabplus-siteinipack-master
        $RM ${HOMEDIR}/siteini.tar.gz
    else
        echo "Skipping download of latest EPG (siteini) packages from github" >> ${INST_LOG}
    fi

    # Create link for Tvheadend if wanted
    if [ ${check_lntvh} == "true" ]; then
        echo "Link tv_grab_wg++ into /usr/bin" >> ${INST_LOG}
        $LN ${TVGRABFILE} /usr/local/bin/tv_grab_wg++
    else
        echo "Skipping link creation for Tvheadend" >> ${INST_LOG}
    fi

    # Create crontab entry if wanted
    if [ ${check_cron} == "true" ]; then
        grep webgrabplus /etc/crontab > /dev/null
        if [ $? -eq 1 ]; then
            echo "Create crontab entry to execute WebGrab++ at 1:24 am each day" >> ${INST_LOG}
            echo "24      1       *       *       *       root    ${WEBGRABFILE}" >> /etc/crontab
            synoservice -restart crond > /dev/null
        else
            echo "Contrab entry for WebGrab++ already available. Skipping addition..." >> ${INST_LOG}
        fi
    else
        echo "Skipping creation of crontab entry" >> ${INST_LOG}
    fi
}

service_preuninst ()
{
    if [ -e "/usr/local/bin/webgrabplus" ]; then
        $RM /usr/local/bin/webgrabplus
    fi
    if [ -e "/usr/local/bin/tv_grab_wg++" ]; then
        $RM "/usr/local/bin/tv_grab_wg++"
    fi
    sed -i '/webgrabplus/d' /etc/crontab
}
