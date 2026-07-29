# Duplicity

Duplicity backs directories by producing encrypted tar-format volumes and uploading them to a remote or local file server.

Because duplicity uses librsync, the incremental archives are space efficient and only record the parts of files that have changed since the last backup. Because duplicity uses GnuPG to encrypt and/or sign these archives, they will be safe from spying and/or modification by the server.

The duplicity package also includes the rdiffdir utility. Rdiffdir is an extension of librsync's rdiff to directories—it can be used to produce signatures and deltas of directories as well as regular files. These signatures and deltas are in GNU tar format.

## Installation Notes

After installing the duplicity package, you need to do some steps before launching your first backup:

### GPG Configuration

You will need to pass `--gpg-binary=/usr/local/gnupg/bin/gpg2` to the duplicity command, as GPG is already available in DSM but at an older version.

You may also need to create a file `gpg-agent.conf` in `/root/.gnupg` containing only the line:

```
allow-loopback-pinentry
```

### Storage Directories

You may pass `--archive-dir=/volume1/homes/whatever/` and `--tempdir=/volume1/homes/whatever/` to duplicity's command, because these directories will grow up and space is scarce on `/`.
