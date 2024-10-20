TC_ARCH = qoriq
TC_VERS = 6.2.4
TC_KERNEL = 2.6.32
TC_GLIBC = 2.20

TC_DIST = qoriq-gcc493_glibc220_hard_qoriq-GPL
TC_DIST_SITE_PATH = PowerPC%20QorIQ%20Linux%202.6.32

TC_TARGET = powerpc-e500v2-linux-gnuspe
TC_SYSROOT = $(TC_TARGET)/sysroot
TC_EXTRA_CFLAGS = -mcpu=8548 -mhard-float -mfloat-gprs=double
TC_RUSTFLAGS = -C target-cpu=e500

include ../../mk/spksrc.tc.mk

OPTIONAL_DEPENDS = toolchain/syno-$(TC_ARCH)-$(TC_VERS)-rust

ifneq ($(RUST_BUILD_TOOLCHAIN),1)
DEPENDS = toolchain/syno-$(TC_ARCH)-$(TC_VERS)-rust
else
POST_FIX_TARGET = qoriq_post_fix_target
endif

.PHONY: qoriq_post_fix_target
qoriq_post_fix_target:
	@cd $(WORK_DIR)/$(TC_TARGET)/bin ; \
	for gnutool in $$(ls -1); do \
	  [ ! -L "powerpc-linux-gnuspe-$${gnutool##*-}" ] && ln -sf $${gnutool} "powerpc-linux-gnuspe-$${gnutool##*-}" ; \
	  [ ! -L "powerpc-unknown-linux-gnuspe-$${gnutool##*-}" ] && ln -sf $${gnutool} "powerpc-unknown-linux-gnuspe-$${gnutool##*-}" ; \
	done
