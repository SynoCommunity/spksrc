# PHP 8.4.15 Extensions Documentation

**Package**: php84-8.4.15
**Architecture**: Synology DSM 7.2+ (geminilake)
**Total Extensions**: 100

## Overview

This SPK package includes 100 PHP extensions organized into 15 categories. Extensions can be enabled/disabled via:
- **Installation wizard**: Select profiles or individual extensions during installation
- **Extension Manager**: DSM application accessible via Package Center > Open

---

## Categories

| Category | Name | Extensions | Description |
|----------|------|------------|-------------|
| core | Core | 7 | Essential PHP extensions |
| database | Base de données | 13 | Database connectivity |
| cache | Cache | 3 | Caching and serialization |
| network | Réseau | 7 | Network protocols |
| text | Texte | 4 | Encoding and i18n |
| xml | XML | 6 | XML parsing |
| compression | Compression | 6 | Data compression |
| image | Image | 2 | Image processing |
| crypto | Crypto | 4 | Cryptography |
| math | Math | 3 | Mathematical operations |
| system | Système | 9 | System interaction |
| debug | Debug | 6 | Development tools |
| data | Données | 9 | Data formats |
| async | Async | 3 | Asynchronous programming |
| misc | Autres | 18 | Miscellaneous |

---

## Extensions by Category

### Core (7 extensions)

Essential extensions enabled by default for most PHP applications.

| Extension | File | Default | Description |
|-----------|------|---------|-------------|
| **OPcache** | opcache.so | Yes | Bytecode cache for improved performance |
| **Session** | session.so | Yes | Session handling support |
| **Filter** | filter.so | Yes | Data filtering and validation |
| **Fileinfo** | fileinfo.so | Yes | File type detection |
| **Tokenizer** | tokenizer.so | Yes | PHP token parsing |
| **Phar** | phar.so | Yes | PHP Archive support |
| **Ctype** | ctype.so | Yes | Character type checking |

### Database (13 extensions)

Database connectivity and manipulation.

| Extension | File | Default | Dependencies | Description |
|-----------|------|---------|--------------|-------------|
| **PDO** | pdo.so | Yes | - | PHP Data Objects base |
| **PDO MySQL** | pdo_mysql.so | Yes | pdo, mysqlnd | MySQL via PDO |
| **MySQLi** | mysqli.so | Yes | mysqlnd | MySQL improved |
| **MySQLnd** | mysqlnd.so | Yes | - | MySQL native driver |
| **PDO SQLite** | pdo_sqlite.so | Yes | pdo | SQLite via PDO |
| **SQLite3** | sqlite3.so | Yes | - | SQLite3 support |
| **PDO ODBC** | pdo_odbc.so | No | pdo | ODBC via PDO |
| **ODBC** | odbc.so | No | - | ODBC support |
| **LDAP** | ldap.so | No | - | LDAP directory access |
| **DBA** | dba.so | No | - | Database abstraction |
| **Redis** | redis.so | No | igbinary | Redis client |
| **Memcached** | memcached.so | No | igbinary, msgpack | Memcached client |
| **MongoDB** | mongodb.so | No | - | MongoDB driver |

### Cache (3 extensions)

Caching and serialization for improved performance.

| Extension | File | Default | Dependencies | Description |
|-----------|------|---------|--------------|-------------|
| **APCu** | apcu.so | No | - | User-land data cache |
| **Igbinary** | igbinary.so | No | - | Binary serialization |
| **MsgPack** | msgpack.so | No | session | MessagePack serialization |

### Network (7 extensions)

Network protocols and connectivity.

| Extension | File | Default | Description |
|-----------|------|---------|-------------|
| **cURL** | curl.so | Yes | URL transfer library |
| **OpenSSL** | openssl.so | Yes | SSL/TLS cryptography |
| **Sockets** | sockets.so | Yes | Low-level socket interface |
| **FTP** | ftp.so | No | FTP protocol support |
| **SSH2** | ssh2.so | No | SSH2 protocol support |
| **SOAP** | soap.so | No | SOAP web services |
| **SNMP** | snmp.so | No | SNMP protocol support |

### Text (4 extensions)

Encoding, internationalization and text processing.

