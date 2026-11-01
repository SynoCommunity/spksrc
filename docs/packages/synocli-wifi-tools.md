---
title: SynoCli WiFi Tools
description: WiFi connection tools for Synology NAS
tags:
  - cli
  - wifi
  - network
---

# SynoCli WiFi Tools

The `synocli-wifi-tools` package provides the command-line tools to connect a
NAS to a WiFi network, with the USB adapters of
[SynoKernel WiFi](synokernel-wifi.md): `iw`, `wpa_supplicant` 2.11 with WPA3,
the DHCP client `udhcpc`, and `synocli-wifi`, which connects by network
profile. They change more often than the drivers, which follow the kernels,
and come in a package of their own.

## Package Information

| Property | Value |
|----------|-------|
| Package Name | synocli-wifi-tools |
| License | Each tool under its own license |
| Dependencies | [SynoCli Kernel Tools](synocli-kernel.md) 2.1 or newer |

## Included Tools

| Command | Description |
|---------|-------------|
| `synocli-wifi` | Connects by network profile |
| `iw` | Shows and sets the WiFi interfaces, scans, sets the regulatory domain |
| `wifi-wpa_supplicant` | `wpa_supplicant` 2.11, WPA2 and WPA3 (SAE) |
| `wifi-wpa_cli` | Its control client |
| `wifi-wpa_passphrase` | The WPA2 key of a passphrase |
| `udhcpc` | The DHCP client of busybox |

DSM has a `wpa_supplicant` of its own, 2.6 without WPA3, first in the `PATH` of
root: those of the package are linked as `wifi-*`.

## Connecting to a network

DSM 7 does not show WiFi interfaces in its network settings, nor DSM 6 those of
the adapters it does not support: `synocli-wifi` connects the NAS from the
command line, by profile -- one JSON file per network in
`/var/packages/synocli-wifi-tools/var/networks`, written by the installation wizard
or by `synocli-wifi new`:

```bash
sudo -i synocli-kernelmodule --profile rtl88x2bu start
sudo -i synocli-wifi --profile MyNetwork start
```

```bash
sudo -i synocli-wifi new                            # asks for a network, writes its profile
synocli-wifi list                                   # the profiles, without sudo
sudo -i synocli-wifi --profile MyNetwork status     # the state of the connection
sudo -i synocli-wifi --profile MyNetwork restart    # reconnect, from a clean interface
sudo -i synocli-wifi --profile MyNetwork stop       # disconnect
```

Every connection starts from a clean state: the DHCP client and
`wpa_supplicant` of the interface are stopped first, and a second connection
replaces the first. `-i wlan1` picks the interface, the first one of `iw dev`
otherwise. When connections go through the interface, which resetting it cuts,
`synocli-wifi` goes on in the background; its log is
`/var/log/packages/synocli-wifi.log`.

A profile holds the network, its security, and its address:

```json
{
  "ssid": "MyNetwork",
  "security": "wpa2",
  "psk": "<the WPA2 key, of wpa_passphrase>",
  "dhcp": false,
  "address": "192.168.1.50/24",
  "gateway": "192.168.1.1",
  "dns": ["192.168.1.1"],
  "default_route": false,
  "country": "CA"
}
```

- `security`: `wpa2`, `wpa3` (WPA3, or a WPA2/WPA3 network) or `open`. The
  passphrase is kept as its WPA2 key only, not in clear, except for WPA3, which
  needs it (`sae_password`). The file is readable by its owner only.
- `dhcp`: `true`, or `false` for the static `address`.
- `default_route`: `false` keeps the default route and DNS servers of the wired
  interface. `true`, for a NAS on WiFi alone, gives them to the WiFi network;
  those it replaced come back when it disconnects.
- `country`, optional: the [regulatory domain](synokernel-wifi.md#regulatory-domain) set before
  connecting.

To connect at every startup, add the two commands to the task of
[Loading modules at boot](synocli-kernel.md#loading-modules-at-boot), which
runs as root; `synocli-wifi` waits a few seconds for the interface the driver
creates:

```bash
synocli-kernelmodule --profile rtl88x2bu start
synocli-wifi --profile MyNetwork start
```

## Connecting by hand

What `synocli-wifi` does, with the tools of the package:

```bash
# The configuration on the standard input; the control interface (-C) lets
# wpa_cli follow and stop it, and refuses a second instance
wifi-wpa_passphrase "MyNetwork" "MyPassphrase" | sudo -i wifi-wpa_supplicant -B -D nl80211 -i wlan0 -C /var/run/wpa_supplicant -c /dev/stdin
sudo -i wifi-wpa_cli -i wlan0 status

# The address only; WIFI_DEFAULT_ROUTE=1 in front for the default route and DNS too
sudo -i udhcpc -i wlan0 -s /var/packages/synocli-wifi-tools/target/etc/udhcpc.script -b -R -p /var/run/udhcpc-wlan0.pid

# Disconnect: udhcpc releases its lease (-R)
sudo -i sh -c 'kill $(cat /var/run/udhcpc-wlan0.pid)'
sudo -i wifi-wpa_cli -i wlan0 terminate
```

`wpa_supplicant` may report `rfkill: Cannot open RFKILL control device`, and
with some drivers `Could not re-add multicast membership for vendor events`:
neither matters. DSM's `dhclient` is of no use here: an AppArmor profile lets
it run its own script only, which sets the routes and DNS of every network it
joins.

## Related Packages

- [SynoKernel WiFi](synokernel-wifi.md) - USB WiFi adapter drivers
- [SynoCli Kernel Tools](synocli-kernel.md) - Kernel module loading and device profiles
