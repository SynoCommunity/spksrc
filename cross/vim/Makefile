PKG_NAME = vim
PKG_VERS = 8.2
PKG_VERS_CUT = 82
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.vim.org/pub/vim/unix/
PKG_DIR = $(PKG_NAME)$(PKG_VERS_CUT)

CHANGELOG = "1. Update to vim 8.2<br>2. Compile with dynamic Python 3 support. Enabled if Python 3 > 3.6.1 is also installed."

BUILD_DEPENDS = cross/python3
DEPENDS = cross/ncurses

HOMEPAGE = http://www.vim.org/
COMMENT  = Vim is an advanced text editor that seeks to provide the power of the de-facto Unix editor Vi, with a more complete feature set.
LICENSE  = Charityware

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-features=huge vim_cv_toupper_broken=no --with-tlib=ncurses vim_cv_terminfo=yes vim_cv_tgetent=zero vim_cv_tty_group=world
CONFIGURE_ARGS += vim_cv_getcwd_broken=yes vim_cv_stat_ignores_slash=yes vim_cv_memmove_handles_overlap=yes
CONFIGURE_ARGS += --enable-python3interp=dynamic --with-python3-command=$(HOSTPYTHON) vi_cv_path_python3_conf=$(PYTHON_CFG_PATH) vi_cv_path_python3_pfx=$(PYTHON_PREFIX) vi_cv_path_python3_epfx=$(PYTHON_EXEC_PREFIX) vi_cv_path_python3path=$(PYTHONPATH)

# Add the Python 3 SPK's installed lib dir to vim's rpath to allow loading of libpython dynamically if it's available
ADDITIONAL_LDFLAGS = -Wl,--rpath,/var/packages/python3/target/lib

INSTALL_TARGET = vim_install

include ../../mk/spksrc.cross-cc.mk

# Only trigger building of dependencies (for the Python config) for targets where it's used
ifeq ($(strip $(filter-out configure compile install plist all,$(MAKECMDGOALS))),)
$(WORK_DIR)/python-cc.mk: depend ;
include $(WORK_DIR)/python-cc.mk
endif

PYTHONPATH = $(PYTHON_SITE_PACKAGES_NATIVE):$(PYTHON_LIB_NATIVE):$(INSTALL_DIR)$(INSTALL_PREFIX)/$(PYTHON_LIB_DIR)/site-packages/
PYTHON_PREFIX = $(STAGING_INSTALL_PREFIX)
PYTHON_EXEC_PREFIX = $(STAGING_INSTALL_PREFIX)
PYTHON_CFG_PATH = $(shell $(STAGING_INSTALL_PREFIX)/bin/python3-config --configdir)

ENV += PYTHONPATH=$(PYTHONPATH)

.PHONY: vim_install
vim_install:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)
	install -m 644 src/vimrc $(STAGING_INSTALL_PREFIX)/share/vim/vimrc
