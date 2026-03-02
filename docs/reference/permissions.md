# Permissions Reference

This page provides technical reference for the permission system used by spksrc packages on DSM. For user-facing instructions, see [User Guide: Permission Management](../user-guide/permissions.md).

## Service Accounts

### DSM 7 Service Accounts

In DSM 7, each package runs under a dedicated **system internal user** account:

```
sc-<pkgname>
```

For example:
- `sc-transmission` for Transmission
- `sc-jellyfin` for Jellyfin
- `sc-homeassistant` for Home Assistant

These accounts:
- Are created automatically during installation
- Cannot be managed via DSM Control Panel
- Are not members of the `users` group
- Are deleted when the package is uninstalled

### DSM 6 Service Accounts

DSM 6 allows configurable service users. spksrc packages use:

| Package Type | User | Group(s) |
|--------------|------|----------|
| Download clients | Package-specific | `sc-download` |
| Media servers | Package-specific | `sc-media` |
| Web apps | `http` | `http` |
| CLI tools | `root` | `root` |

### Privilege Configuration

Service user configuration is defined in `src/conf/privilege` (JSON):

```json
{
    "defaults": {
        "run-as": "package"
    }
}
```

| Value | Description |
|-------|-------------|
| `package` | Use `sc-<pkgname>` user |
| `root` | Run as root (not recommended) |

For DSM 7, the Makefile variable `SERVICE_USER` specifies the service account name (typically `sc-$SYNOPKG_PKGNAME`).

## Framework Variables

### Makefile Variables

| Variable | Description | Example |
|----------|-------------|--------|
| `SERVICE_USER` | Service account name | `sc-transmission` |
| `STARTABLE` | Whether package has a service | `yes` |
| `SERVICE_WIZARD_SHARENAME` | Wizard variable for share name | `wizard_data_share` |

### Script Variables

Variables available in `service-setup.sh`:

| Variable | Description |
|----------|-------------|
| `EFF_USER` | Effective user running the service |
| `SHARE_PATH` | Full path to configured share (via wizard) |
| `SHARE_NAME` | Name of configured share |
| `SYNOPKG_PKGDEST` | Package installation directory |
| `SYNOPKG_PKGVAR` | Package variable directory |

## ACL System

### ACL Modes

DSM uses POSIX ACLs extended by Synology:

| Mode | POSIX | Description |
|------|-------|-------------|
| Read | `r--` | Read file contents |
| Write | `-w-` | Modify file contents |
| Execute | `--x` | Execute file/traverse directory |
| Append | Custom | Append to file |
| Delete | Custom | Delete file |
| Custom | Varies | Combined permission sets |

### synoacltool

The `synoacltool` command manages ACLs:

```bash
# Get ACL for a path
synoacltool -get /volume1/data

# Add ACL entry
synoacltool -add /volume1/data user:sc-transmission:allow:rwxpd---:fd--

# Delete ACL entry
synoacltool -del /volume1/data user:sc-transmission
```

### ACL Entry Format

```
<type>:<name>:<allow|deny>:<perms>:<flags>
```

| Field | Values |
|-------|--------|
| type | `user`, `group` |
| name | Username or group name |
| allow/deny | `allow`, `deny` |
| perms | `rwxpdDaARWcCos` |
| flags | `fdin` (file, directory, inherit, no-propagate) |

### Permission Characters

| Char | Permission |
|------|------------|
| `r` | Read data |
| `w` | Write data |
| `x` | Execute/Traverse |
| `p` | Append data |
| `d` | Delete |
| `D` | Delete child |
| `a` | Read attributes |
| `A` | Write attributes |
| `R` | Read xattr |
| `W` | Write xattr |
| `c` | Read ACL |
| `C` | Write ACL |
| `o` | Chown |
| `s` | Sync |

## Framework Functions

### fix_shared_folders_rights

The `fix_shared_folders_rights` function (from `spksrc.service.installer.functions`) sets appropriate permissions:

```bash
fix_shared_folders_rights "${SHARE_PATH}" "${SYNOPKG_PKGNAME}"
```

This function:
1. Detects DSM version
2. Sets appropriate owner/group
3. Applies ACL entries for the service account

### Permission Helper Functions

| Function | Description |
|----------|-------------|
| `set_unix_permissions` | Set traditional Unix perms |
| `fix_shared_folders_rights` | Full ACL setup for shared folders |
| `setup_new_share` | Create and configure new share |

## Resource File Permissions

### data-share Configuration

In resource files (`src/conf/resource`):

```json
{
    "data-share": {
        "shares": [
            {
                "name": "{{wizard_data_share}}",
                "permission": {
                    "rw": ["sc-{{SYNOPKG_PKGNAME}}"]
                }
            }
        ]
    }
}
```

### Permission Types

| Key | Permission Level |
|-----|------------------|
| `rw` | Read/Write |
| `ro` | Read Only |
| `na` | No Access |

## Best Practices

### Principle of Least Privilege

1. Request only necessary permissions
2. Use read-only access when write is not required
3. Limit access to specific folders, not entire volumes

### Shared Folder Access

```bash
# Good: Use wizard-defined share
SHARE_PATH="/volume1/${wizard_data_share}"

# Bad: Hardcode paths
SHARE_PATH="/volume1/downloads"
```

### DSM 7 Considerations

1. Service accounts are automatically created
2. Cannot add service accounts to custom groups
3. Use resource files for share permissions
4. Test with fresh installs, not just upgrades

## Troubleshooting

### Checking Effective Permissions

```bash
# As root, check ACL
synoacltool -get /volume1/data

# Check file ownership
ls -la /volume1/data

# Check effective user for running service
ps aux | grep <servicename>
```

### Common Permission Errors

| Error | Cause | Solution |
|-------|-------|----------|
| "Permission denied" | Missing ACL | Add via synoacltool or resource file |
| "Operation not permitted" | Wrong user | Check SERVICE_USER |
| Cannot create directory | No write permission | Grant rw in resource file |

## See Also

- [User Guide: Permission Management](../user-guide/permissions.md) - User instructions
- [Resource Files](../developer-guide/packaging/resource-files.md) - Resource file configuration
- [DSM APIs](dsm-apis.md) - Synology documentation links
