# Radarr, Sonarr, Lidarr & Jackett

These .NET-based packages provide media management capabilities.

## Architecture Support

The newer .NET packages provide many benefits, but unfortunately not all architectures are supported. If you are unsure what architecture your NAS is running, check the [Architecture per Synology model](../reference/architectures.md) page.

## Known Issues

### Unable to Update Radarr

It's a known issue when running multiple *arr applications. Stopping Sonarr then updating Radarr resolves the issue.

Related: [#4679](https://github.com/SynoCommunity/spksrc/issues/4679), [#4621](https://github.com/SynoCommunity/spksrc/issues/4621)

### rtd1296 (armv8) Devices and Mono

Sonarr v4/Radarr/Lidarr/Jackett .NET core versions should work correctly.

Sonarr v3 is end of life and not supported by the Sonarr Team.

### Radarr on DS715 (alpine) - "Killed" or "terminated with status 1"

This CPU architecture is not supported at the moment. See [#4546](https://github.com/SynoCommunity/spksrc/issues/4546) and [#4793](https://github.com/SynoCommunity/spksrc/pull/4793).

### Downgrade Mono Without Uninstalling (Advanced)

Instead of uninstalling the higher version, you can fake a lower version number by modifying the INFO file:

1. SSH into the diskstation
2. `sudo vi /var/packages/mono/INFO`
3. Modify version from "5.20.1.34" to "5.8.0.108" and save
4. Then it will display as 5.8.0.108 in DSM package center and you can manually downgrade

## Alternative Options

### Docker (aarch64)

If your NAS supports Docker, you can use Docker images instead:

- [Docker ARM Synology Guide](https://wiki.servarr.com/Docker_ARM_Synology)
- [Docker Guide](https://wiki.servarr.com/docker-guide)
- [TRaSH Guide for Synology](https://trash-guides.info/Hardlinks/How-to-setup-for/Synology/)

### Servarr Team Packages

The Servarr Team also creates and maintains Synology Packages:
[Servarr Synology Packages](https://wiki.servarr.com/en/synology-packages)
