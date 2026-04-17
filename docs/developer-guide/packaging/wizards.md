# Installation Wizards

Wizards provide an optional user interface during package installation to collect configuration settings. All wizard files are optional and only needed if input is required from the user.

## Overview

spksrc uses Mustache templates for wizard definitions:

- **install_uifile** - Shown during installation
- **upgrade_uifile** - Shown during upgrade (optional)
- **uninstall_uifile** - Shown during uninstall (optional)

## Naming Conventions

There are two types of variables in wizard templates:

1. **Mustache substitutions** - Use `UPPERCASE_WITH_UNDERSCORES` for text that gets replaced during build. These are defined in the `.yml` files and substituted into the template.

2. **Input keys** - Use lowercase `wizard_` prefix for values that get passed to `service-setup.sh`. These are the actual form field keys that DSM collects from the user.

Example:
```json
{
    "step_title": "{{{CONFIGURATION_STEP_TITLE}}}",   // Mustache - replaced at build
    "subitems": [{
        "key": "wizard_data_share",                   // Input key - passed to scripts
        "desc": "{{{SHARE_NAME_LABEL}}}"             // Mustache - replaced at build
    }]
}
```

## File Structure

```
spk/<package>/src/wizard_templates/
├── install_uifile           # Mustache template (JSON)
├── install_uifile.yml       # String substitutions
├── install_uifile_fre.yml   # French translations
├── install_uifile_ger.yml   # German translations
└── ...                      # Other languages
```

## Basic Template

### install_uifile

```json
[{
    "step_title": "{{{CONFIGURATION_TITLE}}}",
    "items": [{
        "type": "textfield",
        "desc": "{{{SHARE_NAME_DESC}}}",
        "subitems": [{
            "key": "wizard_data_share",
            "desc": "{{{SHARE_NAME_LABEL}}}",
            "defaultValue": "mypackage",
            "validator": {
                "allowBlank": false,
                "regex": {
                    "expr": "/^[a-zA-Z][a-zA-Z0-9_-]*$/",
                    "errorText": "{{{SHARE_NAME_INVALID}}}"
                }
            }
        }]
    }]
}]
```

### install_uifile.yml

```yaml
CONFIGURATION_TITLE: "Configuration"
SHARE_NAME_DESC: "Enter the name of the shared folder to use."
SHARE_NAME_LABEL: "Shared folder name"
SHARE_NAME_INVALID: "Invalid folder name. Use only letters, numbers, hyphens, and underscores."
```

## Input Types

### Text Field

```json
{
    "type": "textfield",
    "desc": "Enter a value",
    "subitems": [{
        "key": "wizard_variable_name",
        "desc": "Label",
        "defaultValue": "default"
    }]
}
```

### Password Field

```json
{
    "type": "password",
    "desc": "Enter password",
    "subitems": [{
        "key": "wizard_password",
        "desc": "Password"
    }]
}
```

### Checkbox

```json
{
    "type": "singleselect",
    "desc": "Enable feature?",
    "subitems": [{
        "key": "wizard_enable_feature",
        "desc": "Enable feature",
        "defaultValue": true
    }]
}
```

### Dropdown

```json
{
    "type": "combobox",
    "desc": "Select option",
    "subitems": [{
        "key": "wizard_selection",
        "desc": "Option",
        "defaultValue": "option1",
        "editable": false,
        "mode": "local",
        "displayField": "display",
        "valueField": "value",
        "store": {
            "xtype": "arraystore",
            "fields": ["display", "value"],
            "data": [
                ["Option 1", "option1"],
                ["Option 2", "option2"]
            ]
        }
    }]
}
```

## Validation

### Required Field

```json
"validator": {
    "allowBlank": false
}
```

### Regex Validation

```json
"validator": {
    "allowBlank": false,
    "regex": {
        "expr": "/^[a-z0-9_]+$/",
        "errorText": "Invalid format"
    }
}
```

### Minimum Length

```json
"validator": {
    "minLength": 8
}
```

## Multi-Step Wizards

```json
[
    {
        "step_title": "Step 1: Basic Settings",
        "items": [...]
    },
    {
        "step_title": "Step 2: Advanced Settings",
        "items": [...]
    }
]
```

## Accessing Wizard Values

Wizard values are available in service scripts:

```bash
# In service-setup.sh
service_postinst() {
    echo "User selected: ${wizard_data_share}"
}
```

### Shared Folder Integration

For shared folder selection, use `SERVICE_WIZARD_SHARENAME` in Makefile:

```makefile
SERVICE_WIZARD_SHARENAME = wizard_data_share
```

This provides `${SHARE_PATH}` in service scripts with the full path to the selected share.

## Localization

### Language Files

Create `<name>_<lang>.yml` for each language:

| Suffix | Language |
|--------|----------|
| `_chs` | Chinese (Simplified) |
| `_cht` | Chinese (Traditional) |
| `_csy` | Czech |
| `_dan` | Danish |
| `_fre` | French |
| `_ger` | German |
| `_hun` | Hungarian |
| `_ita` | Italian |
| `_jpn` | Japanese |
| `_krn` | Korean |
| `_nld` | Dutch |
| `_nor` | Norwegian |
| `_plk` | Polish |
| `_ptb` | Portuguese (Brazil) |
| `_ptg` | Portuguese |
| `_rus` | Russian |
| `_spn` | Spanish |
| `_sve` | Swedish |
| `_trk` | Turkish |

### Example Translation

**install_uifile_fre.yml:**

```yaml
CONFIGURATION_TITLE: "Configuration"
SHARE_NAME_DESC: "Entrez le nom du dossier partagé à utiliser."
SHARE_NAME_LABEL: "Nom du dossier partagé"
SHARE_NAME_INVALID: "Nom de dossier invalide."
```

## Best Practices

1. **Keep it simple** - Only ask for essential information
2. **Provide defaults** - Use sensible `defaultValue`
3. **Validate input** - Prevent invalid configurations
4. **Add notes** - Explain that shares should be created beforehand for specific volumes
5. **Translate** - Provide at least English strings
6. **Test thoroughly** - Test on actual DSM installations

## Example: Share Name Wizard

A common pattern for packages needing a shared folder:

**install_uifile:**

```json
[{
    "step_title": "{{{DATA_STORAGE_TITLE}}}",
    "items": [{
        "desc": "{{{SHARE_NOTE}}}"
    }, {
        "type": "textfield",
        "desc": "{{{SHARE_DESC}}}",
        "subitems": [{
            "key": "wizard_data_share",
            "desc": "{{{SHARE_LABEL}}}",
            "defaultValue": "mypackage",
            "validator": {
                "allowBlank": false,
                "regex": {
                    "expr": "/^[a-zA-Z][a-zA-Z0-9_-]*$/",
                    "errorText": "{{{SHARE_INVALID}}}"
                }
            }
        }]
    }]
}]
```

**install_uifile.yml:**

```yaml
DATA_STORAGE_TITLE: "Data Storage"
SHARE_NOTE: "Note: If you want to use a specific volume, create the shared folder before installing this package."
SHARE_DESC: "Enter the name of the shared folder where data will be stored."
SHARE_LABEL: "Shared folder"
SHARE_INVALID: "Invalid folder name. Use letters, numbers, hyphens, and underscores only."
```
