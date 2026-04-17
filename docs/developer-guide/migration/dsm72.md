# DSM 7.2 Features

New features in DSM 7.2+.

## PHP 8.x Support

| Backend | PHP Version |
|---------|-------------|
| 10 | PHP 8.2 |
| 11 | PHP 8.3 |
| 12 | PHP 8.4 |

## Version-Specific Resources

Use separate resource files:
```
src/conf/resource       # DSM 7.0-7.1
src/conf_72/resource    # DSM 7.2+
```

## Conditional Configuration

```makefile
include ../../mk/spksrc.common.mk

ifeq ($(call version_ge,$(TCVERSION),7.2),1)
PHP_BACKEND = 11
else
PHP_BACKEND = 8
endif
```
