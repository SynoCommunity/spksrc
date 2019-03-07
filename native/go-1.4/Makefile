PKG_NAME = go
PKG_VERS = 1.4-bootstrap-20171003
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://dl.google.com/go/
PKG_DIR = $(PKG_NAME)

DEPENDS =

HOMEPAGE   = http://golang.org/
COMMENT    = Go is an open source programming language that makes it easy to build simple, reliable, and efficient software.
LICENSE    =

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = myComp

include ../../mk/spksrc.native-cc.mk

myComp:
	@$(MSG) "Building Go 1.4"
	cd $(WORK_DIR)/$(PKG_NAME)/src && GOARCH="" ./make.bash
