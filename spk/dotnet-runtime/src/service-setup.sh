DOTNET_INSTALLER="${SYNOPKG_PKGDEST}/dotnet-install.sh"
DOTNET="${SYNOPKG_PKGDEST}/dotnet"

# Packages that depend on .NET must set
# DOTNET_ROOT=/volume1/@appstore/dotnet-runtime

service_postinst ()
{
    wget -O "${DOTNET_INSTALLER}" "https://dotnet.microsoft.com/download/dotnet-core/scripts/v1/dotnet-install.sh" >> ${INST_LOG} 2>&1

    # Stop if download failed
    if [ ! -r "${DOTNET_INSTALLER}" ]; then
        echo "Failed to download installer, please check the internet connection of your device."
        exit 1
    fi
    dotnet_version=$(echo ${SYNOPKG_PKGVER} | sed 's/\-.*//') # strip revision
    install_command="${DOTNET_INSTALLER} --version ${dotnet_version} --install-dir ${SYNOPKG_PKGDEST} --runtime dotnet"

    if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ]; then
        # Install as sc-dotnet-runtime user, for correct permissions
        chmod +x "${NZBGET_INSTALLER}"
        su ${EFF_USER} -s /bin/sh -c "${install_command}" >> ${INST_LOG} 2>&1
    else
        env HOME=${SYNOPKG_PKGHOME} /bin/sh -c "${install_command}" >> ${INST_LOG} 2>&1
    fi

    if [ ! -r "${DOTNET}" ]; then
        echo "The installer failed to install dotnet-runtime. Please report the log below to SynoCommunity:"
        echo "${INST_LOG}"
        exit 1
    fi
}
