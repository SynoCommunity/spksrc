# AdGuard Home

[AdGuard Home](https://adguard.com/en/adguard-home/overview.html) is a network-wide software for blocking ads and tracking.

## Installation Instructions

1. Install package but **uncheck** the box to run the package automatically after installation
2. Run one of the commands below in Set Permissions
3. Start the package
4. Click Open to open the Web Browser to the AdGuardHome welcome page e.g. `http://192.168.0.2:6053/`

## Set Permissions

This is necessary to run AdGuardHome on port 53 (the default DNS port) otherwise AdGuardHome won't run. Choose one of the options below.

### Option 1 - Running as Root

The following command (as root) needs to be run after installation and after any SynoCommunity package updates:

```bash
sed -i 's/package/root/g' /var/packages/adguardhome/conf/privilege
```

### Option 2 - Running Without Superuser

Learn more: [AdGuard Home - Running without superuser](https://adguard-dns.io/kb/adguard-home/getting-started/#running-without-superuser)

The following command (as root) needs to be run after installation and after every AdGuardHome update or SynoCommunity package update:

```bash
setcap 'CAP_NET_BIND_SERVICE=+eip CAP_NET_RAW=+eip' /var/packages/adguardhome/target/bin/adguardhome
```

If you are too late with running the command, the update should roll back or stop. You should be able to stop & start the package again to try the update again after running the command.

## Using Task Scheduler

You can automate running these commands using DSM Task Scheduler:

1. Open **Control Panel** > **Task Scheduler**
2. Create a new **Triggered Task** > **User-defined script**
3. Set the task to run as **root**
4. Add your chosen command in the script section
5. Configure the trigger (e.g., on boot or after package update)
