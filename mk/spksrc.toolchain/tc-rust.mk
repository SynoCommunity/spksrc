###############################################################################
# spksrc.toolchain/tc-rust.mk
#
# Manages Rust toolchain installation and target support for cross-compilation.
#
# This file:
#  - installs and configures rustup and rustc
#  - installs prebuilt Rust targets when available (Tier 1/2)
#  - optionally builds Rust targets from source (Tier 3)
#  - generates a toolchain-specific config.toml for rustc
#
# Targets:
#  rustc_msg
#  pre_rustc_target     (override with PRE_RUSTC_TARGET)
#  rustc_target         (override with RUSTC_TARGET)
#  post_rustc_target    (override with POST_RUSTC_TARGET)
#
# Variables:
#  TC_LOCAL_VARS_RUST   : rustc config.toml path for the target
#  RUSTC_COOKIE         : Status cookie for rust toolchain installation
#  FLOCK_TIMEOUT        : Lock timeout to serialize rustup operations
#
# Notes:
#  - Uses file locking to prevent concurrent rustup/rustc installs.
#  - Supports both prebuilt and source-built Rust targets.
#  - Tier-3 targets are built using Rust’s ./x build system,
#    driven by a target-specific config.toml.
#
###############################################################################

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

.PHONY: rustup-rustc rustc_msg
.PHONY: $(PRE_RUSTC_TARGET) $(RUSTC_TARGET) $(POST_RUSTC_TARGET)

# The Tier-3 from-source build (config.toml, LLVM/stage builds, archive) lives in
# the host-native package native/rustc-<vers>; overlay-rustc.mk keeps only the consumer /
# package-build side (toolchain id + binutils linker wrapper).

rustc_msg:
	@$(MSG) "Installing rustc toolchain for $(NAME)"
	@$(MSG) "- rustup installation PATH: $(RUSTUP_HOME)"
	@$(MSG) "- cargo installation PATH: $(CARGO_HOME)"
	@$(MSG) "- default PATH: $(PATH)"

pre_rustc_target: rustc_msg
	@$(MSG) "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y -q --no-modify-path --default-toolchain $(TC_RUSTC)" ; \
	exec 5> /tmp/tc-rustc.lock ; \
	flock --timeout $(FLOCK_TIMEOUT) --exclusive 5 || exit 1 ; \
	pid=$$$$ ; \
	echo "$${pid}" 1>&5 ; \
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y -q --no-modify-path --default-toolchain $(TC_RUSTC) ; \
	flock -u 5

rustc_target: $(PRE_RUSTC_TARGET)
	@$(MSG) "rustup -q toolchain install $(TC_RUSTC)" ; \
	exec 5> /tmp/tc-rustc.lock ; \
	flock --timeout $(FLOCK_TIMEOUT) --exclusive 5 || exit 1 ; \
	pid=$$$$ ; \
	echo "$${pid}" 1>&5 ; \
	rustup -q toolchain install $(TC_RUSTC) ; \
	$(MSG) "rustup default $(TC_RUSTC)" ; \
	rustup default $(TC_RUSTC) ; \
	if [ -n "$(_RUST_BASE_TARGET)" ] ; then \
	   $(MSG) "Installing STOCK base std $(_RUST_BASE_TARGET) so OVERLAY_RUSTC=0 stays usable without re-invoking this cookie-locked build" ; \
	   rustup component add rust-std --target $(_RUST_BASE_TARGET) --toolchain $(TC_RUSTC) || { \
	      $(MSG) "*********************************************************************" ; \
	      $(MSG) "*** No upstream rust-std for [$(_RUST_BASE_TARGET)]" ; \
	      $(MSG) "*** OVERLAY_RUSTC=0 unusable here -- continuing with the overlay" ; \
	      $(MSG) "*********************************************************************" ; } ; \
	fi ; \
	TARGET_STATUS=$$(rustup target list --toolchain $(TC_RUSTUP_TOOLCHAIN) 2>/dev/null | grep "^$(RUST_TARGET)") || true ; \
	if echo "$$TARGET_STATUS" | grep -q "installed" ; then \
	   $(MSG) "Rust target $(RUST_TARGET) already installed — skipping" ; \
	   rustup show ; \
	elif [ -n "$$TARGET_STATUS" ] ; then \
	   $(MSG) "Installing Rust target $(RUST_TARGET) for $(TC_RUSTUP_TOOLCHAIN)" ; \
	   rustup override set $(TC_RUSTC) ; \
	   rustup component add rust-std --target $(RUST_TARGET) ; \
	   rustup show ; \
	else \
	   $(MSG) "Target $(RUST_TARGET) unavailable via rustup — will be handled by toolchain deps" ; \
	fi ; \
	flock -u 5

# The base rustup install only; the binutils linker wrapper is the rust overlay's own
# artifact and hangs off overlay-rustc (overlay-rustc.mk), not this base pipeline.
post_rustc_target: $(RUSTC_TARGET)

ifeq ($(wildcard $(RUSTC_COOKIE)),)
rustup-rustc: $(RUSTC_COOKIE)

$(RUSTC_COOKIE): $(POST_RUSTC_TARGET)
	$(create_target_dir)
	@touch -f $@
else
rustup-rustc: ;
endif
