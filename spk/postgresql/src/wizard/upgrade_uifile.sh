#!/bin/sh

OLD_VERSION="${SYNOPKG_OLD_PKGVER%%-*}"
OLD_MAJOR="${OLD_VERSION%%.*}"
OLD_MINOR="${OLD_VERSION#*.}"
OLD_MINOR="${OLD_MINOR%%.*}"

PAGE_GENERAL=$(/bin/cat <<'EOF'
{
    "step_title": "PostgreSQL Upgrade",
    "items": [{
        "desc": "Your PostgreSQL databases and configuration will be preserved during the upgrade.<br><br>The service will be temporarily unavailable while the upgrade is in progress."
    }]
}
EOF
)

PAGE_1712=$(/bin/cat <<'EOF'
{
    "step_title": "PostgreSQL 17.12 Upgrade",
    "items": [{
        "desc": "PostgreSQL 17.12 includes security fixes and may require index maintenance after upgrading. Review the <a target=\"_blank\" href=\"https://www.postgresql.org/docs/release/17.12/\">PostgreSQL 17.12 release notes</a> for required post-upgrade steps."
    }]
}
EOF
)

upgrade_page="${PAGE_GENERAL}"

# Show the 17.12-specific notice only when upgrading from an older release.
if [ -n "${OLD_VERSION}" ] && \
   { [ "${OLD_MAJOR}" -lt 17 ] || \
     { [ "${OLD_MAJOR}" -eq 17 ] && [ "${OLD_MINOR}" -lt 12 ]; }; }; then
    upgrade_page="${upgrade_page},${PAGE_1712}"
fi

echo "[${upgrade_page}]" > "${SYNOPKG_TEMP_LOGFILE}"

exit 0
