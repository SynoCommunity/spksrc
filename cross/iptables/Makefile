PKG_NAME = iptables
PKG_VERS = 1.8.7
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.netfilter.org/pub/iptables
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

include ../../mk/spksrc.archs.mk

DEPENDS =

HOMEPAGE = https://www.netfilter.org/projects/iptables/index.html
COMMENT  = The userspace command line program used to configure the Linux 2.4.x and later packet filtering ruleset.
LICENSE  = GPLv2

PRE_CONFIGURE_TARGET = iptables_pre_configure
GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-nftables

# If we are not building a generic arch
ifneq ($(findstring $(ARCH),$(GENERIC_ARCHS)),$(ARCH))
# If the kernel has support for XT_CHECKSUM
XT_CHECKSUM_UNSUPPORTED_ARCHS = 88f6281
ifneq ($(findstring $(ARCH),$(XT_CHECKSUM_UNSUPPORTED_ARCHS)),$(ARCH))
REQUIRE_KERNEL = 1
REQUIRE_KERNEL_MODULE = CONFIG_NETFILTER_XT_TARGET_CHECKSUM:net/netfilter:xt_CHECKSUM
endif
endif

include ../../mk/spksrc.cross-cc.mk

.PHONY: iptables_pre_configure
iptables_pre_configure:
	$(RUN) ./autogen.sh 
