PKG_NAME = go
PKG_VERS = 1.15.6
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)$(PKG_VERS).src.$(PKG_EXT)
PKG_DIST_SITE = https://storage.googleapis.com/golang
PKG_DIR = $(PKG_NAME)

DEPENDS = native/go-1.4

HOMEPAGE = https://golang.org/
COMMENT  = Go is an open source programming language that makes it easy to build simple, reliable, and efficient software.
LICENSE  = BSD-style

CONFIGURE_TARGET = nop
COMPILE_TARGET = go_native_compile
INSTALL_TARGET = nop

GOROOT_BOOTSTRAP14=$(WORK_DIR)/../../go-1.4/work-native/go

include ../../mk/spksrc.native-cc.mk

.PHONY: go_native_compile
go_native_compile:
	@$(MSG) "Building Go for host system"
	# GO111MODULE disable go.mod per https://github.com/golang/go/issues/26996
	cd $(WORK_DIR)/$(PKG_NAME)/src && CC=gcc CXX=g++ GOOS="linux" GOHOSTARCH="amd64" GOARCH="amd64" GO111MODULE=off GOROOT_BOOTSTRAP=$(GOROOT_BOOTSTRAP14) ./make.bash
