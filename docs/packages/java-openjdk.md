---
title: Java OpenJDK
description: OpenJDK 17, 21 and 25 for Synology NAS, side by side
tags:
  - packages
  - runtime
---

# Java OpenJDK

!!! note "Package Information"
    - **Maintainer**: SynoCommunity
    - **Upstream**: [OpenJDK](https://openjdk.org/)
    - **License**: GPLv2 with the Classpath Exception

Three OpenJDK releases are packaged, each a full JDK (compiler, tools and runtime): Java 17, 21 and 25, all
long-term support releases. They install side by side, so several can be present on the same NAS.

| Package | Version | DSM | VM on 64-bit | VM on 32-bit |
|---------|---------|-----|--------------|--------------|
| Java 17 OpenJDK (`java-17-openjdk`) | 17.0 LTS | 7.0 and later | Server (JIT) | Server (JIT) |
| Java 21 OpenJDK (`java-21-openjdk`) | 21.0 LTS | 7.0 and later | Server (JIT) | Server (JIT) |
| Java 25 OpenJDK (`java-25-openjdk`) | 25.0 LTS | 7.1 and later | Server (JIT) | Zero (interpreter only) |

## Installation

### Via Package Center

1. Add SynoCommunity repository to Package Center
   - See [Installation Guide](../user-guide/installation.md)
2. Search for "Java"
3. Click **Install** on the version you need

The package has no service: DSM shows it as stopped, which is expected. Its commands are linked into
`/usr/local/bin` when the package is started, which Package Center does after installing it.

## Usage

### Commands

Each package links all its JDK commands into `/usr/local/bin` (`java`, `javac`, `jar`, `jshell`, `keytool`,
...), and also three commands named for its version:

| Package | Versioned commands |
|---------|--------------------|
| Java 17 | `java17`, `javac17`, `jar17` |
| Java 21 | `java21`, `javac21`, `jar21` |
| Java 25 | `java25`, `javac25`, `jar25` |

When several versions are installed, the unversioned commands (`java`, `javac`, ...) belong to the package
DSM **started last**. Use the versioned commands, or a `JAVA_HOME` (below), to get a given version whatever
the start order:

```bash
java -version      # the JDK started last
java21 -version    # always Java 21
```

### JAVA_HOME

Each package provides a `JAVA_HOME` that does not change across updates:

| Package | JAVA_HOME |
|---------|-----------|
| Java 17 | `/var/packages/java-17-openjdk/target/jvm/openjdk-17` |
| Java 21 | `/var/packages/java-21-openjdk/target/jvm/openjdk-21` |
| Java 25 | `/var/packages/java-25-openjdk/target/jvm/openjdk-25` |

It links to the directory of the installed release (for example `jvm/openjdk-21.0.13.0.3`), whose name
changes with each update: use the stable path above in scripts, services and tools such as Maven or
Gradle.

```bash
export JAVA_HOME=/var/packages/java-21-openjdk/target/jvm/openjdk-21
export PATH="$JAVA_HOME/bin:$PATH"
```

### Fonts

DSM ships no font. The packages include the DejaVu fonts, which the bundled fontconfig finds on its own, so
Java can render text (AWT, PDF and report generation, image captions).

A user without a writable home directory may see this harmless message on the first font lookup:

```
Fontconfig error: No writable cache directories
```

The fonts are still found and the text still renders; fontconfig only rescans them each time.

## Java 25 on 32-bit NAS

The 32-bit x86 port was removed from Java 25 and the 32-bit ARM port no longer runs, so Java 25 uses Zero on
32-bit models (ARMv7 and i686), as Debian does. Zero has no JIT compiler: programs run, but much more slowly
than on a 64-bit NAS, by one to two orders of magnitude.

- Give the JVM a heap that fits the NAS: `java25 -Xmx64m ...` on a model with 256 MB of RAM.
- Network operations take longer: a first HTTPS request can take about a minute, so allow generous timeouts.
- `jhsdb` (the serviceability agent) is not available with Zero.

## Troubleshooting

### `java` runs the wrong version

The unversioned commands follow the package started last. Use `java17`, `java21` or `java25`, or set
`JAVA_HOME` as shown above.

### `java: command not found` after installing from the command line

`synopkg install` leaves the package stopped, and the commands are linked when it starts:

```bash
sudo synopkg start java-21-openjdk
```

## Related Packages

- [Mono](mono.md) - .NET Framework runtime
