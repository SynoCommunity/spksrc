# Service Scripts

This page covers how to configure services and daemons in spksrc packages.

## Overview

Packages that run background services need:

1. **service-setup.sh** - Defines service variables and lifecycle hooks
2. **Resource file** - Defines shared folder requirements, ports, etc.

## Service Setup Script

Create `spk/<package>/src/service-setup.sh`:

```bash
# Service command to run
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/mydaemon"

# Include arguments directly in SERVICE_COMMAND
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/mydaemon --config ${SYNOPKG_PKGVAR}/config.ini"

# Run in background (service doesn't daemonize itself)
SVC_BACKGROUND=y

# Write PID file
SVC_WRITE_PID=y
```

### Common Variables

| Variable | Description |
|----------|-------------|
| `SERVICE_COMMAND` | Path to the service executable (include arguments directly) |
| `SVC_BACKGROUND` | Set to `y` if service should be backgrounded |
| `SVC_WRITE_PID` | Set to `y` to write PID file |
| `SVC_CWD` | Working directory for the service |
| `SVC_WAIT_TIMEOUT` | Seconds to wait for PID file (default: 20) |

### Framework Variables

These variables are set by the framework and available in your scripts:

| Variable | Description |
|----------|-------------|
| `EFF_USER` | Effective service user (e.g., `sc-mypackage` on DSM 7) |
| `PID_FILE` | Path to PID file |
| `LOG_FILE` | Path to log file |
| `SHARE_PATH` | Path to configured shared folder |

### Environment Variables

These variables are provided by DSM and available in service scripts. See [Synology Script Environment Variables](https://help.synology.com/developer-guide/synology_package/script_env_var.html) for the complete list.

| Variable | Description |
|----------|-------------|
| `SYNOPKG_PKGNAME` | Package name |
| `SYNOPKG_PKGDEST` | Package installation directory |
| `SYNOPKG_PKGVAR` | Package variable data directory |
| `SYNOPKG_DSM_VERSION_MAJOR` | DSM major version |

## Service Hooks

Add functions to run at specific lifecycle points:

```bash
# Called after installation
service_postinst() {
    # Create initial configuration
    if [ ! -f "${SYNOPKG_PKGVAR}/config.ini" ]; then
        cp "${SYNOPKG_PKGDEST}/share/config.sample.ini" "${SYNOPKG_PKGVAR}/config.ini"
    fi
}

# Called after upgrade
service_postupgrade() {
    # Migrate configuration if needed
    :;
}

# Called before service starts
service_prestart() {
    # Validate configuration
    if [ ! -f "${SYNOPKG_PKGVAR}/config.ini" ]; then
        echo "Configuration file missing" >&2
        return 1
    fi
}

# Called after service starts
service_poststart() {
    # Additional setup after service is running
    :;
}

# Called before service stops
service_prestop() {
    # Cleanup before stopping
    :;
}

# Called before uninstall
service_preuninst() {
    # Backup data if needed
    :;
}

# Called after uninstall
service_postuninst() {
    # Final cleanup
    :;
}
```

### Lifecycle Order

**Installation:**
1. Package extracted
2. `service_postinst()` called
3. Service started (if `STARTABLE=yes`)

**Upgrade:**
1. Service stopped
2. `service_preuninst()` called
3. Old package removed
4. New package extracted
5. `service_postinst()` called
6. `service_postupgrade()` called
7. Service started

**Uninstall:**
1. Service stopped
2. `service_preuninst()` called
3. Package removed
4. `service_postuninst()` called

## Resource Files (DSM 7+)

See [Resource Files](resource-files.md) for detailed documentation on configuring shared folders, ports, and other DSM integrations.

## Makefile Configuration

See [Makefile Variables](makefile-variables.md) for `SERVICE_*` variables including `SERVICE_USER`, `SERVICE_SETUP`, `SERVICE_PORT`, and `SERVICE_WIZARD_SHARENAME`.

## Best Practices

1. **Use dedicated user** - Set `SERVICE_USER = auto`
2. **Handle configuration** - Check for and create default configs
3. **Log appropriately** - Default log file is at `${SYNOPKG_PKGVAR}/${SYNOPKG_PKGNAME}.log`
4. **Validate in prestart** - Check requirements before starting service
