# Ente for Synology NAS

End-to-end encrypted platform for photos.
Self-hosted alternative to Google Photos with privacy-first design.

## Prerequisites

**Important:** This package requires manual setup of external dependencies.

### 1. PostgreSQL Database Setup
Ente requires PostgreSQL. Use the built-in PostgreSQL on your Synology NAS:

```bash
# SSH into your Synology NAS as admin
sudo -u postgres createdb sc-ente
sudo -u postgres psql -c "GRANT ALL ON DATABASE \"sc-ente\" TO \"sc-ente\";"
```

**Note:** This creates a database named `sc-ente` that matches the service user name, using PostgreSQL's secure peer authentication (no passwords required).

### 2. MinIO Storage Setup
1. MinIO will be automatically installed as a dependency
2. Access MinIO web interface at `http://your-nas-ip:9001`
3. Login with default credentials: username=`minioadmin`, password=`minioadmin`
4. **Create a new bucket named `ente-data`** (this must be done manually)
5. Set the bucket policy to allow public read access if needed

## Installation

1. **Set up PostgreSQL first** (see prerequisites above)
2. **Set up MinIO bucket** (see prerequisites above)
3. Install ente package through Package Center
4. **The web interface will be available on port 8097**
5. **Security keys are automatically generated** during installation
6. **Edit database credentials** at `/var/packages/ente/var/work/credentials.yaml`

## Post-Installation Configuration

### 1. Database Configuration

Database connection is automatically configured.

- Uses PostgreSQL Unix socket authentication
- No manual credentials.yaml editing required
- Database: `sc-ente`, User: `sc-ente` (matches service user)
- No passwords needed (secure peer authentication)

### 2. Security Keys

Security keys are automatically generated during installation!

- Fresh cryptographic keys are created for each installation
- No manual key generation needed
- Keys are securely stored in `/var/packages/ente/var/museum.yaml`

### 3. Database Schema Setup

The museum binary will automatically create the necessary database schema on first run when you start the service.

## Usage

1. **Start the service** in Package Center after configuration
2. **Access the web interface** at: `http://your-nas-ip:8097`
3. **Create an account** and start uploading photos
4. **Use official Ente mobile apps** and configure them to connect to your NAS

## Important Security Notes

- **Security keys are automatically generated** for each installation
- **Database uses secure Unix socket authentication** (no passwords)
- **Consider enabling HTTPS** for production deployments
- **Regularly backup** your PostgreSQL database and MinIO storage
- **Keep the package updated** for security fixes

## Troubleshooting

- **Check service logs** at `/var/packages/ente/var/data/museum.log`
- **Verify database connectivity** using the credentials in credentials.yaml
- **Ensure MinIO service is running** and accessible
- **Verify storage bucket** `ente-data` exists in MinIO interface
- **Check firewall settings** for port 8097
- **Ensure PostgreSQL database** exists and user has proper permissions

## Support

- Official Ente documentation: https://help.ente.io/self-hosting
- SynoCommunity forums: https://github.com/SynoCommunity/spksrc/discussions
- Ente GitHub: https://github.com/ente-io/ente
