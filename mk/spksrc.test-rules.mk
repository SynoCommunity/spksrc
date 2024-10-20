# Framework testing common rules, shared by all makefiles

include mk/spksrc.common.mk

###

# If the first argument is "test"...
ifeq (test,$(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "test"
  TEST_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(TEST_ARGS):;@:)
ifeq ($(strip $(TEST_ARGS)),)
  $(error Argument missing for 'make test')
endif
endif

.PHONY: test
test:
	$(MAKE) test-$(TEST_ARGS)

###

TEST_DEFAULT_SPK = spk/demoservice diyspk/tmux
TEST_DEFAULT = cross/tree cross/libtree cross/zsh
TEST_RUSTC = cross/bat
TEST_CMAKE = cross/intel-gmmlib
TEST_GNUCONFIGURE = cross/ncursesw
TEST_MESON = cross/libdrm
TEST_FFMPEG = spk/ffmpeg5
TEST_FFMPEG_DEP = spk/tvheadend
TEST_PYTHON = spk/python311
TEST_PYTHON_DEP = spk/borgbackup

.PHONY: test-all
test-all: test-dependency-tree test-dependency-flat test-dependency-list
test-all: test-clean
test-all: test-depend
test-all: test-download test-digests
test-all: test-extract test-patch
test-all: test-compile test-install
test-all: test-toolchain
test-all: test-rustc test-cmake test-gnuconfigure test-meson
test-all: test-python
test-all: test-ffmpeg

.PHONY: test-info
test-info:
	@echo SUPPORTED_ARCHS: $(SUPPORTED_ARCHS)
	@echo LATEST_ARCHS: $(LATEST_ARCHS)

# Testing against toolchain and simple build use-cases
# Process 'clean' on toolchains at the end as otherwise rebuilt
.PHONY: test-%
test-%: SHELL:=/bin/bash
test-%:
	@if echo "$*" | grep -Eq '^(clean|download|digests)'; then \
	  for do_test in $(TEST_DEFAULT) ; do \
	    echo "make -C $${do_test} $*" ; \
	    make -C $${do_test} $* ; \
	  done ; \
	elif echo "$*" | grep -Eq '^(dependency-*)'; then \
	  for do_test in $(TEST_DEFAULT) ; do \
	    echo "make --no-print-directory -C $${do_test} $*" ; \
	    make --no-print-directory -C $${do_test} $* ; \
	  done ; \
	else \
	  for arch in $(SUPPORTED_ARCHS) ; do \
	    for do_test in $(TEST_DEFAULT) ; do \
	      echo "make -C $${do_test} ARCH=$${arch%%-*} TCVERSION=$${arch##*-} $*" ; \
	      make -C $${do_test} ARCH=$${arch%%-*} TCVERSION=$${arch##*-} $* ; \
	    done ; \
	  done ; \
	fi

.PHONY: test-clean
test-clean: native-clean cross-clean spk-clean

.PHONY: test-dependency-%
test-dependency-%: dependency-$*

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

.PHONY: test-ffmpeg
test-ffmpeg:
	PARALLEL_MAKE=max make -j2 -C $(TEST_FFMPEG) all-supported
	PARALLEL_MAKE=max make -j2 -C $(TEST_FFMPEG_DEP) all-supported

.PHONY: test-python
test-python:
	PARALLEL_MAKE=max make -j2 -C $(TEST_PYTHON) all-supported
	PARALLEL_MAKE=max make -j2 -C $(TEST_PYTHON_DEP) all-supported
