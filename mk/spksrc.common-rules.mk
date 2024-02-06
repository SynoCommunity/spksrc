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
	git log --pretty=format:"- %s" -- $(PWD)

# If the first argument is "run"...
ifeq (rustup,$(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "run"
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(RUN_ARGS):;@:)
endif

.PHONY: rustup
rustup:
	@rustup $(RUN_ARGS)
