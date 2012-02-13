PKG_NAME = sslh
PKG_VERS = 1.10
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.rutschle.net/tech
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
SRC_DIR= $(WORK_DIR)/$(PKG_NAME)-$(PKG_VERS)/
VERSION="v1.10"
DEPENDS = 

HOMEPAGE = http://www.rutschle.net/tech/sslh.shtml
COMMENT  = sslh accepts HTTPS, SSH and OpenVPN connections on the same port
LICENSE  =

ADDITIONAL_CFLAGS =
CONFIGURE_ARGS = 

CONFIGURE_TARGET = myConfigure
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

myConfigure:
	echo "Configure"

.PHONY: myCompile
myCompile: $(SRC_DIR)sslh-fork

$(SRC_DIR)sslh-fork: $(SRC_DIR)common.o $(SRC_DIR)sslh-main.o $(SRC_DIR)sslh-fork.o $(SRC_DIR)common.h
	@$(RUN) $(CC) $(CFLAGS) -D'VERSION=$(VERSION)' -o $(SRC_DIR)sslh-fork $(SRC_DIR)sslh-fork.o $(SRC_DIR)common.o $(SRC_DIR)sslh-main.o $(LIBS)

$(SRC_DIR)common.o : $(SRC_DIR)common.h
	@$(RUN) $(CC) $(CFLAGS) -D'VERSION=$(VERSION)'  -o $(SRC_DIR)common.o -c $(SRC_DIR)common.c

$(SRC_DIR)sslh-main.o : $(SRC_DIR)common.h
	@$(RUN) $(CC) $(CFLAGS) -D'VERSION=$(VERSION)'  -o $(SRC_DIR)sslh-main.o -c $(SRC_DIR)sslh-main.c


myInstall:
	echo "Install"
	@$(RUN) mkdir -p $(WORK_DIR)/install/$(INSTALL_PREFIX)/bin
	@$(RUN) cp $(SRC_DIR)sslh-fork $(WORK_DIR)/install/$(INSTALL_PREFIX)/bin/sslh

