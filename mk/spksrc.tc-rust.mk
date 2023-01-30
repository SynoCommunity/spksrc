### Toolchain rustc rules
# Invoke rustc toolchain install
# Targets are executed in the following order:
#  rustc_msg_target
#  pre_rustc_target   (override with PRE_RUSTC_TARGET)
#  rustc_target       (override with RUSTC_TARGET)
#  post_rustc_target  (override with POST_RUSTC_TARGET)

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

rustc_target: $(PRE_RUSTC_TARGET)
	@$(MSG) "rustup toolchain install $(RUST_TOOLCHAIN)" ; \
	exec 5> /tmp/tc-rustc.lock ; \
	flock --timeout $(FLOCK_TIMEOUT) --exclusive 5 || exit 1 ; \
	pid=$$$$ ; \
	echo "$${pid}" 1>&5 ; \
	rustup toolchain install $(RUST_TOOLCHAIN) ; \
	$(MSG) "rustup default $(RUST_TOOLCHAIN)" ; \
	rustup default $(RUST_TOOLCHAIN) ; \
	$(MSG) "rustup target add $(RUST_TARGET)" ; \
	rustup target add $(RUST_TARGET) ; \
	flock -u 5

post_rustc_target: $(RUSTC_TARGET)

ifeq ($(wildcard $(RUSTC_COOKIE)),)
rustc: $(RUSTC_COOKIE)

$(RUSTC_COOKIE): $(POST_RUSTC_TARGET)
	$(create_target_dir)
	@touch -f $@
else
rustc: ;
endif
