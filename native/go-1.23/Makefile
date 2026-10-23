PKG_NAME = go
PKG_VERS = 1.23.12
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)$(PKG_VERS).linux-amd64.$(PKG_EXT)
PKG_DIST_SITE = https://go.dev/dl
PKG_DIR = $(PKG_NAME)

# Go 1.24 and later need Linux 3.2: env-go.mk takes this one for older kernels (88f6281),
# for the packages whose go.mod asks for no more than 1.23.

HOMEPAGE = https://golang.org/
COMMENT  = Go is an open source programming language that makes it easy to build simple, reliable, and efficient software.
LICENSE  = BSD-style

# extract only to $(WORK_DIR)
INSTALL_TARGET = nop

include ../../mk/spksrc.native-install.mk
