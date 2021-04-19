PKG_NAME = lxc
PKG_VERS = 4.0.6
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://linuxcontainers.org/downloads/lxc
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://linuxcontainers.org/lxc/
COMMENT  = LXC is the well-known and heavily tested low-level Linux container runtime
LICENSE  = GPLv2/LGPLv2.1

include ../../mk/spksrc.archs.mk

# Too old
UNSUPPORTED_ARCHS  = $(DEPRECATED_ARCHS)

# Toolchain too old
UNSUPPORTED_ARCHS += 88f6281

# Needed for LXC
DEPENDS  = cross/libcap

# Needed for "download" template to work (Synology version does not work)
DEPENDS += cross/gnupg

ifneq ($(findstring $(ARCH),"qoriq"),$(ARCH))
# Synology netfilter is old and missing modules, bundle a newer version
DEPENDS += cross/iptables
endif

# Synology dnsmasq is old, bundle a newer version
DEPENDS += cross/dnsmasq

PRE_CONFIGURE_TARGET = lxc_pre_configure
GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --with-distro=ubuntu
CONFIGURE_ARGS += --with-init-script=sysvinit
CONFIGURE_ARGS += --enable-apparmor

include ../../mk/spksrc.cross-cc.mk

.PHONY: lxc_pre_configure
lxc_pre_configure:
	$(RUN) ./autogen.sh 
