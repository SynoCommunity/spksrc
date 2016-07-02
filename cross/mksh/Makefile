PKG_NAME = mksh
PKG_VERS = R52c
PKG_EXT = tgz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.mirbsd.org/MirOS/dist/mir/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)

DEPENDS =

HOMEPAGE = https://www.mirbsd.org/mksh.htm
COMMENT  = MirBSD (tm) Korn Shell is an actively developed free implementation of the Korn Shell programming language and a successor to the Public Domain Korn Shell (pdksh).
LICENSE  = BSD

CONFIGURE_TARGET = nop
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

myCompile:
	@$(RUN) bash ./Build.sh
myInstall:
	@$(RUN) mkdir -p $(STAGING_INSTALL_PREFIX)/bin/
	@$(RUN) install -c -s -o root -g root -m 555 mksh $(STAGING_INSTALL_PREFIX)/bin/mksh
	@$(RUN) mkdir -p $(STAGING_INSTALL_PREFIX)/share/doc/mksh/examples/
	@$(RUN) install -c -o root -g root -m 444 dot.mkshrc $(STAGING_INSTALL_PREFIX)/share/doc/mksh/examples/
	@$(RUN) mkdir -p $(STAGING_INSTALL_PREFIX)/share/man/man1/
	@$(RUN) install -c -o root -g root -m 444 mksh.1 $(STAGING_INSTALL_PREFIX)/share/man/man1/mksh.1
