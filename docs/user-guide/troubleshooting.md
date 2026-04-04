# Troubleshooting

This guide covers common issues and frequently asked questions for SynoCommunity packages.

## Repository Issues

### Cannot Add Repository

**Symptoms:** "Invalid location" error when adding repository, or repository cannot be contacted.

**Solutions:**

1. Verify the URL is exactly: `https://packages.synocommunity.com`
2. Check your NAS has internet access
3. Note: Accessing `https://packages.synocommunity.com` directly in a browser will show a "Bad Request" error - this is normal as the URL is only for Package Center. Visit [synocommunity.com](https://synocommunity.com) instead to verify the service is online.
4. Check if your firewall blocks outbound HTTPS connections
5. Are you connected via a VPN? Try a direct/local connection instead
6. Check DNS resolution: SSH into your NAS and run `nslookup packages.synocommunity.com`

**DSM Certificate Issue:**

If running DSM older than 6.2.4-25556 Update 2:

- Update DSM to get the latest certificate trust store, or
- Manually update certificates:
  ```bash
  sudo mv /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt.bak
  sudo curl -Lko /etc/ssl/certs/ca-certificates.crt https://curl.se/ca/cacert.pem
  ```

**DNS Workaround:**

Configure manual DNS servers in **Control Panel** > **Network** > **General**:

- Google: `8.8.8.8` / `8.8.4.4`
- OpenDNS: `208.67.222.222` / `208.67.220.220`

### 400 Bad Request Error

If you see `400 Bad Request, The browser (or proxy) sent a request...`:

- `packages.synocommunity.com` is for your NAS Package Center only, not for browser access
- Visit [synocommunity.com](https://synocommunity.com) for the website

### No Packages Visible

**Symptoms:** Repository added but "Community" section is empty, or only some packages appear.

**Solutions:**

1. Check your NAS architecture matches available packages (see [Compatibility](compatibility.md))
2. Ensure your DSM version is supported
3. Wait a few minutes and refresh - package lists may be loading
4. For beta packages (DSM 6.x only): Enable **Settings** > **General** > "Yes, I want to see beta versions"
5. In Package Center, click **Community** in the left sidebar to view community packages

### How to Check Package Availability

1. Find your NAS architecture: [Architecture per Model](../reference/architectures.md)
2. Check if your architecture is listed at [synocommunity.com/packages](https://synocommunity.com/packages)

If your architecture is not listed, it may be intentional - some packages cannot compile for certain architectures (especially PPC-based).

## Installation Issues

### "Invalid File Format" Error

**Cause:** Downloaded an SPK for the wrong architecture.

**Solution:** Find your NAS model in **Control Panel** > **Info Center** > **General**, then look up its architecture in the [Architecture Reference](../reference/architectures.md) or [Synology's CPU guide](https://kb.synology.com/en-us/DSM/tutorial/What_kind_of_CPU_does_my_NAS_have). Download the package version matching your architecture.

### Port Conflict Error

If you see `Port configured for this package is either used by another service or reserved`:

![Port conflict error dialog](../assets/images/port-conflict-error.png)

**Check for port conflicts via SSH:**

```bash
sudo servicetool --conf-port-conflict-check --tcp 8281
```

A negative result shows:
```
IsConflict: false    Port: 8281    Protocol: tcp    ServiceName: (null)
```

A positive result shows the conflicting application:
```
IsConflict: true    Port: 8281    Protocol: tcp    ServiceName: haproxy
```

**Resolution:** Port conflicts typically occur with Docker containers, as package port configuration is usually fixed and not user-configurable. Modify the conflicting Docker container's port mapping instead.

**Advanced: Remove orphaned firewall rules**

Only use this if a package has been removed but its firewall rules remain (verify the package in `/usr/local/etc/services.d/` is not installed):

```bash
sudo servicetool --remove-configure-file --package [Package_Name].sc
```

## Runtime Issues

### Package Won't Start

**Diagnostic Steps:**

1. Check package logs:
   ```bash
   cat /var/packages/<package-name>/var/*.log
   ```

2. Check system log:
   ```bash
   sudo cat /var/log/synopkg.log | grep <package-name>
   ```

3. Try restarting the package:
    - Via Package Center: Stop, then Start
    - Via SSH: `synopkg restart <package-name>`

4. Check for port conflicts (see [Ports](../reference/ports.md))

### "Failed to Start" After DSM Update

**Cause:** DSM updates can change system components that packages depend on.

**Solutions:**

1. Repair the package: **Package Center** > click package > **Repair**
2. Stop, then start the package
3. Check if a package update is available
4. Uninstall and reinstall the package
    - On DSM 7.x, data is preserved by default
    - On DSM 6.x, manually back up data before uninstalling as most packages remove all data by default

### Web Interface Not Accessible

**For packages with web interfaces:**

1. Verify the package is running
2. Check the port in package settings
3. Try accessing via IP address instead of hostname
4. Check if your browser is blocking the connection (try incognito mode)
5. Verify your firewall allows the port

## DSM-Specific Issues

### DSM 7.x Issues

#### Package Stopped After Reboot

Some packages may not auto-start after DSM 7 updates due to systemd changes.

**Solution:** Manually start the package after reboot, or check for package updates that address this.

#### Permission Issues with Shared Folders

DSM 7 has stricter permission controls.

**Solution:** Ensure the package user (usually `sc-<packagename>`) has appropriate permissions. See [Permission Management](permissions.md) for details.

### DSM 6.x Issues

#### No Packages Available for Old DSM Versions

**Cause:** Some packages require DSM 6.2+.

**Solution:** Update DSM to the latest version for your NAS model, or check if older package versions are available.

## Advanced Troubleshooting

### Downgrading a Package (Without Uninstall)

Instead of uninstalling, modify the version number to allow installing an older version:

1. SSH into the NAS
2. Edit the INFO file:
   ```bash
   sudo vi /var/packages/[Package_Name]/INFO
   ```
3. Change the version (e.g., `"5.20.1.34"` to `"1.0"`)
4. Save and exit
5. Package Center will now show version "1.0" and allow "upgrading" to an older release

!!! warning
    This may not work if the package update irreversibly migrates data.

### Downloading Pre-release Packages from GitHub

Development and pre-release packages are available from GitHub Actions artifacts.

**Requirements:**

- GitHub account (required to download artifacts)
- Note: Artifacts expire 90 days after workflow completion

**Steps:**

1. Go to the Pull Request and click **Checks** tab

![GitHub Actions Checks tab](../assets/images/github-actions-checks.png)

2. Select **Build** workflow
3. Download the artifact for your architecture (e.g., `x64-7.1`)

![GitHub Actions Artifacts](../assets/images/github-actions-artifacts.png)

4. Extract the `.spk` file from the ZIP
5. Install via **Package Center** > **Manual Installation**

**Finding Your Architecture:**

- See [Architecture Reference](../reference/architectures.md)
- Use generic arch where available: `x64` (for x86_64), `armv7`, `aarch64`
- DSM 6: packages for version >= 6.2.4
- DSM 7: packages for version >= 7.1 (or >= 7.2 when 7.1 not supported)


!!! tip "Verify Build Success"
    Before downloading, expand the build job (e.g., "Build (x64-7.1)") and check "Build Status" to confirm your package was successfully built.
    
    ![GitHub Actions Build Status](../assets/images/github-actions-build-status.png)

## Getting Help

If the above solutions don't help:

1. **Search existing issues**: [GitHub Issues](https://github.com/SynoCommunity/spksrc/issues)
2. **Check package-specific documentation**: [Package Documentation](../packages/index.md)
3. **Ask on Discord**: [SynoCommunity Discord](https://discord.gg/nnN9fgE7EF)
4. **Open a new issue** with:
    - NAS model and DSM version
    - Package name and version
    - Steps to reproduce the issue
    - Relevant log excerpts
