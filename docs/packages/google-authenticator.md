# Google Authenticator PAM

This module installs [google authenticator](https://github.com/google/google-authenticator-libpam) as a package for libpam. This allows you to use Google Authenticator to generate TOTP (Time-based One-Time Password) when signing into services on your Synology, such as SSH.

Installing this package alone has no effect, as it requires users to manually configure the installed `.so` file in their authentication service.

!!! warning
    Keep an existing SSH session open while testing. A mistake in `sshd_config` or the PAM configuration can lock you out.

## Setup for SSH

The following setup requires SSH with a password to use TOTP, while SSH with public-key auth will not. This is suitable if you primarily use public-key to access your server but occasionally want password access with additional security.

For a more in-depth guide, see the [DigitalOcean MFA for SSH tutorial](https://www.digitalocean.com/community/tutorials/how-to-set-up-multi-factor-authentication-for-ssh-on-ubuntu-18-04).

### Quick setup

Run the helper as an administrator:

```bash
sc-google-authenticator-setup
```

It prompts for your DSM password, backs up `/etc/ssh/sshd_config` and `/etc/pam.d/sshd` to `*.sc-google-authenticator.bak`, applies the changes below, validates the SSH configuration, and restarts SSH.

After it finishes, run the token generator as the user who will log in, not with `sudo`:

```bash
sc-google-authenticator
```

The wrapper sets `~/.google_authenticator` permissions to `600` automatically.

The helper adds `nullok` to the PAM line. Remove `nullok` from `/etc/pam.d/sshd` if every SSH user must use TOTP.

To undo the file changes:

```bash
sc-google-authenticator-setup undo
```

To check the current state:

```bash
sc-google-authenticator-setup status
```

### Manual setup (reference)

The helper applies the following changes. Use these steps only if you prefer to edit the files manually.

#### 1. Edit /etc/ssh/sshd_config

```bash
sudo vim /etc/ssh/sshd_config
```

Update the existing global settings in the file; do not replace the whole file. DSM appends `Match` blocks at the end, and settings placed after the first `Match` block apply only to that match. Keep these settings before the first `Match` block.

```
# Password authentication
PasswordAuthentication yes
PermitEmptyPasswords no

# Challenge-response authentication
# Newer OpenSSH uses KbdInteractiveAuthentication instead.
ChallengeResponseAuthentication yes

# PAM
UsePAM yes

# Never permit root login
PermitRootLogin no
```

!!! note
    `PasswordAuthentication yes` and `UsePAM yes` are usually already set. Change `ChallengeResponseAuthentication` to `yes`, uncomment `PermitEmptyPasswords no`, and set `PermitRootLogin no` if it is not already set.

!!! note
    On newer OpenSSH versions, `ChallengeResponseAuthentication` is deprecated; use `KbdInteractiveAuthentication yes` instead. DSM 7.2 still accepts the older directive.

!!! note
    DSM may regenerate `/etc/ssh/sshd_config` when SSH settings are changed in Control Panel or after a DSM update. Re-check these lines afterwards.

#### 2. Edit /etc/pam.d/sshd

```bash
sudo vim /etc/pam.d/sshd
```

Add the following line immediately after the `pam_syno_ipblocklist.so` line if it exists; otherwise insert it before `pam_unix.so`. Do not place it after `pam_syno_support.so` on DSM 7.2 and later — that module uses a jump that can skip later auth modules.

```
auth required /var/packages/google-authenticator-libpam/target/lib/security/pam_google_authenticator.so nullok
```

The `nullok` option allows users without a configured token to log in with just their password. Remove `nullok` if every SSH user must use TOTP.

Restart SSH so the `sshd_config` changes take effect:

```bash
sudo synosystemctl restart sshd.service
```

#### 3. Generate Config for Google Authenticator

Run the packaged binary **as the user who will log in**, not with `sudo`. This stores the token in that user's home directory. Repeat for each user who needs TOTP.

```bash
sc-google-authenticator
```

Follow the prompts to set up time-based tokens. A QR code URL will be provided for scanning with your authenticator app. The URL embeds the OTP secret, so treat it as sensitive and do not share it.

The `sc-google-authenticator` wrapper sets the config file permissions to `600` automatically. If you run the upstream `google-authenticator` binary directly, run `chmod 600 ~/.google_authenticator` afterwards.

!!! note
    Some NAS models already ship Synology's own `google-authenticator` at the system path. That version can generate invalid base64 secrets ([#4852](https://github.com/SynoCommunity/spksrc/pull/4852)), so the SynoCommunity version is symlinked as `sc-google-authenticator` to avoid the conflict.

## Result

Users with a configured token will be prompted for a verification code:

```
$ ssh synology
(foo@synology) Verification code: 
(foo@synology) Password: 
foo@synology ~ $ 
```

With `nullok`, users without a token can still log in by password.
