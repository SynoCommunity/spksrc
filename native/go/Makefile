PKG_NAME = go
PKG_VERS = 1.6.2
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

GOROOT_BOOTSTRAP=$(WORK_DIR)/../../go-1.4/work-native/go

include ../../mk/spksrc.native-cc.mk

myComp:
	@$(MSG) "Building Go"
	cd $(WORK_DIR)/$(PKG_NAME)/src && export GOARCH=amd64 && GOROOT_BOOTSTRAP=$(GOROOT_BOOTSTRAP) ./make.bash
	@$(MSG) "Building Go for arm"
	cd $(WORK_DIR)/$(PKG_NAME)/src && export GOARCH=arm && export GOARM=5 && GOROOT_BOOTSTRAP=$(GOROOT_BOOTSTRAP) ./make.bash --no-clean
	@$(MSG) "Building Go for 386"
	cd $(WORK_DIR)/$(PKG_NAME)/src && export GOARCH=386 && GOROOT_BOOTSTRAP=$(GOROOT_BOOTSTRAP) ./make.bash --no-clean
