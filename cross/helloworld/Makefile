PKG_NAME = helloworld
PKG_VERS = 1.0.0
PKG_EXT = zip
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Ximi1970/spksrc-$(PKG_NAME)/archive
PKG_DIR = spksrc-$(PKG_NAME)-$(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/SynoCommunity/spksrc
COMMENT  = Toolchain testing ground.
LICENSE  = GNU GPL


CONFIGURE_TARGET = myConfigure
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall


include ../../mk/spksrc.cross-cc.mk


.PHONY: myConfigure
myConfigure:

.PHONY: myCompile
myCompile:
	$(RUN) $(CC) $(CFLAGS) $(LDFLAGS) helloworld.c -o helloworld
	$(RUN) $(CC) $(CFLAGS) $(LDFLAGS) -static helloworld.c -o helloworld-static

.PHONY: myInstall
myInstall:
	$(RUN) echo ; \
		mkdir -p $(INSTALL_DIR)$(INSTALL_PREFIX)/bin ; \
		cp helloworld $(INSTALL_DIR)$(INSTALL_PREFIX)/bin ; \
		cp helloworld-static $(INSTALL_DIR)$(INSTALL_PREFIX)/bin
