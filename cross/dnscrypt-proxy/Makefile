PKG_NAME = dnscrypt-proxy
PKG_VERS = 2.0.8
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS)
PKG_DIST_SITE = https://github.com/jedisct1/dnscrypt-proxy/releases/download

HOMEPAGE = https://github.com/jedisct1/dnscrypt-proxy
COMMENT  = A flexible DNS proxy, with support for modern encrypted DNS protocols such as DNSCrypt v2 and DNS-over-HTTP/2.
LICENSE  = ISC License

UNSUPPORTED_ARCHS = powerpc ppc824x ppc853x ppc854x qoriq

include ../../mk/spksrc.common.mk

DNSCRYPT_ARCH =
ifeq ($(findstring $(ARCH),$(x64_ARCHES)),$(ARCH))
DNSCRYPT_ARCH = linux_x86_64
endif
ifeq ($(findstring $(ARCH),$(x86_ARCHES)),$(ARCH))
DNSCRYPT_ARCH = linux_i386
endif
ifeq ($(findstring $(ARCH),$(ARM5_ARCHES)),$(ARCH))
DNSCRYPT_ARCH = linux_arm
endif
ifeq ($(findstring $(ARCH),$(ARM7_ARCHES)),$(ARCH))
DNSCRYPT_ARCH = linux_arm
endif
ifeq ($(findstring $(ARCH),$(ARM8_ARCHES)),$(ARCH))
DNSCRYPT_ARCH = linux_arm64
endif
ifeq ($(findstring $(ARCH), powerpc),$(ARCH))
DNSCRYPT_ARCH = linux_ppc
endif
ifeq ($(findstring $(ARCH), ppc824x ppc853x ppc854x qoriq),$(ARCH))
DNSCRYPT_ARCH = linux_ppc
endif
ifeq ($(strip $(DNSCRYPT_ARCH)),)
# unexpected arch. Please add arch to mk/spksrc.common.mk
$(error Arch $(ARCH) not expected yet)
endif

PKG_DIST_NAME = $(PKG_NAME)-$(DNSCRYPT_ARCH)-$(PKG_VERS).$(PKG_EXT) # compiled version
PKG_DIR = `echo $(DNSCRYPT_ARCH) | sed 's/_/-/'`

CONFIGURE_TARGET = myConfigure
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall

.PHONY: myPreConfigure
myConfigure:
.PHONY: myBuild
myCompile:
.PHONY: myInstall
myInstall:
	cp  $(WORK_DIR)/$(PKG_DIR)/* $(INSTALL_DIR)/$(INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk
