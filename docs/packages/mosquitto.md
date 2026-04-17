---
title: Mosquitto
description: MQTT message broker
tags:
  - iot
  - mqtt
  - home-automation
---

# Mosquitto

Eclipse Mosquitto is an open source MQTT message broker for IoT and home automation.

## Package Information

| Property | Value |
|----------|-------|
| Package Name | mosquitto |
| Upstream | [mosquitto.org](https://mosquitto.org/) |
| License | EPL-2.0 |
| Default Port | 1883 (unencrypted), 8883 (TLS) |

## Installation

1. Install Mosquitto from Package Center
2. Configure authentication as needed

## Configuration

### Configuration File

Main config: `/var/packages/mosquitto/var/mosquitto.conf`

### Basic Security

```conf
# Require authentication
allow_anonymous false
password_file /var/packages/mosquitto/var/passwd

# Listener
listener 1883
```

### Create Users

```bash
# Create password file entry
/var/packages/mosquitto/target/bin/mosquitto_passwd -c /var/packages/mosquitto/var/passwd username

# Add additional users (without -c)
/var/packages/mosquitto/target/bin/mosquitto_passwd /var/packages/mosquitto/var/passwd newuser
```

### Enable TLS

```conf
listener 8883
certfile /path/to/cert.pem
keyfile /path/to/key.pem
cafile /path/to/ca.pem
```

## Usage

### Publish/Subscribe Testing

```bash
# Subscribe to topic
mosquitto_sub -h localhost -t "test/topic" -u username -P password

# Publish message (in another terminal)
mosquitto_pub -h localhost -t "test/topic" -m "Hello MQTT" -u username -P password
```

### Wildcards

```bash
# Subscribe to all topics under home/
mosquitto_sub -t "home/#"

# Single-level wildcard
mosquitto_sub -t "home/+/temperature"
```

## Integration

### Home Assistant

Add to Home Assistant configuration:

```yaml
mqtt:
  broker: your-nas-ip
  port: 1883
  username: mqtt_user
  password: mqtt_password
```

### Common IoT Devices

Mosquitto works with:
- Tasmota devices
- ESPHome
- Zigbee2MQTT
- Node-RED

## Troubleshooting

### Connection Refused

1. Check service is running: `synopkg status mosquitto`
2. Verify port is not blocked
3. Check authentication settings

### Logs

View logs: `/var/packages/mosquitto/var/mosquitto.log`

## Related Packages

- [Home Assistant](homeassistant.md) - Home automation platform
