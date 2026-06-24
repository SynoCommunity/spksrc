# Go Packages

Go packages leverage Go's cross-compilation for building single-binary applications.

## Basic Setup

```makefile
PKG_NAME = myapp
PKG_VERS = 1.2.3
PKG_DIST_SITE = https://github.com/example/$(PKG_NAME)/archive

GO_SRC_DIR = $(WORK_DIR)/$(PKG_DIR)
GO_BUILD_ARGS = -o myapp ./cmd/myapp

include ../../mk/spksrc.cross-go.mk
```

## CGO Configuration

```makefile
CGO_ENABLED = 1
DEPENDS = cross/sqlite
CGO_CFLAGS = -I$(STAGING_INSTALL_PREFIX)/include
CGO_LDFLAGS = -L$(STAGING_INSTALL_PREFIX)/lib
```

## Build Flags

```makefile
# Strip debug info
GO_LDFLAGS = -s -w

# Set version at build time
GO_LDFLAGS += -X main.Version=$(PKG_VERS)
```

## Architecture Mapping

| spksrc Arch | GOOS | GOARCH |
|-------------|------|--------|
| x64 | linux | amd64 |
| aarch64 | linux | arm64 |
| armv7 | linux | arm |

## Example

See [syncthing](https://github.com/SynoCommunity/spksrc/tree/master/spk/syncthing) for a Go package.
