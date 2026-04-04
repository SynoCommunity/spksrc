# Ash Shell PID Tracking Issue

This document explains a known limitation when using `SVC_BACKGROUND=y` with `SVC_WRITE_PID=y` on DSM 5 and SRM systems.

## Overview

On DSM < 6 and SRM, `/bin/sh` is `ash` (BusyBox), not bash. This causes issues with PID tracking for background services.

## The Problem

When the framework starts a service with `SERVICE_USER` set on DSM < 6:

```bash
su ${EFF_USER} -s /bin/sh -c "${service}" >> ${LOG} 2>&1 &
```

The `$!` variable captures the PID of `/bin/sh`, not the actual command. The shell may exit while the command continues running, leaving an incorrect PID in the file.

Bash handles this differently, but ash has this limitation.

## Affected Configurations

This issue affects packages with **all** of the following:

| Condition | Why It Matters |
|-----------|----------------|
| `SERVICE_USER` set in Makefile | Triggers `su` wrapper |
| `SERVICE_COMMAND` with parameters | Triggers `/bin/sh -c` |
| `SVC_BACKGROUND=y` | Runs command in background |
| `SVC_WRITE_PID=y` | Attempts to capture PID with `$!` |
| Target is DSM < 6 or SRM | Uses ash shell |

## Workarounds

### Option 1: Wrapper Script (Recommended)

Create a wrapper script that handles backgrounding and PID capture:

```bash
#!/bin/sh
# start.sh - wrapper for DSM 5/SRM compatibility

if [ -z "${SYNOPKG_PKGDEST}" ] || [ -z "${PID_FILE}" ]; then
    echo "ERROR: Required variables not set"
    exit 1
fi

${SYNOPKG_PKGDEST}/bin/myapp --some-arg &
echo "$!" > "${PID_FILE}"
```

!!! warning "Important"
    When using a wrapper that handles backgrounding:
    
    - Do NOT set `SVC_BACKGROUND=y` in service-setup.sh
    - Export required variables (`SYNOPKG_PKGDEST`, `PID_FILE`) before calling
    - The wrapper handles both backgrounding and PID capture

### Option 2: Application Daemon Mode

If the application supports native daemon mode with PID file:

```bash
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/myapp --daemon --pid-file ${PID_FILE}"
```

Do not set `SVC_BACKGROUND` or `SVC_WRITE_PID` - let the application handle it.

### Option 3: DSM 6+ Only

If DSM 5/SRM support is not required, this issue doesn't apply:

- DSM 6+ uses `conf/privilege` for user context (no `su` wrapper)
- The framework runs services directly: `${service} >> ${OUT} 2>&1 &`
- `$!` correctly captures the PID

## Framework Code Reference

The relevant code is in `mk/spksrc.service.start-stop-status`:

```bash
# DSM < 6 code path (problematic with ash)
if [ -n "${USER}" -a "$SYNOPKG_DSM_VERSION_MAJOR" -lt 6 ]; then
    $SU /bin/sh -c "${service}" >> ${OUT} 2>&1 &
fi

# DSM 6+ code path (works correctly)
else
    ${service} >> ${OUT} 2>&1 &
fi

# PID capture (uses $!)
if [ -n "${SVC_WRITE_PID}" -a -n "${SVC_BACKGROUND}" ]; then
    echo -ne "$!" > ${PID_FILE}
fi
```

## Current Status

- DSM 5 reached end-of-life in 2019
- Default toolchains are DSM 7.1 and 7.2
- SRM (Synology Router Manager) still uses ash
- Most packages no longer explicitly support DSM 5 or SRM

This issue primarily affects SRM deployments or legacy DSM 5 systems.

## Related Issues

See GitHub issues and PRs related to `SVC_BACKGROUND`, `SVC_WRITE_PID`, and `ash` for historical context.
