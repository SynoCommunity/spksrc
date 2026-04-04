# Matrix Synapse

This package installs [Synapse](https://matrix-org.github.io/synapse/latest/), an open-source Matrix homeserver written and maintained by the [Matrix.org](https://matrix.org) Foundation.

## Installation

At installation time you must configure the server name, **because it cannot be changed later**.

The homeserver config file is installed at `/var/packages/matrix-synapse/var/homeserver.yaml` on your diskstation.

For further configuration, SSH into your device and edit this file with a privileged user. After modifying the configuration, restart the service either through DSM Package Center or via:

```bash
sudo synopkg restart matrix-synapse
```

For all configuration details visit [Configuring Synapse](https://matrix-org.github.io/synapse/latest/usage/configuration/config_documentation.html).

## Installation Wizard Options

### 1. Report Usage Statistics

Sets the option: `report_stats: true|false`

For what's reported see [Reporting Homeserver Usage Statistics](https://matrix-org.github.io/synapse/latest/usage/administration/monitoring/reporting_homeserver_usage_statistics.html).

### 2. Open Private Ports

Default (disabled) will configure a listener with `bind_addresses`:

```yaml
listeners:
  - port: 8008
    tls: false
    type: http
    x_forwarded: true
    bind_addresses: ['::1', '127.0.0.1']
    resources:
      - names: [client, federation]
        compress: false
```

If you check "Open private ports", the configuration will be created with `--open-private-ports`. This will create the listener on port 8008 without `bind_addresses` to listen on all local interfaces.

!!! warning
    Do not enable this unless you know what you are doing.

Most often you will disable "Open private ports" and add the IP of your device to the `bind_addresses` manually. This is a common use case with a [Reverse Proxy](https://matrix-org.github.io/synapse/latest/reverse_proxy.html).

## Add a New User

To add a user, SSH into your device and execute:

```bash
/var/packages/matrix-synapse/target/env/bin/register_new_matrix_user -c /var/packages/matrix-synapse/var/homeserver.yaml http://localhost:8008
```

This will prompt to add a new user:

```
New user localpart [root]: demo_user
Password:
Confirm password:
Make admin [no]: no
Sending registration request...
Success!
```
