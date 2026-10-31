---
title: SynoKernel WiFi
description: USB WiFi adapter drivers for Synology NAS
tags:
  - kernel
  - drivers
  - usb
  - wifi
---

# SynoKernel WiFi

!!! warning "Experimental, at your own risk"
    The kernel modules of SynoCommunity packages are outside of what Synology
    supports: a module that does not suit the kernel can crash the NAS, and DSM
    updates may break them. Support is limited: read this documentation, and
    check the issues already open, before opening one. Do not use them on a NAS
    you cannot afford to restart or recover.

Provides drivers of USB WiFi adapters for DSM 6 and DSM 7, with the wireless
stack of the Linux kernel, `cfg80211` and `mac80211`. DSM 7 kernels are built
without it, as Synology dropped WiFi adapters from DSM 7; on DSM 6 the package
adds adapters DSM does not support. SRM is not supported: the router has its
own wireless stack.

## Package Information

| Property | Value |
|----------|-------|
| Package Name | synokernel-wifi |
| License | GPLv2 |
| Dependencies | [SynoCli Kernel Tools](synocli-kernel.md) 2.0-12 or newer (module loading and device profiles) |

## Included Drivers

| Profile | Chips | Adapters |
|---------|-------|----------|
| `rtl88x2bu` | Realtek RTL8812BU, RTL8822BU | TP-Link Archer T3U, T3U Plus, T4U v3, ASUS USB-AC55 B1, D-Link DWA-181/182/183, Netgear A6150 |
| `rt2800usb` | Ralink RT2770 to RT5372 | Panda PAU05/PAU06, Alfa AWUS036NH |
| `rtl8192cu` | Realtek RTL8188CUS, RTL8192CU | Edimax EW-7811Un and other nano adapters |
| `rtl8xxxu` | Realtek RTL8188EU, RTL8192EU, RTL8723BU | kernels 4.4 and newer |
| `mt7601u` | MediaTek MT7601U | 150 Mbps nano adapters, kernels 4.4 and newer |
| `mt76x0u`, `mt76x2u` | MediaTek MT7610U, MT7612U | Alfa AWUS036ACM, TP-Link Archer T2U v1, kernels 5.10 |
| `ath9k_htc` | Atheros AR9271, AR7010 | TP-Link TL-WN722N v1, Alfa AWUS036NHA, kernels with LED triggers |
| `carl9170` | Atheros AR9170 | Netgear WN111 v2, TP-Link TL-WN821N v2 |
| `rtl8821cu` | Realtek RTL8811CU, RTL8821CU | |
| `rtl8821au` | Realtek RTL8811AU, RTL8821AU | kernels 4.4 and newer |
| `rtl8812au` | Realtek RTL8812AU | kernels 4.4 and newer |
| `rtl8814au` | Realtek RTL8814AU | kernels 4.4 and newer |
| `rtw88-8822bu`, `rtw88-8821cu`, `rtw88-8822cu`, `rtw88-8723du`, `rtw88-8812au`, `rtw88-8821au`, `rtw88-8814au` | Realtek RTL8822BU, RTL8821CU, RTL8822CU, RTL8723DU, RTL8812AU, RTL8821AU, RTL8814AU | kernels 5.10 |

