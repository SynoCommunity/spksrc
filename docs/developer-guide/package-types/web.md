# Web Applications

Web applications integrate with Synology's WebStation for PHP/HTML content.

## Basic Setup

```makefile
ADMIN_URL = /mywebapp/
RELOAD_UI = yes
include ../../mk/spksrc.spk.mk
```

## Resource File (DSM 7)

```json
{
  "webservice": {
    "pkg_dir_prepare": [{
      "source": "/var/packages/myapp/target/share/myapp",
      "target": "myapp",
      "mode": "copy"
    }],
    "services": [{
      "service": "myapp",
      "type": "apache_php",
      "root": "myapp",
      "php": {
        "backend": 11,
        "profile_name": "myapp_profile"
      }
    }]
  }
}
```

## PHP Backend Values

| Backend | PHP Version |
|---------|-------------|
| 8 | PHP 8.0 |
| 9 | PHP 8.1 |
| 10 | PHP 8.2 |
| 11 | PHP 8.3 |
| 12 | PHP 8.4 |

## Important Timing

WebStation's `pkg_dir_prepare` runs BEFORE `service_postinst`. Any custom web file configuration can be done in `service_postinst`.

## Example

See [nextcloud](https://github.com/SynoCommunity/spksrc/tree/master/spk/nextcloud) for a web application.
