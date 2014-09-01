PKG_NAME = sslh
PKG_VERS = v1.16
SRC_VERSION = v1.16
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(SRC_VERSION).$(PKG_EXT)
PKG_DIST_SITE = http://www.rutschle.net/tech
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
SRC_DIR= $(WORK_DIR)/$(PKG_NAME)-$(PKG_VERS)/
VERSION="v1.16"

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

OBJS=$(SRC_DIR)common.o $(SRC_DIR)sslh-main.o $(SRC_DIR)probe.o

$(SRC_DIR)version.h:
	$(SRC_DIR)genver.sh > $(SRC_DIR)version.h

$(SRC_DIR)sslh: $(SRC_DIR)sslh-fork $(SRC_DIR)sslh-select

$(SRC_DIR)sslh-fork: $(SRC_DIR)version.h $(OBJS) $(SRC_DIR)sslh-fork.o $(SRC_DIR)Makefile $(SRC_DIR)common.h
	$(CC) $(CFLAGS) $(LDFLAGS) -o $(SRC_DIR)sslh-fork $(SRC_DIR)sslh-fork.o $(OBJS) $(LIBS)
	#strip sslh-fork

$(SRC_DIR)sslh-select: $(SRC_DIR)version.h $(OBJS) $(SRC_DIR)sslh-select.o $(SRC_DIR)Makefile $(SRC_DIR)common.h
	$(CC) $(CFLAGS) $(LDFLAGS) -o $(SRC_DIR)sslh-select $(SRC_DIR)sslh-select.o $(OBJS) $(LIBS)
	#strip sslh-select

$(SRC_DIR)echosrv: $(OBJS) $(SRC_DIR)echosrv.o
	$(CC) $(CFLAGS) $(LDFLAGS) -o $(SRC_DIR)echosrv $(SRC_DIR)echosrv.o $(SRC_DIR)probe.o $(SRC_DIR)common.o $(LIBS)

.PHONY: myInstall
myInstall:
	@$(RUN) mkdir -p $(WORK_DIR)/install/$(INSTALL_PREFIX)/bin
	@$(RUN) cp $(SRC_DIR)sslh-fork $(WORK_DIR)/install/$(INSTALL_PREFIX)/bin/sslh

