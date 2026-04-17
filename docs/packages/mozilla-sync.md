# Mozilla Sync Server

Mozilla Sync Server allows you to sync bookmarks, passwords, settings, history, add-ons, and tabs across multiple Firefox devices.

## Supported Clients

- **Desktop**: Firefox 42+
- **Mobile**: Firefox 44+ (Android) and Firefox 18+ (iOS)
- **Forks**: Compatible with Iceweasel and similar alternatives

## Installation

During installation, you'll be prompted to enter the **MariaDB root password** to create a database for storing synced data.

### Choosing Your Public URL

You must choose **either** an **internal IP** or an **external domain name**.

| Use Case | URL Format | Desktop? | Mobile? |
|----------|------------|----------|----------|
| Internal-only (Local Sync) | `http://192.168.1.100:8132` | ✅ Yes | ❌ No |
| External + Mobile Access | `https://example.com:8133` | ✅ Yes | ✅ Yes |

!!! note
    Mobile clients require HTTPS. If you plan to sync Firefox on mobile devices, you must use an external domain with SSL.

### After Installation

The Sync Server will be available at:
- **Internal setup**: `http://192.168.1.100:8132/1.0/sync/1.5`
- **External setup**: `https://example.com:8133/1.0/sync/1.5`

### Testing Installation

Entering the Sync URL in a browser will return an "Unauthorized" error. To verify the server is running, visit:

```
http://192.168.1.100:8132/__heartbeat__
```

## Configuring Firefox

### Desktop Clients

1. Open Firefox and go to `about:config`
2. Search for `identity.sync.tokenserver.uri` and update it to:
   ```
   http://192.168.1.100:8132/1.0/sync/1.5
   ```
   (For Firefox 42 or earlier, use `services.sync.tokenServerURI` instead)
3. Open the menu in Firefox and click **Sign in to Sync**. Follow the prompts.
4. Repeat step 2 on additional devices before signing in with the same account.

### Android Clients

1. **Enable the debug menu before signing in**:
   - Go to **Settings > About Firefox** and tap the **Firefox logo five times** until you see "Debug menu enabled"
2. Open **Settings > Sync Debug**, then set:
   - **Custom Sync Server**: `https://example.com:8133/1.0/sync/1.5`
3. Tap **✕ Stop Firefox** in the menu, then reopen the app
4. Sign in via **Settings > Synchronize and Save Data**

### iOS Clients

1. **Enable debug settings before signing in**:
   - Go to **Settings > About** and tap the version number **five times** until a **Debug section** appears
2. In **Account > Advanced Sync Settings**, set:
   - **Custom FxA Content Server**: `https://accounts.firefox.com`
   - **Custom Sync Token Server**: `https://example.com:8133/1.0/sync/1.5`
3. Go to **Settings > Account > Synchronize and Save Data**, then sign in

## Enabling SSL (HTTPS)

Mozilla Sync Server does not natively support SSL. Use Synology DSM's built-in reverse proxy.

### Prerequisites

- You plan to use HTTPS (`https://example.com:8133`)
- You have a **domain name** resolving to your Synology's public IP
- A valid SSL certificate is installed on your Synology DSM

### DSM Reverse Proxy Setup

1. Open DSM Reverse Proxy Settings:
   - **DSM 6**: `Control Panel > Application Portal > Reverse Proxy`
   - **DSM 7**: `Control Panel > Login Portal > Advanced > Reverse Proxy`
2. Create a new reverse proxy rule:
   - **Description**: Mozilla Sync Server
   - **Source**:
     - Protocol: HTTPS
     - Hostname: `example.com`
     - Port: `8133` (or `443` if available)
     - Enable **HSTS**
   - **Destination**:
     - Protocol: HTTP
     - Hostname: `localhost`
     - Port: `8132`
3. Save and apply the changes

### Router & Firewall Configuration

To allow external access:

- Open **port 8133** in Synology's firewall (`Control Panel > Security > Firewall`)
- Forward **port 8133** on your router/firewall to your Synology NAS
- Ensure your domain resolves to your public IP
- For internal access, configure an internal DNS record mapping your domain to your Synology's local IP

## Troubleshooting

### Checking Logs

Firefox logs sync errors at: `about:sync-log`

To enable success logs, go to `about:config` and set:
```
services.sync.log.appender.file.logOnSuccess = true
```

### Common Errors

**Mobile Clients Can't Connect**

- Firefox mobile requires HTTPS. Ensure SSL is set up properly.
- **iOS login fails with a blank page**: Ensure Custom FxA Content Server is set to `https://accounts.firefox.com` (no trailing slash)

## References

- [Mozilla Sync Server Documentation](https://mozilla-services.readthedocs.io/en/latest/howtos/run-sync-1.5.html)
- [Firefox Sync for Android](https://support.mozilla.org/en-US/kb/how-set-firefox-sync-firefox-android)
- [Synology DSM Reverse Proxy Setup](https://kb.synology.com/en-us/DSM/help/DSM/AdminCenter/system_login_portal_advanced?version=7)
