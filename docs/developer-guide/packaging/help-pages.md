# Help Pages

Packages can ship an in-DSM help system that guides the user through the
package step by step: installation, configuration, and basic usage. Help pages
are plain HTML files rendered inside DSM (under the package's "Help" link),
with the same styling as DSM's own help.

## Overview

- Help files are HTML pages placed under `spk/<package>/src/app/help/`.
- There is one main page (`index.html`) plus optional sub-pages, one per topic
  (e.g. *Installation*, *Configuration*, *Usage*, *Service feature*).
- Each language gets its own subdirectory (e.g. `enu/` for English, `fre/` for
  French).
- The package must set `DSM_UI_DIR = app` so the `app/` tree (including
  `help/`) is packaged and served by DSM.

`debian-chroot` is the reference package: it ships a main page with
*Installation*, *Configuration* and *Usage* topics plus a page explaining the
*Service feature*.

## File Structure

```
spk/<package>/src/app/help/
├── enu/
│   ├── index.html      # Main help page
│   └── services.html   # Optional sub-page
├── fre/
│   ├── index.html
│   └── services.html
└── ...
```

## Example

```html
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <title>Package Name</title>
        <link href="/webman/help/help.css" rel="stylesheet" type="text/css" />
    </head>
    <body>
        <h1>Package Name</h1>
        <h3>Installation</h3>
        <p>Once installed via Package Center, ...</p>
        <h3>Usage</h3>
        <p>Connect via SSH (root) and run: <b>/var/packages/package/scripts/start-stop-status</b>.</p>
    </body>
</html>
```

Use the same HTML markup as the `debian-chroot` help files. Synology applies
the standard `help.css` stylesheet so the pages match DSM's look and feel.

## Linking Help

Set `HELPURL` in the SPK Makefile to an external fallback documentation URL.
When set, it is written to the package `INFO` file as `helpurl` and used by
Package Center:

```makefile
HELPURL = https://docs.synocommunity.com/packages/<package>/
```

## Localization

Create a subdirectory per language, mirroring the wizard translation suffixes:

| Suffix | Language |
|--------|----------|
| `enu` | English |
| `fre` | French |
| `ger` | German |
| `chs` | Chinese (Simplified) |
| ... | (same set as wizard translations) |

Each language directory contains its own set of HTML pages.

## Best Practices

1. Cover the main topics: **Installation**, **Configuration**, **Basic Usage**
2. Keep a single main page plus focused sub-pages
3. Provide at least English (`enu/`) HTML
4. Reference the package data directory (`/var/packages/<package>/var/`) where
   configuration lives
5. Match the `debian-chroot` HTML structure and use `help.css` classes

## See Also

- [Wizards](wizards.md) - Installation/upgrade wizard pages
- [Resource Files](resource-files.md) - Other files packaged with the SPK
