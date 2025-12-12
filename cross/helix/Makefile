PKG_NAME = helix
PKG_VERS = 25.07.1
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-source.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/helix-editor/helix/releases/download/$(PKG_VERS)
EXTRACT_PATH = $(WORK_DIR)/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)/helix-term

DEPENDS =

# rust >= 1.82 required
UNSUPPORTED_ARCHS  = $(ARMv5_ARCHS)
# For more information about this error, try `rustc --explain E0432`.
# error: could not compile `nucleo` (lib) due to 1 previous error
UNSUPPORTED_ARCHS += $(PPC_ARCHS)
# some grammars fail to build
UNSUPPORTED_ARCHS += $(ARMv7L_ARCHS)

HOMEPAGE = https://helix-editor.com/
COMMENT  = A post-modern modal text editor.
LICENSE  = MPL-2.0

PATCH_TARGET = helix_patch
INSTALL_TARGET = helix_install

include ../../mk/spksrc.cross-rust.mk

# we can't build with --locked, since we patched the cc crate
CARGO_BUILD_ARGS = --release --target=$(RUST_TARGET)

ifneq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
# tweaks to fix build with host compiler
ENV += CFLAGS=""
# use gcc as host compiler, default (cc) does not work
ENV += CC_x86_64_unknown_linux_gnu=gcc
ENV += CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER=gcc
endif

ADDITIONAL_RUSTFLAGS = -C linker=$(TC_PATH)$(TC_TARGET)-gcc

ENV += CC_$(shell echo $(RUST_TARGET) | tr - _)=$(TC_PATH)$(TC_TARGET)-gcc
ENV += CXX_$(shell echo $(RUST_TARGET) | tr - _)=$(TC_PATH)$(TC_TARGET)-g++
ENV += AR_$(shell echo $(RUST_TARGET) | tr - _)=$(TC_PATH)$(TC_TARGET)-ar
ENV += RANLIB_$(shell echo $(RUST_TARGET) | tr - _)=$(TC_PATH)$(TC_TARGET)-ranlib

ENV += CFLAGS_$(shell echo $(RUST_TARGET) | tr - _)=-O3

# for build error analysis
ENV += RUST_BACKTRACE=full

.PHONY: helix_patch
helix_patch:
	@$(MSG) "- Add patched cc crate for crossbuild"
	@tar -xf src/cargo-cc-patched-1.2.29.tar.gz -C $(WORK_DIR)/helix/
	@$(MSG) "- Patch Cargo.toml to use patched cc"
	@cat patches/001-cargo-cc.patch | (cd $(WORK_DIR)/helix/ && patch -b -p0)
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
ifeq ($(call version_lt, ${TCVERSION}, 7.0)$(call version_ge, ${TCVERSION}, 6.0),11)
	@$(MSG) "- Patch languages.toml to remove gitcommit grammar (build fails for $(ARCH)-$(TCVERSION))"
	@cat patches/002-drop-unsupported-grammar.patch | (cd $(WORK_DIR)/helix/ && patch -b -p0)
endif
endif

.PHONY: helix_build
helix_build:
	@$(MSG) "- Avoid dubious ownership restriction in github CI for clonging repositories with 'fetch tree-sitter grammars'"
	git config --global --add safe.directory '*'
	@$(MSG) "- Build helix with cargo build"
	$(RUN) cargo build $(CARGO_BUILD_ARGS)

.PHONY: helix_install
helix_install: helix_build
	@install -d -m755 $(STAGING_INSTALL_PREFIX)/bin/runtime
	@$(MSG) "- Install helix binary"
	@install -m755 $(WORK_DIR)/helix/target/$(RUST_TARGET)/release/hx $(STAGING_INSTALL_PREFIX)/bin/hx
	@$(MSG) "- Install helix runtimes into bin/runtime"
	@rsync -a --exclude ".*" --exclude sources $(WORK_DIR)/helix/runtime $(STAGING_INSTALL_PREFIX)/bin
