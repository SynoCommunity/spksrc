# zerotier-one (ZeroTier) service definition.
#
# The daemon runs as the package user (sc-zerotier-one), never as root, under a
# supervisor that restarts it if it stops. It needs CAP_NET_ADMIN and
# /dev/net/tun: DSM 7 refuses both to third-party packages, so the install
# wizard creates a root boot-up task ("zerotier-one") that runs a small guard;
# the guard grants them, also after every upgrade. No other package is involved.

ZEROTIER="${SYNOPKG_PKGDEST}/bin/zerotier-one"
# The supervisor runs zerotier-one with -U (skip its own root check).
SERVICE_COMMAND="/bin/sh ${SYNOPKG_PKGDEST}/bin/zerotier-one-supervise"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

zt_tun_ready ()
{
    [ -c /dev/net/tun ] && [ -w /dev/net/tun ]
}

zt_caps_ready ()
{
    [ "$(stat -c '%i:%Y:%s' "${ZEROTIER}" 2>/dev/null)" = "$(cat /run/zerotier-one.caps 2>/dev/null)" ]
}

zt_migration_pending ()
{
    [ -e /run/zerotier-one.migrating ] && [ ! -e "${SYNOPKG_PKGVAR}/identity.secret" ]
}

service_prestart ()
{
    # Never let zerotier-one invent a new identity when one exists but cannot be
    # read: the node would come up under a new address, unknown to the network.
    if [ -e "${SYNOPKG_PKGVAR}/identity.secret" ] && [ ! -r "${SYNOPKG_PKGVAR}/identity.secret" ]; then
        echo "ERROR: ${SYNOPKG_PKGVAR}/identity.secret is not readable by $(id -un)."
        echo "The zerotier-one guard fixes it within 30 seconds."
        exit 1
    fi
    # /bin/getcap is root-only on DSM, so the root guard records in /run the
    # binary it granted the capability to. After an install or upgrade the
    # guard loads tun and grants the capability on its next round (every 5
    # seconds) while Package Center starts the package at once: wait for it
    # rather than fail. On a first install the wizard has just run the boot-up
    # task, so give the guard 15 seconds to appear. The guard runs as root, so
    # its liveness is checked through /proc, not kill -0.
    if ! zt_tun_ready || ! zt_caps_ready; then
        echo "waiting for the guard to prepare /dev/net/tun and the network capability of ${ZEROTIER}"
        i=0
        while [ $i -lt 60 ]; do
            zt_tun_ready && zt_caps_ready && break
            guard_pid=$(cat /run/zerotier-one-guard.pid 2>/dev/null)
            [ $i -ge 15 ] && { [ -z "${guard_pid}" ] || [ ! -d "/proc/${guard_pid}" ]; } && break
            sleep 1; i=$((i + 1))
        done
    fi
    if ! zt_tun_ready; then
        echo "ERROR: /dev/net/tun is not ready: is the zerotier-one boot-up task present in Task Scheduler?"
        exit 1
    fi
    if ! zt_caps_ready; then
        echo "ERROR: ZeroTier has no network permission yet. Check that the zerotier-one boot-up task exists in Control Panel > Task Scheduler and run it."
        exit 1
    fi
    # While the guard still has to move over the identity of an older ZeroTier
    # package it keeps /run/zerotier-one.migrating. Starting now would make
    # zerotier-one create a new identity, unknown to the node's networks.
    if zt_migration_pending; then
        echo "waiting for the guard to move over the identity of the previous ZeroTier package"
        i=0
        while [ $i -lt 40 ] && zt_migration_pending; do sleep 1; i=$((i + 1)); done
    fi
    if zt_migration_pending; then
        echo "ERROR: the identity of the previous ZeroTier package has not been moved over yet, because that ZeroTier is still running. Stop it (or uninstall it: its data is kept), then start this package again."
        exit 1
    fi
    # A zerotier-one left behind by a supervisor that died hard would hold the
    # port: stop it first.
    orphan=$(cat "${SYNOPKG_PKGVAR}/zerotier-one.pid" 2>/dev/null)
    if [ -n "${orphan}" ] && kill -0 "${orphan}" 2>/dev/null; then
        echo "stopping leftover zerotier-one (pid ${orphan})"
        kill "${orphan}" 2>/dev/null
        sleep 5
        kill -9 "${orphan}" 2>/dev/null
    fi
}

service_postinst ()
{
    # Optional network from the install wizard: zerotier-one joins every
    # network listed in networks.d when it starts.
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ] && [ -n "${wizard_network_id}" ]; then
        network_id=$(echo "${wizard_network_id}" | tr 'A-F' 'a-f' | tr -d ' ')
        case "${network_id}" in
            *[!0-9a-f]*) echo "Ignoring invalid network ID: ${wizard_network_id}" ;;
            *)
                if [ ${#network_id} -eq 16 ]; then
                    mkdir -p "${SYNOPKG_PKGVAR}/networks.d"
                    : > "${SYNOPKG_PKGVAR}/networks.d/${network_id}.conf"
                fi
                ;;
        esac
    fi
}
