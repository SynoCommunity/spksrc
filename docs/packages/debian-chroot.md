# Debian Chroot

Debian is a free operating system (OS) that comes with over 29000 packages, precompiled software bundled up in a nice format for easy installation on your DiskStation.

Debian Chroot allows you to benefit from the Debian OS inside your DiskStation, alongside DSM. **This package is intended for advanced users only.**

## Installation

Once the installation finishes in Package Center, it continues in the background and you can see its status as "Installing" under Overview in the left pane. When complete, the status will change to "Installed".

In the same pane, you can monitor how many services are running and perform update operations.

## Usage

As soon as the status is "Installed", connect to the DiskStation through SSH (root user) and use:

```bash
/var/packages/debian-chroot/scripts/start-stop-status chroot
```

On the first use (after several minutes), perform some configuration operations:

```bash
# Update packages
apt-get update
apt-get upgrade

# Configure locales
apt-get install locales
dpkg-reconfigure locales

# Configure timezone
dpkg-reconfigure tzdata
```

## Configure Services

Debian Chroot allows you to manage the packages you installed in the chroot directly from DSM.

Under **Services** in the left pane, you can manage services that you manually installed previously in the chroot: start and stop them easily.

### Configuration Steps

1. Manually install in the chroot the service you chose
2. Configure it by editing the correct configuration files
3. In the interface, click on Add and fill the form. The launch script will be launched with the `start` argument to start the service and `stop` to stop it. The status command shall return exit code 0 if the service is started or 1 if it is stopped.

### Example: SSH Server

1. Install the SSH server: `apt-get install ssh`
2. Edit the configuration file: `/etc/ssh/sshd_config` to change the port number and other settings
3. Click on Add and put the name SSHD, the launch script `/etc/init.d/ssh` and the status command `ps -p $(cat /var/run/sshd.pid)`

### Manual Service Configuration (DSM 6 Workaround)

The GUI of the chroot app may be broken in DSM 6. Services init information is stored in a SQLite database:

```bash
# SSH into as admin on Synology
sudo sqlite3 /volume1/@appstore/debian-chroot/var/debian-chroot.db

# Create the SSH Server entry
INSERT INTO services VALUES ('0', 'SSHD', '/etc/init.d/ssh','ps aux | grep /usr/sbin/sshd | grep -v grep');

# Verify
SELECT * FROM services;
```

Don't forget to raise the row ID for each entry. The status command must return exit code 0 for a running service or 1 for a stopped service.

To verify services work correctly, stop and start the chroot app via the Synology Package Center.
