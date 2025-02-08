PKG_NAME = vim
PKG_VERS = 9.1.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/vim/vim/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
SPECIFIC_VERSION=$(firstword $(subst ., ,$(PKG_VERS)))
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncursesw

HOMEPAGE = https://www.vim.org/
COMMENT  = Vim is a highly configurable text editor built to enable efficient text editing. It is an improved version of the vi editor distributed with most UNIX systems.
LICENSE  = Charityware

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --with-compiledby=SynoCommunity
CONFIGURE_ARGS += --with-features=huge
CONFIGURE_ARGS += --with-tlib=ncursesw
CONFIGURE_ARGS += vim_cv_toupper_broken=no
CONFIGURE_ARGS += vim_cv_terminfo=yes
CONFIGURE_ARGS += vim_cv_tgetent=zero
CONFIGURE_ARGS += vim_cv_tty_group=world
CONFIGURE_ARGS += vim_cv_getcwd_broken=yes
CONFIGURE_ARGS += vim_cv_stat_ignores_slash=yes
CONFIGURE_ARGS += vim_cv_memmove_handles_overlap=yes
CONFIGURE_ARGS += vim_cv_timer_create=no
CONFIGURE_ARGS += vim_cv_timer_create_with_lrt=no

ADDITIONAL_CFLAGS += -O2

PLIST_TRANSFORM = sed -e 's%@SPECIFIC_VERSION@%$(SPECIFIC_VERSION)%'

INSTALL_MAKE_OPTIONS = install DESTDIR=$(INSTALL_DIR)

POST_INSTALL_TARGET = vim_post_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: vim_post_install
vim_post_install:
	@install -m 644 src/vimrc $(STAGING_INSTALL_PREFIX)/share/vim/vimrc
	@cd $(STAGING_INSTALL_PREFIX)/bin; ln -sf vim vim$(SPECIFIC_VERSION)
