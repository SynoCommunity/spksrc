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

.PHONY: testall
testall: test-dependency-tree test-dependency-flat test-dependency-list
testall: test-clean
testall: test-download test-digests
testall: test-depend
testall: test-toolchain

.PHONY: test-info
test-info:
	@echo SUPPORTED_ARCHS: $(SUPPORTED_ARCHS)
	@echo LATEST_ARCHS: $(LATEST_ARCHS)
	@echo SUPPORTED_KERNEL_VERSIONS: $(SUPPORTED_KERNEL_VERSIONS)

.PHONY: test-%
test-%:
	make -C toolchain/syno-qoriq-6.2.4 $*

.PHONY: test-toolchain
test-toolchain: $(addprefix test-toolchain-,$(SUPPORTED_ARCHS))

.PHONY: test-toolchain-%
test-toolchain-%:
	make -C toolchain/syno-$* clean
	make -C toolchain/syno-$*
