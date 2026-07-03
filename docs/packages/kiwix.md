# Kiwix

[Kiwix](https://www.kiwix.org/) is an offline reader for online content like Wikipedia, Project Gutenberg, or TED Talks.

## Quick Start

### 1. Installation

Installation with default settings will create a shared folder `/volume1/kiwix-share` and create an empty library file `/volume1/kiwix-share/library.xml`. After successful installation, the state of kiwix is "Running".

### 2. Open the Kiwix Page

Open your web browser and go to `http://<ip-of-your-diskstation>:8092`. It will show an empty kiwix page.

### 3. Download a ZIM File

Download content from the kiwix wiki page with [Content in all languages](https://wiki.kiwix.org/wiki/Content_in_all_languages) in your preferred language.

For example, download the Gutenberg project in German and save the file `gutenberg_de_all_2021-10.zim` in the `kiwix-share` folder. You can use direct download or BitTorrent protocol.

### 4. Add the ZIM File to the Library

Login into your diskstation with SSH and execute:

```bash
kiwix-manage /volume1/kiwix-share/library.xml add /volume1/kiwix-share/gutenberg_de_all_2021-10.zim
```

### 5. Access the Content

Refresh the page from step 2 and navigate into Project Gutenberg.

## Tips

### Without SSH Access

If you don't want to use SSH, create a script file with the command(s) you want to execute and make sure the file has unix line endings.

`job.sh`:
```bash
#!/bin/bash
kiwix-manage /volume1/kiwix-share/library.xml add /volume1/kiwix-share/gutenberg_de_all_2021-10.zim &> /volume1/kiwix-share/job.out.txt
```

To execute the script:

1. Open **Control Panel** > **Task Scheduler**
2. Create a **Scheduled Task** with a **User-defined script**
3. For manual execution, select a Schedule running on a date in the past
4. In **Task Settings** > **Run command** define: `bash /volume1/kiwix-share/job.sh`
5. Run the task. Under **Action** > **View Result** you can see the status. Normal (0) means success.

### Show Library Details

```bash
kiwix-manage /volume1/kiwix-share/library.xml show &> /volume1/kiwix-share/job.out.txt
```
