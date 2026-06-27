---
title: MinIO
description: S3-compatible object storage server
tags:
  - storage
  - s3
  - server
---

# MinIO

MinIO is a high-performance, S3 compatible object storage solution.

## Package Information

| Property | Value |
|----------|-------|
| Package Name | minio |
| Upstream | [min.io](https://min.io/) |
| License | AGPL-3.0 |
| Default Port | 9000 (API), 9001 (Console) |

## Installation

1. Install MinIO from Package Center
2. The wizard will ask for data share location
3. Access web console at `http://your-nas:9001`

## Configuration

### Data Location

- Data directory: Configured during installation (your chosen share)
- Configuration: `/var/packages/minio/var/`

### Default Credentials

Initial credentials are set during installation. To reset:

1. Stop the MinIO package
2. Edit `/var/packages/minio/var/minio.env`
3. Set `MINIO_ROOT_USER` and `MINIO_ROOT_PASSWORD`
4. Start the package

### Creating Buckets

1. Access web console at port 9001
2. Navigate to Buckets → Create Bucket
3. Configure access policies as needed

## Using with Applications

### AWS CLI

```bash
aws configure
# Set endpoint-url for all commands
aws --endpoint-url http://your-nas:9000 s3 ls
```

### rclone

```ini
[minio]
type = s3
provider = Minio
endpoint = http://your-nas:9000
access_key_id = your_access_key
secret_access_key = your_secret_key
```

## Troubleshooting

### Cannot Access Console

Ensure port 9001 is accessible. The API (9000) and Console (9001) use different ports.

### Disk Full Errors

MinIO requires sufficient disk space. Check your data share has available space.

## Related Packages

- [rclone](rclone.md) - Cloud storage sync tool
- Garage - Alternative S3-compatible storage
