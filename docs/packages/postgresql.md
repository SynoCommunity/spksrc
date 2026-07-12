# PostgreSQL

[PostgreSQL](https://www.postgresql.org/) is a powerful, open source object-relational database system with over 30 years of active development. This package includes PostGIS spatial database extension for DSM 7+ and pgvector extension for vector similarity search.

## Installation

1. Install the PostgreSQL package from SynoCommunity repository
2. During installation, create an administrator account with username and password
3. The default port is **5433** (to avoid conflict with Synology's built-in PostgreSQL on 5432)

## Connecting to the Server

**Important:** You must use the full path `/usr/local/bin/` to run these commands, otherwise DSM's built-in PostgreSQL (on port 5432) will be used instead.

### Via TCP/IP (over network)

```bash
/usr/local/bin/psql -h localhost -p 5433 -U pgadmin -d postgres
```

### Via Unix Socket (local)

```bash
/usr/local/bin/psql -h /var/packages/postgresql/var -p 5433 -U pgadmin -d postgres
```

## Available Command-Line Tools

| Command | Description |
|---------|-------------|
| `psql` | PostgreSQL interactive terminal |
| `pg_dump` | Dump a database to a file |
| `pg_dumpall` | Dump all databases to a file |
| `pg_restore` | Restore a database from a dump file |
| `createdb` | Create a new database |
| `dropdb` | Remove a database |
| `createuser` | Create a new user role |
| `dropuser` | Remove a user role |
| `pg_isready` | Check if server is running |
| `vacuumdb` | Vacuum a database (reclaim storage) |
| `reindexdb` | Reindex a database |
| `clusterdb` | Cluster a database |

## Creating and Managing Users

### Create a New User

```bash
/usr/local/bin/createuser -h localhost -p 5433 -U pgadmin -P newusername
```

### Create a Superuser

```bash
/usr/local/bin/createuser -h localhost -p 5433 -U pgadmin -Ps newusername
```

### Remove a User

```bash
/usr/local/bin/dropuser -h localhost -p 5433 -U pgadmin username
```

### Using psql

```bash
/usr/local/bin/psql -h localhost -p 5433 -U pgadmin -d postgres
```

Then in psql:

```sql
-- Create a new user
CREATE USER newuser WITH PASSWORD 'password';

-- Create a superuser
CREATE USER newadmin WITH PASSWORD 'password' SUPERUSER;

-- Drop a user
DROP USER username;
```

## Creating and Managing Databases

### Create a Database

```bash
/usr/local/bin/createdb -h localhost -p 5433 -U pgadmin mydatabase
```

### Drop (Delete) a Database

```bash
/usr/local/bin/dropdb -h localhost -p 5433 -U pgadmin mydatabase
```

### Using psql

```sql
-- Create a database
CREATE DATABASE mydatabase;

-- Create a database owned by a specific user
CREATE DATABASE mydatabase OWNER newuser;

-- Drop a database
DROP DATABASE mydatabase;
```

## Available Extensions

The following extensions are built into the package and can be enabled on any database:

### Contrib Extensions

- **unaccent** — text search dictionary that removes accents
- **cube** — multi-dimensional cube data type
- **earthdistance** — calculates great-circle distances
- **pg_trgm** — trigram matching for fuzzy text search
- **uuid-ossp** — UUID generation functions

### pgvector (DSM 7+ only)

[pgvector](https://github.com/pgvector/pgvector) provides vector similarity search for PostgreSQL, enabling semantic search and AI/ML embeddings storage.

```sql
CREATE EXTENSION IF NOT EXISTS vector;

-- Create a vector column with 3 dimensions
CREATE TABLE items (id bigserial PRIMARY KEY, embedding vector(3));

-- Get nearest neighbors by L2 distance
SELECT * FROM items ORDER BY embedding <-> '[3,1,2]' LIMIT 5;
```

### PostGIS (DSM 7+ only)

PostGIS is automatically included on DSM 7+ builds.

```sql
CREATE EXTENSION IF NOT EXISTS postgis;
```

## Scheduled Maintenance Tasks

You can set up DSM scheduled tasks to run maintenance commands.

### Vacuum Command

```bash
/usr/local/bin/vacuumdb -h localhost -p 5433 -U pgadmin -d mydatabase
```

### Reindex Command

```bash
/usr/local/bin/reindexdb -h localhost -p 5433 -U pgadmin -d mydatabase
```

### Backup Command

```bash
/usr/local/bin/pg_dump -h localhost -p 5433 -U pgadmin -Fc mydatabase -f /volume1/backup/mydatabase.dump
```

## Security

- Default authentication is **scram-sha-256** (stronger than md5)
- Local connections use peer authentication for the service user
- The wizard enforces password complexity requirements

## Troubleshooting

### Cannot connect to server

Ensure you're using port **5433** (not the default 5432):

```bash
/usr/local/bin/psql -h localhost -p 5433 -U pgadmin -d postgres
```

### Check if PostgreSQL is running

```bash
/usr/local/bin/pg_isready -h localhost -p 5433
```

### View PostgreSQL logs

Log file is available at `/var/packages/postgresql/var/postgresql.log`
