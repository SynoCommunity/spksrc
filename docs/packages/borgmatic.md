# Borgmatic

Borgmatic is a simple, configuration-driven backup software for servers and workstations using [BorgBackup](https://www.borgbackup.org/).

## Installation

### Step 1 - Install the Borg Community Package

1. Log into the web interface
2. Go to **Package Center**
3. Go to the **Community** tab
4. Search for `Borg`
5. Click Install
6. Click Agree when asked about 3rd party software

### Step 2 - Create Hidden Shared Folder for Borg Config Files

1. Open the DSM **Control Panel** and choose **Shared Folder**
2. Click Create and enter a name and description. Ensure the following:
    - [x] Hide this shared folder in "My Network Places"
    - [x] Hide sub-folders and files from users without permissions
    - [ ] Enable Recycle Bin

### Step 3 - Create your Borgmatic Config

In the new folder created in Step 2, create your `borgmatic.yml` config file.

A sample configuration can be found on the official [borgmatic website](https://torsion.org/borgmatic/).

To create and edit this file in-browser, you can add the **Text Editor** package by Synology in Package Center.

You can also generate a borgmatic configuration file via SSH:

```bash
/usr/local/bin/borgmatic config generate -d /volume1/Backup/borgmatic.yml
```

### Step 4 - Upload Private Keys (Optional)

If you have any private keys for uploading files to remote repos, they can be placed in the folder created above.

### Step 5 - Add the Backup Task

1. In DSM **Control Panel**, go to **Task Scheduler**
2. Click **Create > Scheduled Task > User-defined script**
3. On the **General** Tab, name the job and ensure the **User** is set to **root**
4. On the **Schedule** Tab, set whatever works for your setup
5. On the **Task Settings** tab, add your borgmatic command:

```bash
/usr/local/bin/borgmatic --config /volume1/Backup/borgmatic.yml
```

6. Click **OK**

### Step 6 - Manually Run the Job

1. In DSM **Control Panel**, go to **Task Scheduler**
2. Click the task you created and then click **Run**, then **OK**

There will not be any visual output. Add `--log-file /path/to/file.log --log-file-verbosity 2` to see output in a log file.

## Tips

### Find New Config Options

To see current config options after an update of borgmatic:

```bash
/usr/local/bin/borgmatic config generate -d /volume1/Backup/borgmatic-config-new.yml
```

### BTRFS Snapshots

To create btrfs snapshots you need the `findmnt` tool. Install the `synocli-misc` package (SynoCli misc. Tools) to have `findmnt` available.

Note that btrfs support on Synology is limited - the btrfs function in borgmatic is currently for subvolumes, so it is somewhat limited on Synology if you want to back up shared folders.
