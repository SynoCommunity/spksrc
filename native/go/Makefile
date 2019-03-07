PKG_NAME = go
PKG_VERS = 1.12
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)$(PKG_VERS).src.$(PKG_EXT)
PKG_DIST_SITE = https://storage.googleapis.com/golang
PKG_DIR = $(PKG_NAME)

DEPENDS = native/go-1.4

HOMEPAGE   = http://golang.org/
COMMENT    = Go is an open source programming language that makes it easy to build simple, reliable, and efficient software.
LICENSE    =

CONFIGURE_TARGET = nop
COMPILE_TARGET = myComp
INSTALL_TARGET = nop

GOROOT_BOOTSTRAP14=$(WORK_DIR)/../../go-1.4/work-native/go

include ../../mk/spksrc.native-cc.mk

myComp:
	@$(MSG) "Building Go for host system"
	# GO111MODULE disable go.mod per https://github.com/golang/go/issues/26996
	cd $(WORK_DIR)/$(PKG_NAME)/src && GO111MODULE=off GOARCH="" GOROOT_BOOTSTRAP=$(GOROOT_BOOTSTRAP14) ./make.bash
