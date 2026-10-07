---
title: Caddy
description: Fast, multi-platform web server with automatic HTTPS
tags:
  - packages
  - network
---

# Caddy

!!! note "Package Information"
    - **Maintainer**: @cjheath
    - **Upstream**: [Caddy](https://caddyserver.com/)
    - **License**: Apache-2.0

Caddy is a web server and reverse proxy whose headline feature is **automatic
HTTPS**: name a real domain in its configuration and it obtains and renews a
Let's Encrypt certificate on its own, with no cron job and nothing to remember.

On a NAS its common uses are putting one hostname in front of several services
already running there, and serving static files.

## Installation

### Via Package Center

The package has **no web interface of its own**, so it does not appear in the
DSM main menu. Its default site answers on port **8880** as a health check:

```
$ curl http://your-nas-ip:8880/
Caddy is running
```

If you see that, the package works and the rest is configuration.

## Configuration

Everything lives in one file:

```
/var/packages/caddy/var/Caddyfile
```

It is copied there on first install from a heavily commented template and is
**never overwritten afterwards**, including by package upgrades — edit it
freely. Read it: it documents the DSM-specific steps below at the point where
you need them. The pristine template stays beside it as `Caddyfile.default`.

The [Caddyfile documentation](https://caddyserver.com/docs/caddyfile) covers the
syntax itself.

### Applying changes

Either restart the package from Package Center, or reload without dropping
connections:

```bash
caddy reload --config /var/packages/caddy/var/Caddyfile
```

Check a file before applying it:

```bash
caddy validate --config /var/packages/caddy/var/Caddyfile
```

### Serving a real domain over HTTPS

Replace the `:8880` site block with your domain:

```caddyfile
example.your-domain.com {
	respond "Caddy is running"
}
```

For the certificate to be issued, three things must be true:

1. A DNS **A** record (and **AAAA**, if you have IPv6) for that name points at
   your public IP.
2. Ports **80 and 443** are forwarded from your router to the NAS. Port 80 is
   needed as well as 443 — Caddy uses it for the ACME challenge and to redirect
   plain HTTP.
3. Nothing else on the NAS still holds 80/443, and Caddy is allowed to bind
   them -- or the router forwards 80/443 to ports Caddy can already use. Both
   are covered below.

Certificates are stored under `/var/packages/caddy/var/data`, so they survive
restarts and package upgrades.

### Binding ports 80 and 443

Two ways: let Caddy bind 80 and 443 itself (DSM 7), or leave it on high ports and
let the router translate (any DSM, and the only way on DSM 6).

#### Caddy on 80 and 443 (DSM 7)

Two separate obstacles, in this order.

**DSM usually holds those ports itself**, even with Web Station stopped: the
Login Portal redirects `http://<nas>/` to the DSM interface. Free them in
**Control Panel → Login Portal → Advanced → Applications**, by editing the DSM
entry, and uncheck any HTTP-to-HTTPS redirect in **Control Panel → Network →
DSM Settings**. On DSM 6 the first menu is called *Application Portal*.

**Then grant the binary the capability**, as root:

```bash
setcap 'cap_net_bind_service=+ep' /var/packages/caddy/target/bin/caddy
```

!!! warning "This must be repeated after every package upgrade"
    An upgrade replaces the binary, and the capability is a property of the
    file, so it is lost. Caddy cannot grant it to itself and the package cannot
    grant it for you. DSM Task Scheduler can run the command on a trigger — see
    [AdGuard Home](adguardhome.md#using-task-scheduler) for that recipe, which
    applies here unchanged.

#### Caddy on high ports, the router on 80 and 443 (any DSM)

DSM 6 ships no `setcap`, so the step above is not available there. Keep Caddy on
ports it may bind as its own user, and have the router forward its public **80
to the NAS's 8880** and **443 to 8443**. Tell Caddy, in the global options block
at the top of the Caddyfile, which ports those are:

```caddyfile
{
	http_port  8880
	https_port 8443
}

example.your-domain.com {
	reverse_proxy 127.0.0.1:5000
}
```

Certificates are issued the same way: Let's Encrypt still reaches ports 80 and
443 from outside. DSM keeps its own 80/443, and the upgrade warning above does
not apply. If the DSM firewall is enabled, allow 8443 as well: the package only
declares 8880.

## Usage

The binary is on the path of a login shell as `caddy`:

```bash
caddy version       # v2.11.7
caddy build-info    # Go version and every module compiled in
```

### Reverse proxy to another service

The most common reason to run Caddy on a NAS — one public name in front of
something already listening locally:

```caddyfile
example.your-domain.com {
	reverse_proxy 127.0.0.1:5000
}
```

## Troubleshooting

Caddy writes structured JSON to one file:

```bash
tail /var/packages/caddy/var/caddy.log
```

**The package will not start.** Read that log; a configuration error names the
line it choked on. `caddy validate` reproduces it without touching the running
server.

**`permission denied` binding :80 or :443.** The `setcap` step above is missing,
or was lost to an upgrade. On DSM 6, use the high-port setup instead.

**The certificate is not issued.** Caddy logs the ACME exchange. The usual
causes are port 80 not reaching the NAS, or DNS not yet pointing at your public
IP; both are visible in the log.

**An admin API** listens on `127.0.0.1:2019` for local use — handy for
inspecting the running configuration:

```bash
curl -s http://127.0.0.1:2019/config/apps/http/servers/srv0/listen
```

### Getting help

- [SynoCommunity issues](https://github.com/SynoCommunity/spksrc/issues)
- [Caddy documentation](https://caddyserver.com/docs/)
- [Caddy community forum](https://caddy.community/)

## See Also

- [Package index](index.md)
