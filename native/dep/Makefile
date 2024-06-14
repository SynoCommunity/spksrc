PKG_NAME = dep
PKG_VERS = 0.5.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/golang/dep/archive
PKG_DIR = $(PKG_NAME)

DEPENDS = native/go

HOMEPAGE   = https://golang.github.io/dep/
COMMENT    = Go dependency management tool
LICENSE    = BSD

CONFIGURE_TARGET = nop
COMPILE_TARGET = myComp
INSTALL_TARGET = nop

include ../../mk/spksrc.native-cc.mk

DEP_DIR = $(WORK_DIR)/src/github.com/golang/$(PKG_NAME)
EXTRACT_PATH = $(WORK_DIR)/src/github.com/golang

ENV += GOPATH="$(WORK_DIR)" \
		GOOS=linux \
		GOARCH="" \
		PATH=$(WORK_DIR)/../../../native/go/work-native/go/bin/:$$PATH \

myComp:
	@$(MSG) "Building dep for host system"
	mv $(WORK_DIR)/src/github.com/golang/$(PKG_NAME)-$(PKG_VERS) $(WORK_DIR)/src/github.com/golang/$(PKG_NAME)
	#cd $(WORK_DIR)/$(PKG_NAME)/src && GO111MODULE=off GOARCH="" GOROOT_BOOTSTRAP=$(GOROOT_BOOTSTRAP14) ./make.bash
	cd $(WORK_DIR)/ && env $(ENV) go install ./...
