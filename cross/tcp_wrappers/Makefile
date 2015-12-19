PKG_NAME = tcp_wrappers
PKG_VERS = 7.6
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)_$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.porcupine.org/pub/security/

DEPENDS =

HOMEPAGE = http://www.linuxfromscratch.org/blfs/view/6.3/basicnet/tcpwrappers.html
COMMENT  = The TCP Wrapper package provides daemon wrapper programs that report the name of the client requesting network services and the requested service. 
LICENSE  = GNU GPL

CONFIGURE_TARGET = nop
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myCompile
myCompile:
	$(RUN) sed -i -e "s,^extern char \*malloc();,/* & */," scaffold.c
	$(RUN) $(MAKE) REAL_DAEMON_DIR=$(STAGING_INSTALL_PREFIX) PREFIX=$(STAGING_INSTALL_PREFIX) linux

.PHONY: myInstall
myInstall:
	@$(RUN) mkdir -p $(STAGING_INSTALL_PREFIX)/sbin/
	@$(RUN) mkdir -p $(STAGING_INSTALL_PREFIX)/lib/
	#@$(RUN) mkdir -p $(STAGING_INSTALL_PREFIX)/share/man/man8/
	#@$(RUN) mkdir -p $(STAGING_INSTALL_PREFIX)/share/man/man5/
	@$(RUN) mkdir -p $(STAGING_INSTALL_PREFIX)/include/
	
	@$(RUN) $(MAKE) DESTDIR=$(STAGING_INSTALL_PREFIX) install
