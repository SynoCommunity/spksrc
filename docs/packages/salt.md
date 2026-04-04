# SaltStack

[SaltStack](https://docs.saltproject.io/en/getstarted/) provides infrastructure automation and configuration management.

## Salt Master

This package is used to **send commands** and configurations to the Salt minion running on managed systems.

### Salt GUI

To log in to the included GUI, use the credentials of a local Synology user who belongs to the administrators group.

### Caveats

Salt master is running as non-root. See [Running Salt as an unprivileged user](https://docs.saltproject.io/en/latest/ref/configuration/nonroot.html).

## Salt Minion

This package runs the Salt minion which **receives commands** and configuration from a Salt master.

## Configuration Files

| Package | Location |
|---------|----------|
| Salt Master | `/var/packages/salt-master/etc/salt` |
| Salt Minion | `/var/packages/salt-minion/etc/salt` |

## Running Salt Commands

```bash
sudo su sc-salt-master -s /usr/bin/bash
salt -c /var/packages/salt-master/etc/salt '*' cmd.run 'ls -l'
```

## Example Setup

1. Install both salt-minion and salt-master

2. Add salt-minion to salt-master (via SSH):

```bash
sudo su sc-salt-master -s /usr/bin/bash
salt-key -c /var/packages/salt-master/etc/salt --list all
salt-key -c /var/packages/salt-master/etc/salt -a dsm6

# Test and run commands:
salt -c /var/packages/salt-master/etc/salt '*' test.ping
salt -c /var/packages/salt-master/etc/salt '*' cmd.run 'ls -l'
```

## Troubleshooting

**Authentication error occurred.**

Make sure that you are running commands as the salt-master user:

```bash
sudo su sc-salt-master -s /usr/bin/bash
```
