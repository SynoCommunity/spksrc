#!/bin/sh

old_version="${SYNOPKG_OLD_PKGVER%%-*}"

case "${old_version}" in
    4.2.*)
        cat > "${SYNOPKG_TEMP_LOGFILE}" <<'EOF'
[{
    "step_title": "RabbitMQ 4.4 upgrade requirements",
    "items": [{
        "desc": "RabbitMQ 4.4 requires the Khepri metadata store and all stable feature flags introduced in RabbitMQ 4.2."
    }, {
        "desc": "Before upgrading, enable all stable feature flags, including Khepri, and wait for the metadata migration to finish. You can do this from the Management UI under <b>Admin &gt; Feature Flags</b> or with the RabbitMQ command-line tools."
    }, {
        "desc": "The installer checks these requirements before starting the upgrade. If they are not met, the upgrade stops and RabbitMQ 4.2.8 remains installed."
    }, {
        "desc": "A full backup of the RabbitMQ data directory is created automatically before upgrading. Ensure enough free space is available and allow extra time for the backup."
    }]
}]
EOF
        ;;
    4.3.*|4.4.*)
        echo "[]" > "${SYNOPKG_TEMP_LOGFILE}"
        ;;
    *)
        cat > "${SYNOPKG_TEMP_LOGFILE}" <<'EOF'
[{
    "step_title": "RabbitMQ upgrade not supported",
    "invalid_next_disabled_v2": true,
    "items": [{
        "desc": "RabbitMQ 4.4 can only be upgraded from RabbitMQ 4.2.x or newer."
    }, {
        "type": "textfield",
        "desc": "This upgrade path is not supported. Upgrade to RabbitMQ 4.2.8 first, then retry this upgrade.",
        "subitems": [{
            "key": "wizard_rabbitmq_upgrade_blocked",
            "desc": "Upgrade to RabbitMQ 4.2.8 first",
            "defaultValue": "Unsupported upgrade path",
            "validator": {
                "fn": "function() { return 'Upgrade to RabbitMQ 4.2.8 first, then retry this upgrade.'; }"
            }
        }]
    }]
}]
EOF
        ;;
esac

exit 0
