# Mono

[Mono](https://www.mono-project.com/) is an open source implementation of Microsoft's .NET Framework as part of the [.NET Foundation](https://www.dotnetfoundation.org/) and based on the [ECMA](https://www.mono-project.com/docs/about-mono/languages/ecma/) standards for C# and the Common Language Runtime.

Since .NET 6 (aka dotnet core), there is a new framework available for building cross platform applications. However, Mono is still useful on Linux for 32-bit CPUs (arm and x86) that are not supported by dotnet core.

Since Mono 6.0.12-20, we support a current version that includes support for .NET 4.8.

## Certificate Store

Mono has its own certificate store for CA certificates used to validate certificates for secure connections.

The SynoCommunity package has located the certificate store in:
```
/var/packages/mono/var/.mono/certs
```

### Certificate Update

At package installation, the certificate store is updated with the currently installed ca-certificates of DSM. The command for this update is:

```bash
/var/packages/mono/target/bin/cert-sync /etc/ssl/certs/ca-certificates.crt
```

The package installer installs a script for later updates:
```
/var/packages/mono/var/update_ca_certificates.sh
```

### Keeping Certificates Up-to-Date

There are several options:

- Manually SSH into your Diskstation and run the script
- Create a **Triggered Task** in the DSM Task Scheduler to execute this script at system boot
- Create a **Scheduled Task** in the DSM Task Scheduler to execute this script manually or with a schedule
- Manually download and install the mono package of the already installed version. This will "update" the package with the same version, and the ca certificate update is run again.

## History

There were some long lasting issues that are now fixed:

- Before Version `5.20.1.34-19` there was an issue on DSM 7 (fixed in [Mono: fix DSM 7 compatibility (#5604)](https://github.com/SynoCommunity/spksrc/pull/5604))
- Packages for aarch64 on DSM 6.1 had an error in the TLS library for all mono packages with versions > 5.8 (see [Mono 5.18 SSL store problems on aarch64 platforms](https://github.com/SynoCommunity/spksrc/issues/3666))
