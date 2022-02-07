DOTNET_INSTALLER="${SYNOPKG_PKGDEST}/dotnet-install.sh"
DOTNET="${SYNOPKG_PKGDEST}/dotnet"

# Packages that depend on .NET must set
# DOTNET_ROOT=/volume1/@appstore/dotnet-sdk

service_postinst ()
{
    wget -O "${DOTNET_INSTALLER}" "https://dotnet.microsoft.com/download/dotnet-core/scripts/v1/dotnet-install.sh"

    # Stop if download failed
    if [ ! -r "${DOTNET_INSTALLER}" ]; then
        echo "Failed to download installer, please check the internet connection of your device."
        exit 1
    fi
    dotnet_version=$(echo ${SYNOPKG_PKGVER} | sed 's/\-.*//') # strip revision
    install_command="${DOTNET_INSTALLER} --version ${dotnet_version} --install-dir ${SYNOPKG_PKGDEST}"

    if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ]; then
        # Install as sc-dotnet-runtime user, for correct permissions
        chmod +x "${NZBGET_INSTALLER}"
        su ${EFF_USER} -s /bin/sh -c "${install_command}"
    else
        env HOME=${SYNOPKG_PKGHOME} /bin/sh -c "${install_command}"
    fi

    if [ ! -r "${DOTNET}" ]; then
        echo "The installer failed to install dotnet-runtime. Please report the log below to SynoCommunity:"
        echo "${INST_LOG}"
        exit 1
    fi

    ## add dotnet cli script with environment variables
    cat >"${DOTNET}-env" <<EOL
#!/bin/sh

if [ \$(echo "\$PATH"|grep -c .dotnet/tools) -eq 0 ]; then
    export PATH="\$PATH:\$HOME/.dotnet/tools"
fi

env DOTNET_ROOT=${SYNOPKG_PKGDEST} LD_LIBRARY_PATH=${SYNOPKG_PKGDEST}/lib \$@
EOL
    chmod +x "${DOTNET}-env"
}
