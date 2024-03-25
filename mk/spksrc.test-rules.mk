# Framework testing common rules, shared by all makefiles

include mk/spksrc.common.mk

###

# If the first argument is "test"...
ifeq (test,$(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "test"
  TEST_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(TEST_ARGS):;@:)
endif

.PHONY: test
test:
	$(MAKE) test-$(TEST_ARGS)

###

TEST_DEFAULT = cross/tree spk/demoservice diyspk/tmux
TEST_RUSTC = cross/bat
TEST_CMAKE = cross/intel-gmmlib
TEST_GNUCONFIGURE = cross/ncursesw
TEST_MESON = cross/libdrm

.PHONY: testall
testall: test-dependency-tree test-dependency-flat test-dependency-list
testall: test-clean
testall: test-depend
testall: test-download test-digests
testall: test-extract test-patch
testall: test-compile test-install
testall: test-toolchain
testall: test-rustc test-cmake test-gnuconfigure test-meson

.PHONY: test-info
test-info:
	@echo SUPPORTED_ARCHS: $(SUPPORTED_ARCHS)
	@echo LATEST_ARCHS: $(LATEST_ARCHS)
	@echo SUPPORTED_KERNEL_VERSIONS: $(SUPPORTED_KERNEL_VERSIONS)

# Testing against toolchain and simple build use-cases
# Process 'clean' on toolchains at the end as otherwise rebuilt
.PHONY: test-%
test-%:
	@for arch in $(SUPPORTED_ARCHS) ; do \
	  for do_test in $(TEST_DEFAULT) ; do \
	    if [ "$*" = "clean" ]; then \
	      make -C $${do_test} clean ; \
	    else \
	      make -C $${do_test} ARCH=$${arch%%-*} TCVERSION=$${arch##*-} $* ; \
	    fi ; \
	  done ; \
	done ; \

.PHONY: test-toolchain
test-toolchain: $(addprefix test-toolchain-,$(SUPPORTED_ARCHS))

.PHONY: test-toolchain-%
test-toolchain-%:
	make -C toolchain/syno-$* clean
	make -C toolchain/syno-$*

.PHONY: test-rustc
test-rustc:
	PARALLEL_MAKE=max make -j2 -C $(TEST_RUSTC) all-supported

.PHONY: test-cmake
test-cmake:
	PARALLEL_MAKE=max make -j2 -C $(TEST_CMAKE) all-supported

.PHONY: test-gnuconfigure
test-gnuconfigure:
	PARALLEL_MAKE=max make -j2 -C $(TEST_GNUCONFIGURE) all-supported

.PHONY: test-meson
test-meson:
	PARALLEL_MAKE=max make -j2 -C $(TEST_MESON) all-supported
