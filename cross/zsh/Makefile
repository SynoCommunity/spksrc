PKG_NAME = zsh
PKG_VERS = 5.9
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.zsh.org/pub
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncursesw cross/gdbm cross/pcre
OPTIONAL_DEPENDS = cross/libcap

HOMEPAGE = https://www.zsh.org/
COMMENT  = Zsh is a shell designed for interactive use, although it is also a powerful scripting language.
LICENSE  = Custom

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --enable-gdbm
CONFIGURE_ARGS += --enable-pcre

include ../../mk/spksrc.archs.mk

ifneq ($(findstring $(ARCH),$(OLD_PPC_ARCHS) $(ARMv5_ARCHS)),$(ARCH))
DEPENDS += cross/libcap
CONFIGURE_ARGS += --enable-cap
endif

PRE_COMPILE_TARGET = zsh_pre_compile

ifeq ($(ZSH_STATIC_MODULES),true)
	BUILD_MSG = "Building zsh with statically linked modules."
	POST_CONFIGURE_TARGET = link-zsh-modules
else
	BUILD_MSG = "Building zsh with dynamically linked modules."
endif

INSTALL_MAKE_OPTIONS = install DESTDIR=$(INSTALL_DIR)

include ../../mk/spksrc.cross-cc.mk

.PHONY: link-zsh-modules
link-zsh-modules:
	@$(RUN) sed -i 's/link=no/link=static/' config.modules

.PHONY: zsh_pre_compile
zsh_pre_compile:
	@$(MSG) $(BUILD_MSG)
