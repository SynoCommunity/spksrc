---
title: DSM mini — Telegram Mini App
description: Manage your NAS from Telegram — downloads, files, disks, virtual machines, containers and DSM notifications
tags:
  - packages
  - download
  - telegram
---

# DSM mini — Telegram Mini App

A Telegram bot with a Mini App for managing the NAS. Send the bot a magnet link, a `.torrent` file or a direct link and it asks which folder to put it in and hands it to Download Station. The Mini App shows the task list with speed and time left, File Station folders, disks and volumes, virtual machines, Container Manager containers and the DSM log — and DSM's own notifications can be forwarded to the chat. Only the Telegram accounts you list get in.

## Package Information

| Property | Value |
|----------|-------|
| Package Name | dsm-mini |
| Upstream | [github.com/alexlnos/dsm-mini](https://github.com/alexlnos/dsm-mini) |
| License | MIT |
| Maintainer | @alexlnos |
| Port | 58080, on `127.0.0.1` only — reached through a reverse proxy or a tunnel, if at all |

## Before You Install

You need three things, and the package asks for nothing during installation — it is all entered afterwards, in its own window. An address for the Mini App is optional; see [The Public Address](#the-public-address).

1. **A bot.** In Telegram, open [@BotFather](https://t.me/BotFather), send `/newbot` and keep the token it answers with — whoever holds it controls the bot.
2. **Your Telegram id.** [@userinfobot](https://t.me/userinfobot) tells you: it is the number, not the @username.
3. **A DSM account for the service.** **Control Panel** > **User & Group** > **Create**, with access to Download Station and File Station. Do not turn on two-factor verification for it: the service signs in by itself and cannot type in a code.

## Setup

1. Install **DSM mini — Telegram Mini App** from Package Center. When it is done, Package Center says where to go next: the package runs, with the bot and the Mini App switched off until they are set up.
2. Open **DSM mini** from the DSM main menu (only administrators see it).
3. Fill in the DSM account and its password, the bot token and the allowed Telegram ids. Every field explains itself in the window. **Check the account** signs in as that account and lists what DSM lets it do — see [Permissions](#permissions-of-the-dsm-account). Under **Mini App access**, choose how the phone will reach the Mini App, or **The bot only, no Mini App** — see [The Public Address](#the-public-address).
4. Click **Save**, then **Start** at the top of the window. The status there says when DSM and the bot have answered, and what is wrong if they have not. **Start** and **Stop** are remembered across restarts of the NAS, and a save applies at once: the package does not have to be restarted.
5. Open the bot in Telegram and press **Start**. With a public address, the Mini App opens from the button next to the input field.

The password and the token are write-only in the window: an empty field keeps what was saved.

### Permissions of the DSM Account

The service does everything as the account you give it, so it can do no more than that account can.

- An **ordinary account** with Download Station and File Station is enough for the bot, downloads and files — and it is the recommended choice: the service is reachable from the internet and can delete files.
- DSM shows some of the NAS overview to **administrators only**: the NAS details, the load and the storage state are refused to an ordinary account (DSM answers with code 105, "permission denied", and 1006 for the NAS details). The Mini App says so in those places instead of empty figures or a screen that looks disconnected.

**Check the account** in the window goes through all of it for the account typed in, read-only: the sign-in, Download Station, File Station and the shared folders it sees — what the bot cannot work without — and then each section of the Mini App, with DSM's code for every refusal.

## The Public Address

The address is only for the Mini App, and it is **optional**. Leave it empty and the bot works on its own — links, `.torrent` files, `/status` and notifications — with nothing on the NAS reachable from outside: the bot only makes outgoing connections to Telegram.

Telegram opens a Mini App only over HTTPS with a certificate the phone trusts, and it is the phone that opens it: the address has to be reachable from the phone you use Telegram on, not from Telegram's servers. Ways to get one:

| Way | Ports opened on the router | Who can reach the address |
|-----|----------------------------|---------------------------|
| [DSM's reverse proxy](#reverse-proxy-in-dsm) | 443, and 80 for Let's Encrypt | anyone; only the allowed ids get past the service |
| [Cloudflare Tunnel](#cloudflare-tunnel) | none | anyone, through Cloudflare; the same check applies |
| [Tailscale](#tailscale) | none | only your own devices in the tailnet |
| [Home network only](#home-network-only) | none | devices on the home network, or on a VPN into it |

Whatever serves the address forwards it to `http://localhost:58080` on the NAS. The address can be changed or cleared in the window at any time; the bot does not have to be recreated.

In the window this is **Mini App access**: the bot only, through DDNS, an own domain on a static address, the home network only, or another way. Each choice lists its own steps, with the addresses of this NAS filled in, and the ways through DSM create the reverse proxy rule from there.

### Reverse Proxy in DSM

The window's **Create the rule** does this for you. By hand:

1. **Control Panel** > **Login Portal** > **Advanced** > **Reverse Proxy** > **Create**:

    | Field | Value |
    |-------|-------|
    | **Description** | DSM mini |
    | **Source Protocol** | HTTPS |
    | **Source Hostname** | your name, e.g. `nas.example.com` |
    | **Source Port** | 443 |
    | **Destination Protocol** | HTTP |
    | **Destination Hostname** | localhost |
    | **Destination Port** | 58080 |

2. **Control Panel** > **Security** > **Certificate**: get a certificate for the name (Let's Encrypt needs port 80 to reach the NAS) and assign it to the rule under **Settings**.

Do not proxy port 80 for the name: DSM renews the certificate through it.

`https://your-name/healthz` answering `{"status":"ok"}` means the address works; nothing else is served without Telegram's signature.

### Cloudflare Tunnel

Needs a domain whose DNS is on Cloudflare.

1. In the Cloudflare dashboard, create a tunnel and copy its token. Install [Cloudflared](cloudflared.md) and paste the token when it asks.
2. Give the tunnel a public hostname, for example `mini.example.com`, with the service `http://localhost:58080`.
3. In the DSM mini window, choose **Another way** under **Mini App access** and enter `https://mini.example.com`.

### Tailscale

For a Mini App that only your own devices can open.

1. Install Tailscale on the NAS (it is in Package Center) and on the phone, signed in to the same tailnet.
2. In the Tailscale admin console, under **DNS**, turn on MagicDNS and HTTPS certificates.
3. On the NAS over SSH: `sudo tailscale serve --bg 58080`. It answers with the address, `https://<nas-name>.<tailnet>.ts.net`.
4. In the DSM mini window, choose **Another way** under **Mini App access** and enter that address.

The Mini App then opens while the phone is connected to Tailscale; the bot works either way.

### Home Network Only

For a Mini App that opens on the home network, or through a VPN into it, with nothing forwarded on the router.

1. Pick a name and make it lead to the NAS's local address inside the network, in the router's DNS. The window shows that address.
2. Create the reverse proxy rule for the name from the window.
3. Get a certificate for the name some other way than DSM's own Let's Encrypt, which needs the NAS reachable from the internet on port 80: through a DNS check, with acme.sh for example. Import it under **Control Panel** > **Security** > **Certificate** > **Add** > **Import** and assign it to the rule under **Settings**.

## Configuration

### Data Location

| File | What it holds |
|------|---------------|
| `/var/packages/dsm-mini/var/config.env` | the settings from the window, mode `600` |
| `/var/packages/dsm-mini/var/dsm-mini.db` | pinned folders, the language, the last known task states |
| `/var/packages/dsm-mini/var/dsm-mini.log` | the log |

An upgrade keeps all three. **Uninstall only** in the uninstall wizard keeps them too; the other choice erases them.

### Ports

The service listens on `127.0.0.1:58080` only. The port is registered with DSM, so DSM's port conflict check names dsm-mini for it. It can be changed under **Advanced** in the window if something else holds it; both addresses there accept only the NAS itself (`localhost`), since the service reaches DSM and is reached by the proxy on the same machine.

### DSM Notifications

The service registers a webhook, **DSM mini — Telegram Mini App**, in **Control Panel** > **Notification** > **Webhook**, and DSM calls it on every notification. Whether they reach the chat is chosen in the window: nothing, finished downloads only, or everything DSM announces. The webhook is removed when the package is uninstalled.

## Troubleshooting

The status at the top of the DSM mini window is the first place to look. The details are in the log: `/var/packages/dsm-mini/var/dsm-mini.log`, also opened from Package Center.

**The window says "Stopped"**

- The bot and the Mini App are switched off: click **Start**. If the button is grey, the line above it names the settings still missing.

**"DSM refused the sign-in"**

- Wrong user name or password, a disabled account, or two-factor verification on the account. Give the service an account without it.

**"The NAS cannot reach api.telegram.org"**

- The bot connects as soon as it can; the Mini App keeps working meanwhile. Check the NAS's own internet access, DNS and any VPN it goes through.

**"The DSM account the service uses has no access to this"**

- That part of DSM is shown to administrators only. See [Permissions of the DSM Account](#permissions-of-the-dsm-account).

**The bot answers "access to this bot is closed"**

- Your Telegram id is not among the allowed ones: add it in the window. Ids are numbers separated by commas.

**There is no button for the Mini App**

- **Mini App access** is set to the bot only, or the address is not `https://`. See [The Public Address](#the-public-address).

### Getting Help

- [GitHub Issues](https://github.com/alexlnos/dsm-mini/issues) upstream
- [SynoCommunity issues](https://github.com/SynoCommunity/spksrc/issues) for packaging

## Architecture Support

| Architecture | DSM 6 | DSM 7 | Notes |
|--------------|-------|-------|-------|
| x64 | - | ✓ | |
| aarch64 | - | ✓ | |
| armv7 | - | ✓ | |
| evansport | - | ✓ | |
| comcerto2k | - | ✓ | |
| armv5, ppc | - | - | Unsupported |

## Changelog

### Version 1.0.14-1

- Initial release.

## See Also

- [Upstream README](https://github.com/alexlnos/dsm-mini#readme), in ten languages
