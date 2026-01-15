### Toolchain rustc rules
# Invoke rustc toolchain install
# Targets are executed in the following order:
#  rustc_msg_target
#  pre_rustc_target   (override with PRE_RUSTC_TARGET)
#  rustc_target       (override with RUSTC_TARGET)
#  post_rustc_target  (override with POST_RUSTC_TARGET)

# Define rustc configuration toml file location
# when rebuilding for unsupported archs (i.e. Tier 3)
ifeq ($(strip $(TC_NAME)),)
TC_LOCAL_VARS_RUST = $(WORK_DIR)/$(TC_ARCH).toml
else
TC_LOCAL_VARS_RUST = $(WORK_DIR)/$(lastword $(subst -, ,$(TC_NAME))).toml
endif

# Configure file descriptor lock timeout
ifeq ($(strip $(FLOCK_TIMEOUT)),)
FLOCK_TIMEOUT = 300
endif

RUSTC_COOKIE = $(WORK_DIR)/.$(COOKIE_PREFIX)rustc_done

ifeq ($(strip $(PRE_RUSTC_TARGET)),)
PRE_RUSTC_TARGET = pre_rustc_target
else
$(PRE_RUSTC_TARGET): rustc_msg
endif
ifeq ($(strip $(RUSTC_TARGET)),)
RUSTC_TARGET = rustc_target
else
$(RUSTC_TARGET): $(PRE_RUSTC_TARGET)
endif
ifeq ($(strip $(POST_RUSTC_TARGET)),)
POST_RUSTC_TARGET = post_rustc_target
else
$(POST_RUSTC_TARGET): $(RUSTC_TARGET)
endif

.PHONY: rustc rustc_msg
.PHONY: $(PRE_RUSTC_TARGET) $(RUSTC_TARGET) $(POST_RUSTC_TARGET)

.PHONY: $(TC_LOCAL_VARS_RUST)
$(TC_LOCAL_VARS_RUST):
	env $(MAKE) --no-print-directory rust_toml > $@ 2>/dev/null;

# https://github.com/rust-lang/rust/blob/master/config.example.toml
.PHONY: rust_toml
rust_toml:
	@echo 'profile = "compiler"' ; \
	echo
	@echo "[build]" ; \
	echo 'target = ["x86_64-unknown-linux-gnu", "$(RUST_TARGET)"]' ; \
	echo "build-stage = $(RUSTUP_DEFAULT_TOOLCHAIN_STAGE)" ; \
	echo "doc-stage = 2" ; \
	echo "docs = false" ; \
	echo "docs-minification = false" ; \
	echo "compiler-docs = false" ; \
	echo
	@echo "[rust]" ; \
	echo 'channel = "$(RUSTUP_DEFAULT_TOOLCHAIN)"' ; \
	echo 'lto = "off"' ; \
	echo
	@echo "[llvm]" ; \
	echo 'download-ci-llvm = "if-unchanged"' ; \
	echo
	@echo "[install]" ; \
	echo
	@echo "[dist]" ; \
	echo
	@echo "[target.x86_64-unknown-linux-gnu]" ; \
	echo
	@echo "[target.$(RUST_TARGET)]" ; \
	echo 'cc = "$(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)gcc"' ; \
	echo 'cxx = "$(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)g++"' ; \
	echo 'ar = "$(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)ar"' ; \
	echo 'ranlib = "$(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)ranlib"' ; \
	echo 'linker = "$(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)gcc"' ; \
	echo

rustc_msg:
	@$(MSG) "Installing rustc toolchain for $(NAME)"
	@$(MSG) "- rustup installation PATH: $(RUSTUP_HOME)"
	@$(MSG) "- cargo installation PATH: $(CARGO_HOME)"
	@$(MSG) "- default PATH: $(PATH)"

pre_rustc_target: rustc_msg
	@$(MSG) "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path" ; \
	exec 5> /tmp/tc-rustc.lock ; \
	flock --timeout $(FLOCK_TIMEOUT) --exclusive 5 || exit 1 ; \
	pid=$$$$ ; \
	echo "$${pid}" 1>&5 ; \
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path ; \
	flock -u 5

rustc_target: $(PRE_RUSTC_TARGET) $(TC_LOCAL_VARS_RUST)
	@$(MSG) "rustup toolchain install $(RUSTUP_DEFAULT_TOOLCHAIN)" ; \
	exec 5> /tmp/tc-rustc.lock ; \
	flock --timeout $(FLOCK_TIMEOUT) --exclusive 5 || exit 1 ; \
	pid=$$$$ ; \
	echo "$${pid}" 1>&5 ; \
	rustup toolchain install $(RUSTUP_DEFAULT_TOOLCHAIN) ; \
	$(MSG) "rustup default $(RUSTUP_DEFAULT_TOOLCHAIN)" ; \
	rustup default $(RUSTUP_DEFAULT_TOOLCHAIN) ; \
	flock -u 5
ifeq ($(TC_RUSTUP_TOOLCHAIN),$(RUSTUP_DEFAULT_TOOLCHAIN))
	@$(MSG) "rustup target add $(RUST_TARGET)"
	rustup override set $(RUSTUP_DEFAULT_TOOLCHAIN)
	rustup target add $(RUST_TARGET)
	rustup show
else
	@$(MSG) "Target $(RUST_TARGET) unavailable..."
ifeq ($(RUST_BUILD_TOOLCHAIN),1)
	@$(MSG) "Build rust target $(RUST_TARGET) from sources"
	@$(MSG) "Building Tier-3 rust target: $(RUST_TARGET)"
ifneq ($(RUST_BUILD_VERSION),)
	@$(MSG) "Checkout rust tag $(RUST_BUILD_VERSION)"
	@(cd $(WORK_DIR) && [ ! -d rust ] && git clone --depth 1 --branch $(RUST_BUILD_VERSION) https://github.com/rust-lang/rust.git || true)
else
	@$(MSG) "Build latests release (current HEAD)"
	@(cd $(WORK_DIR) && [ ! -d rust ] && git clone --depth 1 https://github.com/rust-lang/rust.git || true)
endif
	@(cd $(WORK_DIR)/rust && rm -f config.toml && ./x setup compiler)
	(cd $(WORK_DIR)/rust && \
	   CFLAGS_$(subst -,_,$(RUST_TARGET))="$(TC_EXTRA_CFLAGS)" \
	   CARGO_TARGET_$(shell echo $(RUST_TARGET) | tr - _ | tr a-z A-Z)_RUSTFLAGS="$(TC_RUSTFLAGS)" \
	   RUST_BACKTRACE=full \
	   ./x build --config $(TC_LOCAL_VARS_RUST))
	rustup toolchain link $(TC_RUSTUP_TOOLCHAIN) $(WORK_DIR)/rust/build/host/stage$(RUSTUP_DEFAULT_TOOLCHAIN_STAGE)
	@for i in 0 1 2 ; do \
	   [ $${i} -lt $(RUSTUP_DEFAULT_TOOLCHAIN_STAGE) ] && (cd $(WORK_DIR)/rust && ./x clean --stage $${i}) || true ; \
	done
	@$(MSG) "Building Tier 3 rust target: $(RUST_TARGET) - stage$(RUSTUP_DEFAULT_TOOLCHAIN_STAGE) complete"
	rustup show
endif
endif

post_rustc_target: $(RUSTC_TARGET)

ifeq ($(wildcard $(RUSTC_COOKIE)),)
rustc: $(RUSTC_COOKIE)

$(RUSTC_COOKIE): $(POST_RUSTC_TARGET)
	$(create_target_dir)
	@touch -f $@
else
rustc: ;
endif
