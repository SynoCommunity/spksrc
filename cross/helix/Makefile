PKG_NAME = helix
PKG_VERS = 25.07.1
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-source.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/helix-editor/helix/releases/download/$(PKG_VERS)
EXTRACT_PATH = $(WORK_DIR)/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)/helix-term

DEPENDS =

# the C++ tree-sitter grammars build with -std=c++14, which g++ rejects before 4.9
MIN_GCC_VERSION = 4.9
# For more information about this error, try `rustc --explain E0432`.
# error: could not compile `nucleo` (lib) due to 1 previous error
UNSUPPORTED_ARCHS = $(PPC_ARCHS)

HOMEPAGE = https://helix-editor.com/
COMMENT  = A post-modern modal text editor.
LICENSE  = MPL-2.0

PATCH_TARGET = helix_patch
INSTALL_TARGET = helix_install

CARGO_BUILD_ARGS = --release --target=$(RUST_TARGET)

include ../../mk/spksrc.cross-rust.mk

# Deferred, so it adds to the per-triple cc-rs flags tc_vars.rust.mk sets rather
# than replacing them.
ADDITIONAL_CFLAGS += -O3

# for build error analysis
ENV += RUST_BACKTRACE=full

.PHONY: helix_patch
helix_patch:
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
ifeq ($(call version_lt, ${TCVERSION}, 7.0)$(call version_ge, ${TCVERSION}, 6.0),11)
	@$(MSG) "- Patch languages.toml to remove gitcommit grammar (build fails for $(ARCH)-$(TCVERSION))"
	@cat patches/001-drop-unsupported-grammar.patch | (cd $(WORK_DIR)/helix/ && patch -b -p0)
endif
endif

.PHONY: helix_build
helix_build:
	@$(MSG) "- Avoid dubious ownership restriction in github CI for cloning repositories with 'fetch tree-sitter grammars'"
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
