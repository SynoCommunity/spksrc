# DSM APIs and External Resources

This page provides links to official Synology documentation and resources for DSM package development.

## Synology Package Developer Guide

The official Synology documentation for package development:

| Section | URL | Description |
|---------|-----|-------------|
| Overview | [Getting Started](https://help.synology.com/developer-guide/getting_started/gettingstarted.html) | Prerequisites and introduction |
| Package Structure | [Package Structure](https://help.synology.com/developer-guide/synology_package/package_structure.html) | SPK file format |
| INFO File | [INFO File](https://help.synology.com/developer-guide/synology_package/INFO.html) | Package metadata |
| Scripts | [Scripts](https://help.synology.com/developer-guide/synology_package/scripts.html) | Lifecycle scripts |
| Privilege | [Privilege Configuration](https://help.synology.com/developer-guide/synology_package/privilege.html) | Service user and permissions |

## Resource Acquisition (DSM 7+)

| Section | URL | Description |
|---------|-----|-------------|
| Overview | [Resource Acquisition](https://help.synology.com/developer-guide/resource_acquisition/) | Resource files overview |
| Data Share | [Data Share](https://help.synology.com/developer-guide/resource_acquisition/data_share.html) | Shared folder permissions |
| Port Config | [Port Config](https://help.synology.com/developer-guide/resource_acquisition/port_config.html) | Firewall port definitions |
| Web Service | [Web Service](https://help.synology.com/developer-guide/resource_acquisition/web_service.html) | WebStation integration |
| MariaDB | [MariaDB 10](https://help.synology.com/developer-guide/resource_acquisition/maria_db_10.html) | Database resources |
| PostgreSQL | [PostgreSQL](https://help.synology.com/developer-guide/resource_acquisition/postgre_sql.html) | PostgreSQL resources |

## DSM Integration

| Section | URL | Description |
|---------|-----|-------------|
| DSM Integration | [DSM Integration](https://help.synology.com/developer-guide/integrate_dsm/) | Overview |
| Resource Files | [Resource Files](https://help.synology.com/developer-guide/integrate_dsm/resource.html) | DSM 7 resource worker |
| Package Center | [Package Center](https://help.synology.com/developer-guide/integrate_dsm/pkgcenter.html) | Package Center integration |

## Script Environment Variables

Synology provides standard environment variables in package scripts:

| Variable | Description |
|----------|-------------|
| `SYNOPKG_PKGNAME` | Package name |
| `SYNOPKG_PKGVER` | Package version |
| `SYNOPKG_PKGDEST` | Package installation directory |
| `SYNOPKG_PKGVAR` | Package variable directory (`/var/packages/<pkg>/var/`) |
| `SYNOPKG_DSM_VERSION_MAJOR` | DSM major version (e.g., 7) |
| `SYNOPKG_DSM_VERSION_MINOR` | DSM minor version (e.g., 2) |

For the complete list, see [Script Environment Variables](https://help.synology.com/developer-guide/synology_package/scripts.html#script-environment-variables) in the official documentation.

## Source and Tools

### Official Synology Resources

| Resource | URL | Description |
|----------|-----|-------------|
| pkgscripts-ng | [GitHub](https://github.com/SynologyOpenSource/pkgscripts-ng) | Official build toolkit |
| GPL Source | [SourceForge](https://sourceforge.net/projects/dsgpl/files/) | Toolchains and kernel sources |
| Archive | [archive.synology.com](https://archive.synology.com/download/) | Old DSM releases and toolchains |

### SynoCommunity Resources

| Resource | URL | Description |
|----------|-----|-------------|
| spksrc Repository | [GitHub](https://github.com/SynoCommunity/spksrc) | Main build framework |
| spkrepo | [GitHub](https://github.com/SynoCommunity/spkrepo) | Package repository server |
| Package Feed | [packages.synocommunity.com](https://packages.synocommunity.com) | Official package repository |

## DSM Knowledge Base

General DSM administration and troubleshooting:

| Topic | URL |
|-------|-----|
| ACL Management | [KB Article](https://www.synology.com/en-global/knowledgebase/DSM/tutorial/File_Sharing/How_to_manage_ACL_settings_on_your_Synology_NAS) |
| Package Center | [KB Article](https://www.synology.com/en-global/knowledgebase/DSM/help/DSM/PkgManApp/PackageCenter_desc) |
| SSH Access | [KB Article](https://www.synology.com/en-global/knowledgebase/DSM/tutorial/General_Setup/How_to_login_to_DSM_with_root_permission_via_SSH_Telnet) |

## DSM Version Reference

### DSM 7.x

| Version | Status | Key Changes |
|---------|--------|-------------|
| DSM 7.2 | Current | Stricter service management, new resource types |
| DSM 7.1 | LTS | Primary target for most packages |
| DSM 7.0 | EOL | Initial DSM 7 release |

### DSM 6.x

| Version | Status | Key Changes |
|---------|--------|-------------|
| DSM 6.2.4 | LTS | Primary target for DSM 6 packages |
| DSM 6.2 | Supported | Last major DSM 6 release |
| DSM 6.1 | EOL | Deprecated |
| DSM 6.0 | EOL | Deprecated |

### Key DSM 7 vs DSM 6 Differences

| Feature | DSM 6 | DSM 7 |
|---------|-------|-------|
| Service User | Configurable | `sc-<pkgname>` (fixed) |
| Package Trust | Configurable | Synology-signed only |
| Resource Files | Basic | Full support |
| Web Service | conf/resource | DSM 7.0+ only |
| Shared Folder Permissions | Groups | System internal users |

See [DSM 7 Migration Guide](../developer-guide/migration/dsm7.md) for migration details.
