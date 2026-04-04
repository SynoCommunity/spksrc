# DSM 7 Migration

Key changes from DSM 6 to DSM 7.

## Major Changes

- **Non-root execution** - Packages run as `sc-{packagename}`
- **New filesystem hierarchy** - Separate directories for data types
- **Web service resource** - JSON-based WebStation integration (DSM 7+)

## Filesystem Hierarchy

| Directory | Purpose | Variable |
|-----------|---------|----------|
| `target/` | Package binaries | `SYNOPKG_PKGDEST` |
| `var/` | Persistent data | `SYNOPKG_PKGVAR` |
| `etc/` | Configuration | - |
| `home/` | Private storage | - |

## Deprecated

- `start-stop-daemon` (busybox)
- `su` / privilege escalation
- `synouser` / `synogroup`
- `/usr/local/{package}` symlink

## New Makefile Variables

```makefile
SYSTEM_GROUP = http
SPK_USR_LOCAL_LINKS = etc:var/foo lib:libs/bar
SERVICE_WIZARD_SHARENAME = wizard_data_share
```

## Resource File Example

```json
{
  "data-share": {
    "shares": [{
      "name": "sc-mypackage",
      "permission": {"rw": ["sc-mypackage"]}
    }]
  }
}
```