| Extension | File | Default | Description |
|-----------|------|---------|-------------|
| **Mbstring** | mbstring.so | Yes | Multibyte string handling |
| **Iconv** | iconv.so | Yes | Character set conversion |
| **Intl** | intl.so | Yes | Internationalization (ICU) |
| **Gettext** | gettext.so | No | GNU gettext localization |

### XML (6 extensions)

XML parsing and manipulation.

| Extension | File | Default | Dependencies | Description |
|-----------|------|---------|--------------|-------------|
| **XML** | xml.so | Yes | - | XML parser |
| **DOM** | dom.so | Yes | - | Document Object Model |
| **SimpleXML** | simplexml.so | Yes | - | Simple XML parsing |
| **XMLReader** | xmlreader.so | Yes | - | XML stream reader |
| **XMLWriter** | xmlwriter.so | Yes | - | XML stream writer |
| **XSL** | xsl.so | No | dom | XSL transformations |

### Compression (6 extensions)

Data compression algorithms.

| Extension | File | Default | Description |
|-----------|------|---------|-------------|
| **Zip** | zip.so | Yes | ZIP archive support |
| **Zlib** | zlib.so | Yes | Gzip compression |
| **Bzip2** | bz2.so | No | Bzip2 compression |
| **Zstd** | zstd.so | No | Zstandard compression |
| **Brotli** | brotli.so | No | Brotli compression |
| **LZF** | lzf.so | No | LZF compression |

### Image (2 extensions)

Image processing and manipulation.

| Extension | File | Default | Description |
|-----------|------|---------|-------------|
| **GD** | gd.so | Yes | Image creation and manipulation |
| **EXIF** | exif.so | Yes | EXIF metadata reading |

### Crypto (4 extensions)

Cryptography and security.

| Extension | File | Default | Description |
|-----------|------|---------|-------------|
| **Sodium** | sodium.so | Yes | Modern cryptography (libsodium) |
| **GnuPG** | gnupg.so | No | GPG encryption/signing |
| **Scrypt** | scrypt.so | No | Scrypt key derivation |
| **Base58** | base58.so | No | Base58 encoding |

### Math (3 extensions)

Mathematical operations.

| Extension | File | Default | Description |
|-----------|------|---------|-------------|
| **BCMath** | bcmath.so | Yes | Arbitrary precision math |
| **GMP** | gmp.so | No | GNU Multiple Precision |
| **FFI** | ffi.so | No | Foreign Function Interface |

### System (9 extensions)

System-level interaction.

| Extension | File | Default | Description |
|-----------|------|---------|-------------|
| **PCNTL** | pcntl.so | No | Process control |
| **POSIX** | posix.so | No | POSIX functions |
| **Readline** | readline.so | No | Interactive CLI |
| **Shmop** | shmop.so | No | Shared memory |
| **SysV Msg** | sysvmsg.so | No | System V messages |
| **SysV Sem** | sysvsem.so | No | System V semaphores |
| **SysV Shm** | sysvshm.so | No | System V shared memory |
| **Inotify** | inotify.so | No | File system monitoring |
| **UUID** | uuid.so | No | UUID generation |

### Debug (6 extensions)

Development and debugging tools.

| Extension | File | Default | Type | Description |
|-----------|------|---------|------|-------------|
| **Xdebug** | xdebug.so | No | Zend | Step debugger and profiler |
| **PCOV** | pcov.so | No | - | Code coverage driver |
| **AST** | ast.so | No | - | Abstract Syntax Tree |
| **VLD** | vld.so | No | - | Opcode dumper |
| **XHProf** | xhprof.so | No | - | Hierarchical profiler |
| **Excimer** | excimer.so | No | - | Interrupting timer |

### Data (9 extensions)

Data format handling.

| Extension | File | Default | Description |
|-----------|------|---------|-------------|
| **YAML** | yaml.so | No | YAML parsing |
| **SimdJSON** | simdjson.so | No | Fast JSON parsing |
| **Protobuf** | protobuf.so | No | Protocol Buffers |
| **DS** | ds.so | No | Data Structures |
| **CSV** | csv.so | No | CSV handling |
| **JSON Post** | json_post.so | No | JSON POST handling |
| **JSONPath** | jsonpath.so | No | JSONPath queries |
| **Var Rep** | var_representation.so | No | Variable representation |
| **PSR** | psr.so | No | PSR interfaces |

### Async (3 extensions)

Asynchronous and event-driven programming.

