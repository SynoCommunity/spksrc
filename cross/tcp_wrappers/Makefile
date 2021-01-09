PKG_NAME = tcp_wrappers
PKG_VERS = 7.6
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)_$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.porcupine.org/pub/security
PKG_DIR = $(PKG_NAME)_$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://www.linuxfromscratch.org/blfs/view/5.1/basicnet/tcpwrappers.html
COMMENT  = The tcpwrappers package provides daemon wrapper programs that report the name of the client requesting network services and the requested service. 
LICENSE  = BSD

POST_EXTRACT_TARGET = tcp_wrappers_post_extract
CONFIGURE_TARGET = nop
COMPILE_TARGET = tcp_wrappers_compile

include ../../mk/spksrc.cross-cc.mk

.PHONY: tcp_wrappers_post_extract
tcp_wrappers_post_extract:
	cp -f src/weak_symbols.c $(WORK_DIR)/$(PKG_DIR)/
	
.PHONY: tcp_wrappers_compile
tcp_wrappers_compile:
	$(RUN) $(MAKE) REAL_DAEMON_DIR=$(STAGING_INSTALL_PREFIX) linux 
