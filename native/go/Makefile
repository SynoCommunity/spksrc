PKG_NAME = go
PKG_VERS = 1.18.6
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)$(PKG_VERS).linux-amd64.$(PKG_EXT)
PKG_DIST_SITE = https://go.dev/dl
PKG_DIR = $(PKG_NAME)

HOMEPAGE = https://golang.org/
COMMENT  = Go is an open source programming language that makes it easy to build simple, reliable, and efficient software.
LICENSE  = BSD-style

# extract only to $(WORK_DIR)
INSTALL_TARGET = nop

include ../../mk/spksrc.native-install.mk
