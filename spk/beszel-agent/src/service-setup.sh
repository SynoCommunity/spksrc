export PATH="/usr/local/bin:$PATH"

KEY_FILE="${SYNOPKG_PKGVAR}/key.pub"
EXTRA_FS_FILE="${SYNOPKG_PKGVAR}/extra_fs.conf"
SMART_DEVICES_FILE="${SYNOPKG_PKGVAR}/smart_devices.conf"

SKIP_SYSTEMD=false


# Read the public key from the saved file
if [ -f "${KEY_FILE}" ]; then
    BESZEL_PUBLIC_KEY=$(cat "${KEY_FILE}")
    export KEY="${BESZEL_PUBLIC_KEY}"
fi

# Read the extra filesystems from the saved file
if [ -f "${EXTRA_FS_FILE}" ]; then
    EXTRA_FS=$(cat "${EXTRA_FS_FILE}")
    export EXTRA_FILESYSTEMS="${EXTRA_FS}"
fi

# Read the SMART devices from the saved file
if [ -f "${SMART_DEVICES_FILE}" ]; then
    SMART_DEVS=$(cat "${SMART_DEVICES_FILE}")
    export SMART_DEVICES="${SMART_DEVS}"
fi

BESZEL_AGENT="${SYNOPKG_PKGDEST}/bin/beszel-agent"
SERVICE_COMMAND="${BESZEL_AGENT}"

SVC_BACKGROUND=y
SVC_WRITE_PID=y

service_postinst ()
{
    # Save the public key only if provided
    if [ -n "${wizard_pub_key}" ]; then
        echo "${wizard_pub_key}" > "${KEY_FILE}"
    fi

    # Save the extra filesystems only if provided
    if [ -n "${wizard_extra_fs}" ]; then
        echo "${wizard_extra_fs}" > "${EXTRA_FS_FILE}"
    fi

    # Save the SMART devices only if provided
    if [ -n "${wizard_smart_devices}" ]; then
        echo "${wizard_smart_devices}" > "${SMART_DEVICES_FILE}"
    fi
}
