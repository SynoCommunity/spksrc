PKG_NAME = rust
PKG_VERS = 1.97.1
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-$(PKG_DIST_ARCH).$(PKG_EXT)
PKG_DIST_SITE = https://static.rust-lang.org/dist
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)-$(PKG_DIST_ARCH)

HOMEPAGE = https://www.rust-lang.org/
COMMENT  = A language empowering everyone to build reliable and efficient software.
LICENSE  = Apache-2.0, MIT

INSTALL_TARGET = rust_install
POST_DOWNLOAD_TARGET = rust_runtime_download

# use digests with multiple files
# Only these triples have upstream host tools (rustc + cargo)
PKG_DIST_ARCH_LIST = x86_64-unknown-linux-musl aarch64-unknown-linux-musl

include ../../mk/spksrc.common.mk
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
PKG_DIST_ARCH = x86_64-unknown-linux-musl
ALPINE_ARCH = x86_64
MUSL_LOADER = ld-musl-x86_64.so.1
else ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
PKG_DIST_ARCH = aarch64-unknown-linux-musl
ALPINE_ARCH = aarch64
MUSL_LOADER = ld-musl-aarch64.so.1
endif

ifeq ($(PKG_DIST_ARCH),)
$(error Unsupported ARCH $(ARCH))
endif

# The upstream musl builds of rustc/cargo/rust-lld are dynamic musl binaries
# (interpreter /lib/ld-musl-*.so.1, libgcc_s.so.1) which DSM does not provide.
# Ship the musl runtime + libgcc from Alpine and patch the toolchain binaries
# to use them, so the toolchain is fully self-contained.
MUSL_APK_VERS = 1.2.4_git20230717-r6
LIBGCC_APK_VERS = 13.2.1_git20231014-r0
ALPINE_SITE = https://dl-cdn.alpinelinux.org/alpine/v3.19/main

MUSL_SHA256_x86_64  = 24b7b3efa92247796f4cfecaf8d08f6a0bdead13aae9c2cf2f04a042bebb9647
MUSL_SHA256_aarch64 = 6685d4a557c963a198426edbf9ecc66fa1f12bfe51185df69173984d67bd1b40
LIBGCC_SHA256_x86_64  = f65a7029b791027010b0052aeba196b91b7470cd38375be525761c9a31f9a42a
LIBGCC_SHA256_aarch64 = bf24d3dc0964fe73c2ae534a9de4dfc06474d522c9a1331906d0f97afb29c827

MUSL_FILE = $(PKG_NAME)-musl-$(ALPINE_ARCH)-$(MUSL_APK_VERS).apk
LIBGCC_FILE = $(PKG_NAME)-libgcc-$(ALPINE_ARCH)-$(LIBGCC_APK_VERS).apk

include ../../mk/spksrc.cross-install.mk

# Components to install; skip docs, analysis, rust-analyzer and llvm-tools to
# keep the toolchain (and the resulting SPK) reasonably small.
RUST_COMPONENTS = rustc,cargo,rust-std-$(PKG_DIST_ARCH),rustfmt-preview,clippy-preview

RUST_SUPPORT = $(STAGING_INSTALL_PREFIX)/share/rust-support

.PHONY: rust_runtime_download
rust_runtime_download:
	@mkdir -p $(DISTRIB_DIR)
	@for spec in \
		"musl-$(MUSL_APK_VERS).apk $(MUSL_FILE) $(MUSL_SHA256_$(ALPINE_ARCH))" \
		"libgcc-$(LIBGCC_APK_VERS).apk $(LIBGCC_FILE) $(LIBGCC_SHA256_$(ALPINE_ARCH))" ; \
	do \
		set -- $$spec ; \
		if [ ! -f "$(DISTRIB_DIR)/$$2" ]; then \
			$(MSG) "Downloading $$1 ($(ALPINE_ARCH))" ; \
			wget -q -O "$(DISTRIB_DIR)/$$2.part" "$(ALPINE_SITE)/$(ALPINE_ARCH)/$$1" ; \
			mv "$(DISTRIB_DIR)/$$2.part" "$(DISTRIB_DIR)/$$2" ; \
		fi ; \
		echo "$$3  $(DISTRIB_DIR)/$$2" | sha256sum -c - || exit 1 ; \
	done

