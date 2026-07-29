TC_ARCH = qoriq
TC_VERS = 6.2.4
TC_KERNEL = 2.6.32
TC_GLIBC = 2.20
TC_GCC = 4.9.3

TC_DIST = qoriq-gcc493_glibc220_hard_qoriq-GPL
TC_DIST_SITE_PATH = toolchains%2Fdsm6.2.4

TC_TARGET = powerpc-e500v2-linux-gnuspe
TC_SYSROOT = $(TC_TARGET)/sysroot
TC_EXTRA_BUILD_FLAGS = -mcpu=8548 -mhard-float -mfloat-gprs=double
TC_EXTRA_RUSTFLAGS = -Ctarget-cpu=e500

# the target has no native 64-bit atomics.
# -latomic is dropped automatically when the gcc does not ship it.
TC_EXTRA_LDFLAGS = -latomic

include ../../mk/spksrc.toolchain.mk

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
