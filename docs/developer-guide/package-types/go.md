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

## Go Version and Older Kernels

Go 1.24 and later need Linux 3.2: built with them, a server cannot accept
connections on the 2.6.32 kernel of ARMv5 (88f6281). `MIN_GO_VERSION` defaults to
1.24, so a go package is not built for kernels older than 3.2.

A package whose `go.mod` still asks for go 1.23 or older can be built for them
too: `MIN_GO_VERSION = 1.23` gives those kernels `native/go-1.23`.

```makefile
# Builds with go 1.23, so for kernels older than 3.2 (ARMv5) too
MIN_GO_VERSION = 1.23
```

Elsewhere the build starts from `native/go`, and go fetches the version `go.mod`
asks for (`GOTOOLCHAIN` left to its default). With go 1.23 the build is locked to
it (`GOTOOLCHAIN=local`), as a newer go would not run on those kernels: when
`go.mod` asks for more, the build warns which `MIN_GO_VERSION` to remove before go
fails. A `go.mod` asking for 1.23 or older, in a package without
`MIN_GO_VERSION = 1.23`, gets a note that it could be built for older kernels.

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