| Extension | File | Default | Dependencies | Description |
|-----------|------|---------|--------------|-------------|
| **Swoole** | swoole.so | No | - | Coroutine-based framework |
| **Ev** | ev.so | No | sockets | libev event loop |
| **Event** | event.so | No | sockets | libevent wrapper |

### Misc (18 extensions)

Miscellaneous extensions.

| Extension | File | Default | Dependencies | Description |
|-----------|------|---------|--------------|-------------|
| **Tidy** | tidy.so | No | - | HTML/XHTML cleanup |
| **Calendar** | calendar.so | No | - | Calendar conversions |
| **Timezonedb** | timezonedb.so | No | - | Timezone database |
| **MaxMindDB** | maxminddb.so | No | - | GeoIP2 database reader |
| **Mailparse** | mailparse.so | No | mbstring | Email parsing |
| **OAuth** | oauth.so | No | - | OAuth authentication |
| **AMQP** | amqp.so | No | - | RabbitMQ client |
| **APFD** | apfd.so | No | - | Form data parsing |
| **Bitset** | bitset.so | No | - | Bit manipulation |
| **Geospatial** | geospatial.so | No | - | Geospatial functions |
| **Parle** | parle.so | No | - | Lexer/parser |
| **Quickhash** | quickhash.so | No | - | Fast hash functions |
| **Sync** | sync.so | No | - | Synchronization primitives |
| **Trader** | trader.so | No | - | Technical analysis |
| **Translit** | translit.so | No | - | Transliteration |
| **UploadProgress** | uploadprogress.so | No | - | Upload progress tracking |
| **Xattr** | xattr.so | No | - | Extended attributes |
| **Xlswriter** | xlswriter.so | No | - | Excel writer |

---

## Extension Dependencies

Some extensions require other extensions to be enabled first.

| Extension | Required Dependencies |
|-----------|----------------------|
| PDO MySQL | pdo, mysqlnd |
| MySQLi | mysqlnd |
| PDO SQLite | pdo |
| PDO ODBC | pdo |
| Redis | igbinary |
| Memcached | igbinary, msgpack |
| MsgPack | session |
| XSL | dom |
| Ev | sockets |
| Event | sockets |
| Mailparse | mbstring |

---

## Installation Profiles

During installation, you can select from predefined profiles:

| Profile | Description | Extensions |
|---------|-------------|------------|
| **Minimal** | Basic PHP | Core only |
| **Standard** | Web applications | Core + Database + Network + XML |
| **Full** | All extensions | All 100 extensions |
| **Custom** | Choose your own | Manual selection |

---

## Configuration Files

Extensions are configured via individual `.ini` files in:
```
/var/packages/php84/etc/conf.d/
```

File naming convention:
- `00-core.ini` - Core extensions (loaded first)
- `10-database.ini` - Database extensions
- `20-cache.ini` - Cache extensions
- etc.

To manually enable/disable an extension:
```bash
# Disable an extension
mv /var/packages/php84/etc/conf.d/20-redis.ini /var/packages/php84/etc/conf.d/20-redis.ini.disabled

# Enable an extension
mv /var/packages/php84/etc/conf.d/20-redis.ini.disabled /var/packages/php84/etc/conf.d/20-redis.ini

# Restart PHP-FPM
synopkg restart php84
```

---

## Verifying Extensions

Check loaded extensions:
```bash
/var/packages/php84/target/bin/php -m
```

Check specific extension:
```bash
/var/packages/php84/target/bin/php -m | grep redis
```

Check extension configuration:
```bash
/var/packages/php84/target/bin/php -i | grep -A 20 "redis"
```

---

## Troubleshooting

### Extension not loading

1. Check if the `.so` file exists:
   ```bash
   ls -la /var/packages/php84/target/lib/php/modules/
   ```

2. Check for missing dependencies:
   ```bash
   ldd /var/packages/php84/target/lib/php/modules/redis.so
   ```

3. Check PHP error log:
   ```bash
   tail -f /var/packages/php84/var/log/php-fpm.log
   ```

### Dependency errors

If an extension fails to load due to missing dependencies:
1. Enable the required extension first
2. Restart PHP-FPM
3. Then enable the dependent extension

---

## Support

- **Package**: PHP 8.4.15 for Synology DSM 7.2+
- **Architecture**: geminilake (DS920+, DS720+, etc.)
- **Repository**: https://github.com/[your-repo]/php84
