PKG_NAME = vim
PKG_VERS = 9.0
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.nluug.nl/pub/vim/unix
SPECIFIC_VERSION=$(subst .,,$(PKG_VERS))
PKG_DIR = $(PKG_NAME)$(SPECIFIC_VERSION)

ifeq ($(strip $(PYTHON_PACKAGE)),)
PYTHON_PACKAGE = python311
endif

OPTIONAL_DEPENDS = cross/$(PYTHON_PACKAGE)
DEPENDS = cross/ncursesw

HOMEPAGE = https://www.vim.org/
COMMENT  = Vim is a highly configurable text editor built to enable efficient text editing. It is an improved version of the vi editor distributed with most UNIX systems.
LICENSE  = Charityware

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --with-compiledby=SynoCommunity
CONFIGURE_ARGS += --with-features=huge --with-tlib=ncursesw
CONFIGURE_ARGS += vim_cv_toupper_broken=no vim_cv_terminfo=yes vim_cv_tgetent=zero vim_cv_tty_group=world
CONFIGURE_ARGS += vim_cv_getcwd_broken=yes vim_cv_stat_ignores_slash=yes vim_cv_memmove_handles_overlap=yes

include ../../mk/spksrc.archs.mk

ifneq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
BUILD_DEPENDS = cross/$(PYTHON_PACKAGE)
CONFIGURE_ARGS += --enable-python3interp=dynamic --with-python3-command=$(HOSTPYTHON) 
CONFIGURE_ARGS += vi_cv_path_python3_conf=$(PYTHON_CFG_PATH)
CONFIGURE_ARGS += vi_cv_path_python3_pfx=$(PYTHON_PREFIX)
CONFIGURE_ARGS += vi_cv_path_python3_epfx=$(PYTHON_EXEC_PREFIX)
CONFIGURE_ARGS += vi_cv_path_python3path=$(PYTHONPATH)
endif

# Avoid warning that _FORTIFY_SOURCE requires compiling with optimization
ifeq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
# With -O2 optimization there is an ICE with older ppc cross compilers
# usercmd.c:1535: internal compiler error: in set_uids_in_ptset, at tree-ssa-structalias.c:4775
# bug of GCC 4.2/4.3 in tree-optimization
   ADDITIONAL_CFLAGS += -O
else
   ADDITIONAL_CFLAGS += -O2
endif

PLIST_TRANSFORM = sed -e 's%@SPECIFIC_VERSION@%$(SPECIFIC_VERSION)%'

INSTALL_MAKE_OPTIONS = install DESTDIR=$(INSTALL_DIR)

POST_INSTALL_TARGET = vim_post_install

include ../../mk/spksrc.cross-cc.mk

ifneq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
# Only trigger building of dependencies (for the Python config) for targets where it's used
ifeq ($(strip $(filter-out configure compile install plist all,$(MAKECMDGOALS))),)
$(WORK_DIR)/python-cc.mk: depend ;
include $(WORK_DIR)/python-cc.mk
endif

PYTHONPATH = $(PYTHON_SITE_PACKAGES_NATIVE):$(PYTHON_LIB_NATIVE):$(STAGING_INSTALL_PREFIX)/$(PYTHON_LIB_DIR)/site-packages/
PYTHON_PREFIX = $(STAGING_INSTALL_PREFIX)
PYTHON_EXEC_PREFIX = $(STAGING_INSTALL_PREFIX)
PYTHON_CFG_PATH = $(shell $(STAGING_INSTALL_PREFIX)/bin/python3-config --configdir)

ENV += PYTHONPATH=$(PYTHONPATH)
endif

.PHONY: vim_post_install
vim_post_install:
	@install -m 644 src/vimrc $(STAGING_INSTALL_PREFIX)/share/vim/vimrc
	cd $(STAGING_INSTALL_PREFIX)/bin; ln -sf vim vim$(SPECIFIC_VERSION)
