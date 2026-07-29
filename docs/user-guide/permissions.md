# Permission Management

This guide covers how SynoCommunity packages handle permissions and how to configure access to shared folders.

## Overview

SynoCommunity packages run as non-privileged user accounts, not as `root`. This improves security by limiting what each package can access.

## DSM 7 Permissions

With DSM 7, packages use **System internal user** accounts (e.g., `sc-jellyfin`, `sc-transmission`). These accounts are not manageable via DSM Control Panel and are not members of the `users` group.

### Granting Permissions

#### Option 1: Full Shared Folder Access

1. Open **Control Panel** > **Shared Folder**
2. Edit the shared folder
3. Select the **Permissions** tab
4. Select **System internal user** from the dropdown
5. Find the package user (e.g., `sc-jellyfin`)
6. Grant **Read only** or **Read/Write** as needed
7. Click **OK**

![Shared Folder permissions in Control Panel](../assets/images/shared-folder-permissions.png)

#### Option 2: Per-Folder Access

For more granular control:

1. Open **File Station**
2. Right-click the target folder > **Properties**
3. Select the **Permissions** tab
4. Click **Create**
5. Select **System internal user** > find the package user
6. Grant appropriate permissions (Read, Write, etc.)
7. For parent folders, add **Traverse folders** and **List folders** permissions

![Permission editing in File Station](../assets/images/file-station-permissions.png)

For parent folders requiring traverse permissions:

![Folder parent permissions in File Station](../assets/images/file-station-parent-permissions.png)

!!! tip
    If you have a deep folder hierarchy, set "Apply to this folder, sub-folders and files" to apply permissions recursively.

## DSM 6 Permissions

### Download and Media Groups

DSM 6 introduced two special groups for SynoCommunity packages:

| Group | Purpose | Use Case |
|-------|---------|----------|
| `sc-download` | Download folder access | Transmission, SABnzbd, etc. |
| `sc-media` | Media folder access | Plex, Jellyfin, etc. |

### Access Model

- **Technical packages** (like protocol handlers) have no group membership
- **Producer packages** (like downloaders) write to folders with `sc-download` permissions
- **Consumer packages** (like media servers) read folders via `sc-download` or `sc-media` group membership

### Granting Group Access

1. Open **Control Panel** > **Shared Folder**
2. Edit the shared folder
3. Select the **Permissions** tab
4. Find `sc-download` or `sc-media` group
5. Grant **Read/Write** or **Read only** as appropriate
6. Click **OK**

## Migrating from DSM 6 to DSM 7

After upgrading to DSM 7:

1. Reconfigure permissions using **System internal user** (see above)
2. Once all packages work correctly, you can remove the old `sc-download` and `sc-media` groups

## ACL Requirements

SynoCommunity packages require ACL (Access Control List) support to access DSM Shared Folders.

!!! warning
    Do not attempt to workaround permissions by pointing application folders to Linux root file systems instead of Shared Folder locations.

### Enabling ACL Support

For shared folders created before DSM 5, you may need to convert to ACL:

1. Open **Control Panel** > **Shared Folder**
2. Select the folder
3. Click **Action** > **Convert to Windows ACL**
4. Follow the conversion wizard

## Troubleshooting

### Permission Denied Errors

1. Verify the package user has permissions on the folder
2. Check parent folder permissions (need traverse/list rights)
3. Ensure ACL is enabled on the shared folder

### Finding Package User

The package user is typically `sc-<packagename>`. Via SSH:

```bash
cat /var/packages/<packagename>/conf/privilege 2>/dev/null | grep username
```

### More Information

For detailed ACL documentation, see [Synology Knowledge Base: How to manage ACL settings](https://www.synology.com/en-global/knowledgebase/DSM/tutorial/File_Sharing/How_to_manage_ACL_settings_on_your_Synology_NAS)