The `rtl88x2bu`, `rtl8821cu`, `rtl8821au`, `rtl8812au` and `rtl8814au` profiles
load the [drivers of the Linux community](https://github.com/morrownr) for
these Realtek chips; `rtw88-*` load [rtw88](https://github.com/lwfinger/rtw88),
the mac80211 driver of the same chips in recent kernels, built out of tree.
For a chip both cover, load one profile or the other, not both. The others are
the drivers of each kernel, so newer kernels offer more of them. `synocli-kernelmodule list` tells which profiles
the kernel of the NAS can load. The firmware they need comes from
[linux-firmware](https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git).

Wireless extensions (`iwconfig`) are not available: they are part of the
kernel itself. Adapters are set up through `nl80211`, with `iw` and
`wpa_supplicant`.

## Usage

The modules are not loaded on installation: load those of your adapter, as
root, with `sudo -i` in front (`sudo` alone does not find the commands of packages), with the
`synocli-kernelmodule` helper of [SynoCli Kernel Tools](synocli-kernel.md):

```bash
synocli-kernelmodule list
sudo -i synocli-kernelmodule --profile rtl88x2bu start
sudo -i iw dev
```

`iw dev` names the interface of the adapter, usually `wlan0`.

### Connecting to a network

DSM 7 does not show WiFi interfaces in its network settings, nor DSM 6 those of
the adapters it does not support: the connection is set up from the command
line, with the tools of this package -- `wpa_supplicant` 2.11, which knows WPA3,
and a DHCP client, `udhcpc`. DSM has a `wpa_supplicant` of its own, 2.6 without
WPA3, first in the `PATH` of root: those of the package are `wifi-wpa_supplicant`,
`wifi-wpa_cli` and `wifi-wpa_passphrase`.
Set the [regulatory domain](#regulatory-domain) first, and start from a clean
state: no other `wpa_supplicant` nor DHCP client on `wlan0`, and no address. A
second `wpa_supplicant` fights the first for the interface, and one started
without a control interface cannot be stopped by `wpa_cli`. The patterns leave
alone a `wpa_supplicant` of DSM on the wired interface (802.1X):

```bash
# What runs on which interface (-i)
ps -ef | grep -E '[w]pa_supplicant|[u]dhcpc'

# Back to a clean state: stop wpa_supplicant through its control interface,
# and the DHCP client, which has none
sudo -i wifi-wpa_cli -i wlan0 terminate
sudo -i pkill -f 'udhcpc.*-i wlan0'
sudo -i ip addr flush dev wlan0

# A wpa_supplicant started without a control interface (-C) is out of reach of
# wpa_cli: stop it by its command line
sudo -i pkill -f 'wpa_supplicant.*-i wlan0'
```

!!! warning
    Over a session that goes through `wlan0`, resetting it cuts the session, and
    the NAS stays off the WiFi network until it is connected again from a cable,
    the console, or a reboot that runs the boot task. On a NAS on WiFi alone,
    reset and reconnect in one command that goes on once the session is gone
    (`sudo -v` first: in the background, `sudo` cannot ask for a password):

    ```bash
    sudo -v
    sudo -i nohup sh -c 'wifi-wpa_cli -i wlan0 terminate; pkill -f "udhcpc.*-i wlan0"; ip addr flush dev wlan0; wifi-wpa_supplicant -B -D nl80211 -i wlan0 -C /var/run/wpa_supplicant -c /var/packages/synokernel-wifi/var/wpa_supplicant.conf && sleep 10 && env WIFI_DEFAULT_ROUTE=1 udhcpc -i wlan0 -s /var/packages/synokernel-wifi/target/etc/udhcpc.script -b' > /dev/null 2>&1 &
    ```

Then:

```bash
# The networks in range
sudo -i ip link set wlan0 up
sudo -i iw dev wlan0 scan | grep -E 'SSID|freq|signal'

# The network and its passphrase, readable by root only, without the clear-text copy
sudo -i sh -c 'umask 077; wifi-wpa_passphrase "MyNetwork" "MyPassphrase" | grep -v "#psk" > /var/packages/synokernel-wifi/var/wpa_supplicant.conf'

# Connect, then check the link
sudo -i wifi-wpa_supplicant -B -D nl80211 -i wlan0 -C /var/run/wpa_supplicant -c /var/packages/synokernel-wifi/var/wpa_supplicant.conf -f /var/packages/synokernel-wifi/var/wpa_supplicant.log
sudo -i iw dev wlan0 link
```

To try a network without writing a file, give the output of `wifi-wpa_passphrase`
to `wpa_supplicant` on its standard input; the control interface (`-C`) lets
`wifi-wpa_cli` follow and stop it, and refuses a second instance on the same
interface:

```bash
wifi-wpa_passphrase "MyNetwork" "MyPassphrase" | sudo -i wifi-wpa_supplicant -B -D nl80211 -i wlan0 -C /var/run/wpa_supplicant -c /dev/stdin
sudo -i wifi-wpa_cli -i wlan0 status
sudo -i wifi-wpa_cli -i wlan0 terminate
```

That configuration cannot be read again (`wpa_cli reconfigure`): at boot, use
the file.

For a WPA3 network, add `key_mgmt=SAE` and `ieee80211w=2` to the network block
of the configuration. `wpa_supplicant` may report `rfkill: Cannot open RFKILL
control device`, and with some drivers `Could not re-add multicast membership
for vendor events`: neither matters.

Once `iw dev wlan0 link` shows `Connected to`, get an address:

```bash
# The address only: the wired interface keeps the default route and DNS servers
sudo -i udhcpc -i wlan0 -s /var/packages/synokernel-wifi/target/etc/udhcpc.script -b

# On a NAS on WiFi alone: the default route and DNS servers of the WiFi network too
sudo -i env WIFI_DEFAULT_ROUTE=1 udhcpc -i wlan0 -s /var/packages/synokernel-wifi/target/etc/udhcpc.script -b
```

`-b` keeps `udhcpc` in the background to renew the lease. DSM's `dhclient` is
of no use here: an AppArmor profile lets it run its own script only, which
sets the routes and DNS of every network it joins.

To connect at every startup, add the commands after `synocli-kernelmodule` in
the task of [Loading modules at boot](synocli-kernel.md#loading-modules-at-boot).

### Regulatory domain

The kernel starts in the world regulatory domain, which leaves out most 5 GHz
channels. Set the country of the NAS, here Canada, before connecting:

```bash
sudo -i iw reg set CA
sudo -i iw reg get
```

The rules come from [wireless-regdb](https://wireless.docs.kernel.org/en/latest/en/developers/regulatory/wireless-regdb.html):
`regulatory.db` on kernels 4.15 and newer, compiled into `cfg80211` on older
ones, so no CRDA is needed.
