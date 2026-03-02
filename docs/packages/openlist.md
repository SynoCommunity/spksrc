# OpenList

[OpenList](https://docs.oplist.org/) is an open-source file list program that supports multiple storage.

## Installation Notes

When filling in the `site_url`, it is not recommended to leave it blank, as it will affect certain functions:

- Thumbnailing LocalStorage
- Previewing site after setting web proxy
- Displaying download address after setting web proxy
- Reverse-proxying to site sub directories

After installation, the configuration file is located at `/var/packages/openlist/var/config.json`.

To adjust the configuration, see [OpenList Configuration File](https://docs.oplist.org/config/configuration.html) for all available options.

## DSM Folder Permissions

This package runs as internal service user **sc-openlist** in DSM. If you want to configure DSM folders as OpenList Local storage, you must ensure that this user has the required permissions.

See [Permission Management](../developer-guide/packaging/resource-files.md) for details.

## Resources

- [Official Documentation](https://docs.oplist.org/)
