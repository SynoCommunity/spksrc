PKG_NAME = sslh
PKG_VERS = 1.13
SRC_VERSION = 1.13b
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(SRC_VERSION).$(PKG_EXT)
PKG_DIST_SITE = http://www.rutschle.net/tech
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
SRC_DIR= $(WORK_DIR)/$(PKG_NAME)-$(PKG_VERS)/
VERSION="v1.13b"

DEPENDS =

HOMEPAGE = http://www.rutschle.net/tech/sslh.shtml
COMMENT  = sslh accepts HTTPS, SSH and OpenVPN connections on the same port
LICENSE  =

CONFIGURE_TARGET = nop
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myCompile
myCompile: $(SRC_DIR)sslh-fork

$(SRC_DIR)sslh-fork: $(SRC_DIR)common.o $(SRC_DIR)sslh-main.o $(SRC_DIR)sslh-fork.o $(SRC_DIR)probe.o $(SRC_DIR)common.h $(SRC_DIR)probe.h
	@$(RUN) $(CC) $(CFLAGS) -D'VERSION=$(VERSION)' -o $(SRC_DIR)sslh-fork $(SRC_DIR)sslh-fork.o $(SRC_DIR)common.o $(SRC_DIR)sslh-main.o $(SRC_DIR)probe.o $(LIBS)

$(SRC_DIR)common.o : $(SRC_DIR)common.h $(SRC_DIR)probe.h
	@$(RUN) $(CC) $(CFLAGS) -D'VERSION=$(VERSION)'  -o $(SRC_DIR)common.o -c $(SRC_DIR)common.c

$(SRC_DIR)sslh-main.o : $(SRC_DIR)common.h $(SRC_DIR)probe.h
	@$(RUN) $(CC) $(CFLAGS) -D'VERSION=$(VERSION)'  -o $(SRC_DIR)sslh-main.o -c $(SRC_DIR)sslh-main.c

$(SRC_DIR)probe.o : $(SRC_DIR)common.h $(SRC_DIR)probe.h   
        @$(RUN) $(CC) $(CFLAGS) -D'VERSION=$(VERSION)'  -o $(SRC_DIR)probe.o -c $(SRC_DIR)probe.c

.PHONY: myInstall
myInstall:
	@$(RUN) mkdir -p $(WORK_DIR)/install/$(INSTALL_PREFIX)/bin
	@$(RUN) cp $(SRC_DIR)sslh-fork $(WORK_DIR)/install/$(INSTALL_PREFIX)/bin/sslh

