PKG_NAME = go
PKG_VERS = 1.4.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)$(PKG_VERS).src.$(PKG_EXT)
PKG_DIST_SITE = https://storage.googleapis.com/golang
PKG_DIR = $(PKG_NAME)

DEPENDS =

HOMEPAGE   = http://golang.org/
COMMENT    = Go is an open source programming language that makes it easy to build simple, reliable, and efficient software.
LICENSE    =

CONFIGURE_TARGET = nop
COMPILE_TARGET = myComp
INSTALL_TARGET = nop

include ../../mk/spksrc.native-cc.mk

myComp:
	@$(MSG) "Building Go"
	cd $(WORK_DIR)/$(PKG_NAME)/src && ./make.bash
	@$(MSG) "Building Go for arm"
	cd $(WORK_DIR)/$(PKG_NAME)/src && export GOARCH=arm && export GOARM=5 && ./make.bash --no-clean
	@$(MSG) "Building Go amd64"
	cd $(WORK_DIR)/$(PKG_NAME)/src && export GOARCH=amd64 && ./make.bash --no-clean
