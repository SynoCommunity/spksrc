# FlexGet

[FlexGet](https://flexget.com/) is a multipurpose automation tool for all of your media.

## Initial Setup

At first use you must set a new password for flexget using the command line:

```bash
sudo su -s /bin/bash sc-flexget -c '/var/packages/flexget/target/env/bin/flexget -c /var/packages/flexget/var/config.yml web passwd <MyPasswd>'
```

## Web Interface

Access the web interface at `http://<mySynoNASIP>:8290` and login as user `flexget` with your newly associated password.

From there follow the [FlexGet Configuration documentation](https://flexget.com/Configuration) to complete your configuration.

## Command Line Usage

All command line use of flexget has to be done as user `sc-flexget` and needs explicit parameter for the configuration file.

For example, to call `flexget trakt auth <account>` you must use:

```bash
sudo su -s /bin/bash sc-flexget -c '/var/packages/flexget/target/env/bin/flexget -c /var/packages/flexget/var/config.yml trakt auth <account>'
```