.PHONY: rust_install
rust_install:
	@$(MSG) "Installing rust $(PKG_VERS) ($(PKG_DIST_ARCH)) into share/rust"
	@install -d -m 755 $(STAGING_INSTALL_PREFIX)/share/rust
	@$(RUN) ; ./install.sh --prefix=$(STAGING_INSTALL_PREFIX)/share/rust --disable-ldconfig --components=$(RUST_COMPONENTS)
	@rm -f $(STAGING_INSTALL_PREFIX)/share/rust/lib/rustlib/uninstall.sh \
	       $(STAGING_INSTALL_PREFIX)/share/rust/lib/rustlib/components \
	       $(STAGING_INSTALL_PREFIX)/share/rust/lib/rustlib/install.log \
	       $(STAGING_INSTALL_PREFIX)/share/rust/lib/rustlib/rust-installer-version \
	       $(STAGING_INSTALL_PREFIX)/share/rust/lib/rustlib/manifest-*
	@$(MSG) "Installing musl runtime ($(ALPINE_ARCH)) into share/rust-support"
	@rm -rf $(WORK_DIR)/rust-runtime
	@install -d -m 755 $(WORK_DIR)/rust-runtime/musl $(WORK_DIR)/rust-runtime/libgcc $(RUST_SUPPORT)/lib
	@tar -xzf $(DISTRIB_DIR)/$(MUSL_FILE) -C $(WORK_DIR)/rust-runtime/musl 2>/dev/null || true
	@test -f $(WORK_DIR)/rust-runtime/musl/lib/$(MUSL_LOADER) || { echo "ERROR: failed to extract $(MUSL_LOADER)"; exit 1; }
	@tar -xzf $(DISTRIB_DIR)/$(LIBGCC_FILE) -C $(WORK_DIR)/rust-runtime/libgcc 2>/dev/null || true
	@test -f $(WORK_DIR)/rust-runtime/libgcc/usr/lib/libgcc_s.so.1 || { echo "ERROR: failed to extract libgcc_s.so.1"; exit 1; }
	@install -m 755 $(WORK_DIR)/rust-runtime/musl/lib/$(MUSL_LOADER) $(RUST_SUPPORT)/lib/$(MUSL_LOADER)
	@ln -sf $(MUSL_LOADER) $(RUST_SUPPORT)/lib/libc.musl-$(ALPINE_ARCH).so.1
	@ln -sf $(MUSL_LOADER) $(RUST_SUPPORT)/lib/libc.so
	@install -m 755 $(WORK_DIR)/rust-runtime/libgcc/usr/lib/libgcc_s.so.1 $(RUST_SUPPORT)/lib/libgcc_s.so.1
	@ln -sf libgcc_s.so.1 $(RUST_SUPPORT)/lib/libgcc_s.so
	@# only PIE executables can be patched; non-PIE ones (rust-lld, rust-objcopy)
	@# would be corrupted by patchelf's page-shift and are run through the
	@# loader by bin/rust-lld-wrapper.sh instead (or not used in the default flow)
	@$(MSG) "Patching toolchain binaries to the bundled musl runtime"
	@find $(STAGING_INSTALL_PREFIX)/share/rust -type f | while read -r f ; do \
		if file "$$f" 2>/dev/null | grep -q 'ELF.*pie executable' ; then \
			chmod u+w "$$f" ; \
			_rpath=$$(patchelf --print-rpath "$$f" 2>/dev/null) ; \
			patchelf --set-interpreter "$(INSTALL_PREFIX)/share/rust-support/lib/$(MUSL_LOADER)" \
			         --force-rpath \
			         --set-rpath "$(INSTALL_PREFIX)/share/rust-support/lib$${_rpath:+:$$_rpath}" "$$f" ; \
		fi ; \
	done
	@$(MSG) "Installing wrappers into bin/"
	@install -d -m 755 $(STAGING_INSTALL_PREFIX)/bin
	@for tool in rustc cargo rustdoc rustfmt cargo-clippy clippy-driver cargo-fmt ; do \
		sed -e 's/@RUST_TARGET@/$(PKG_DIST_ARCH)/g' \
		    -e 's/@RUST_TOOL@/'$${tool}'/g' \
		    $(CURDIR)/src/wrapper.sh > $(STAGING_INSTALL_PREFIX)/bin/$${tool} ; \
		chmod 755 $(STAGING_INSTALL_PREFIX)/bin/$${tool} ; \
	done
	@sed -e 's/@RUST_TARGET@/$(PKG_DIST_ARCH)/g' \
	     -e 's/@MUSL_LOADER@/$(MUSL_LOADER)/g' \
	     $(CURDIR)/src/rust-lld-wrapper.sh > $(STAGING_INSTALL_PREFIX)/share/rust/bin/rust-lld-wrapper.sh
	@chmod 755 $(STAGING_INSTALL_PREFIX)/share/rust/bin/rust-lld-wrapper.sh
