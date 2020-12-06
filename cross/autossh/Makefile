PKG_NAME = autossh
PKG_VERS = 1.4g
PKG_EXT = tgz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.harding.motd.ca/autossh
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssh

HOMEPAGE = https://www.harding.motd.ca/autossh/
COMMENT  = Automatically restart SSH sessions and tunnels.

GNU_CONFIGURE = 1
CONFIGURE_ARGS = ac_cv_func_realloc_0_nonnull=yes ac_cv_func_malloc_0_nonnull=yes
CONFIGURE_ARGS += ac_cv_path_ssh=$(INSTALL_PREFIX)/bin/ssh

include ../../mk/spksrc.cross-cc.mk
