# Common rules, shared by all makefiles

###

.PHONY: clean
clean:
	rm -fr work work-* build-*.log publish-*.log status-*.log

.PHONY: smart-clean
smart-clean:
	rm -rf $(WORK_DIR)/$(PKG_DIR)
	rm -f $(WORK_DIR)/.$(COOKIE_PREFIX)*

.PHONY: changelog
changelog:
	git log --pretty=format:"- %s" -- $(CURDIR)

# If the first argument is "rustup"...
ifeq (rustup,$(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "rustup"
  RUSTUP_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(RUSTUP_ARGS):;@:)
endif

.PHONY: rustup
rustup:
	@rustup $(RUSTUP_ARGS)

###

### For make dependency-tree
include ../../mk/spksrc.dependency-tree.mk

### For make digests
include ../../mk/spksrc.generate-digests.mk

### For make kernel-required
include ../../mk/spksrc.kernel-required.mk

###
