# Google Authenticator PAM

This module installs [google authenticator](https://github.com/google/google-authenticator-libpam) as a package for libpam. This allows you to use Google Authenticator to generate TOTP (Time-based One-Time Password) when signing into services on your Synology, such as SSH.

Installing this package alone has no effect, as it requires users to manually configure the installed `.so` file in their authentication service.

## Setup for SSH

The following setup requires SSH with a password to use TOTP, while SSH with public-key auth will not. This is suitable if you primarily use public-key to access your server but occasionally want password access with additional security.

### 1. Edit /etc/ssh/sshd_config

```bash
sudo vim /etc/ssh/sshd_config
```

```
# Password authentication
PasswordAuthentication yes
PermitEmptyPasswords no

# Challenge-response authentication
ChallengeResponseAuthentication yes

# PAM
UsePAM yes

# Never permit root login
PermitRootLogin no
```

### 2. Edit /etc/pam.d/sshd

```bash
sudo vim /etc/pam.d/sshd
```

Add the following line after `auth requisite pam_syno_ipblocklist.so`:

```
auth required /var/packages/google-authenticator-libpam/target/lib/security/pam_google_authenticator.so nullok
```

### 3. Generate Config for Google Authenticator

Use the packaged binary to generate the config:

```bash
sc-google-authenticator
```

Follow the prompts to set up time-based tokens. A QR code URL will be provided for scanning with your authenticator app.

Make sure the config file is not world-readable:

```bash
sudo chmod 600 ~/.google_authenticator
```

!!! note
    Some NAS models may already contain Synology's own version of `google-authenticator` at system path. The SynoCommunity version is symlinked as `sc-google-authenticator` to avoid name conflict.

## Result

Any SSH to the server without public key auth will require a verification code from your app:

```
$ ssh synology
(foo@synology) Verification code: 
(foo@synology) Password: 
foo@synology ~ $ 
```
