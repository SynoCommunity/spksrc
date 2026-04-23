---
title: SSH Access
description: How to enable and use SSH access on your Synology NAS
tags:
  - user-guide
  - ssh
  - terminal
---

# SSH Access

Many SynoCommunity packages require SSH access for configuration, troubleshooting, or advanced usage. This guide explains how to enable and use SSH on your Synology NAS.

## Enabling SSH

1. Open **Control Panel** > **Terminal & SNMP**
2. Check **Enable SSH service**
3. Optionally change the port (default: 22)
4. Click **Apply**

## Connecting via SSH

### From macOS/Linux

Open Terminal and run:

```bash
ssh your-username@your-nas-ip
```

Replace `your-username` with your DSM admin username and `your-nas-ip` with your NAS IP address or hostname.

### From Windows

Use an SSH client like:

- **Windows Terminal** (built-in on Windows 10/11): `ssh your-username@your-nas-ip`
- **PuTTY**: Enter hostname and port, click "Open"
- **MobaXterm**: Create new SSH session

### Example

```bash
ssh admin@192.168.1.100
```

You'll be prompted for your DSM password.

## Running Commands as Root

Most administrative commands require root privileges. Use `sudo`:

```bash
sudo cat /var/log/synopkg.log
```

Enter your password when prompted.

For an interactive root shell:

```bash
sudo -i
```

!!! warning
    Be careful when running commands as root. Incorrect commands can damage your system.

## Common Tasks

### View Package Logs

```bash
# Package-specific logs
cat /var/packages/<package-name>/var/*.log

# System package log
sudo cat /var/log/synopkg.log | grep <package-name>
```

### Restart a Package

```bash
synopkg restart <package-name>
```

### Check Package Status

```bash
synopkg status <package-name>
```

## Alternatives to SSH

If you prefer a graphical interface for file management and log viewing:

### File Browser

[File Browser](../packages/file-browser.md) is available from SynoCommunity and provides a web-based file manager. It's useful for:

- Browsing and downloading log files
- Editing configuration files
- Managing files without command-line access

### DSM File Station

For basic file access, DSM's built-in File Station can browse most directories, though some system paths may be restricted.

## Security Recommendations

1. **Use strong passwords** or SSH keys
2. **Change the default port** from 22 to reduce automated attacks
3. **Disable SSH when not in use** if you rarely need it
4. **Enable auto-block** in Control Panel > Security to block repeated failed login attempts
5. **Use a firewall** to restrict SSH access to trusted networks

## Troubleshooting

### Connection Refused

- Verify SSH is enabled in Control Panel
- Check you're using the correct port
- Ensure your firewall allows SSH connections

### Permission Denied

- Verify your username and password
- Ensure your account has admin privileges
- Check if auto-block has blocked your IP

### Command Not Found

Some commands require full paths. SynoCommunity packages install to `/var/packages/<package>/target/bin/`.

## See Also

- [Troubleshooting](troubleshooting.md) - Common issues and solutions
- [Synology KB: SSH Access](https://kb.synology.com/en-us/DSM/tutorial/How_to_login_to_DSM_with_root_permission_via_SSH_Telnet)
