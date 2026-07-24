###############################################################################
# spksrc.native/archive.mk
#
# Optional packaging helper for native packages: tar a subset of the install
# tree into a hosted archive, idempotently, with an optional debug-symbol strip.
# Included by spksrc.native-cc.mk (so every native front-end gets it) but a pure
# no-op unless the package declares NATIVE_ARCHIVE. Reused by native/gcc8 (the
# per-arch gcc-8.5 overlays) and suitable for any large native tool hosted on a
# release, e.g. native/llvm-14.0-build.
#
# Declare NATIVE_ARCHIVE with '=' (recursive) BEFORE including the native
# front-end, so it may reference variables that front-end defines later (triple,
# glibc, ...). Then:  make build-archive
#
#   NATIVE_ARCHIVE            output archive filename (enables the helper)
#   NATIVE_ARCHIVE_DIR        tar working dir      (default: $(INSTALL_DIR)$(INSTALL_PREFIX))
#   NATIVE_ARCHIVE_KEEP       paths to archive     (default: '.')  -- the spectrum to keep
#   NATIVE_ARCHIVE_EXCLUDES   tar --exclude args   (default: none) -- what to drop from it
#   NATIVE_ARCHIVE_SENTINEL   file that must exist first (default: NATIVE_ARCHIVE_DIR)
#   NATIVE_ARCHIVE_STRIP            non-empty to strip debug symbols first
#   NATIVE_ARCHIVE_STRIP_HOST       host strip program              (default: strip)
#   NATIVE_ARCHIVE_STRIP_HOST_DIRS  host-binary dirs, rel to DIR    (default: bin libexec)
#   NATIVE_ARCHIVE_STRIP_TARGET       cross strip for target objects (optional)
#   NATIVE_ARCHIVE_STRIP_TARGET_DIRS  target-object dirs, rel to DIR (optional)
#
# Targets:
#   build-archive       create NATIVE_ARCHIVE if absent (idempotent)
#   print-archive-name  echo NATIVE_ARCHIVE without building (for generators)
###############################################################################

ifneq ($(strip $(NATIVE_ARCHIVE)),)

NATIVE_ARCHIVE_DIR       ?= $(INSTALL_DIR)$(INSTALL_PREFIX)
NATIVE_ARCHIVE_KEEP      ?= .
NATIVE_ARCHIVE_SENTINEL  ?= $(NATIVE_ARCHIVE_DIR)
NATIVE_ARCHIVE_STRIP_HOST      ?= strip
NATIVE_ARCHIVE_STRIP_HOST_DIRS ?= bin libexec

.PHONY: print-archive-name
print-archive-name:
	@echo $(NATIVE_ARCHIVE)

.PHONY: build-archive
build-archive: $(NATIVE_ARCHIVE)

# File target, prerequisite-free on purpose: it is (re)built only when absent, so
# re-running a batch never re-strips or re-tars an archive that already exists.
# --strip-debug keeps the symbol tables the tools need and only drops the (large)
# debug sections. Target objects need the arch's OWN strip (the host strip cannot
# touch them); host binaries use the host strip.
$(NATIVE_ARCHIVE):
ifeq ($(wildcard $(NATIVE_ARCHIVE_SENTINEL)),)
	$(error "$(PKG_NAME): nothing to archive at $(NATIVE_ARCHIVE_SENTINEL); build it first")
endif
	@if [ -n "$(strip $(NATIVE_ARCHIVE_STRIP))" ]; then \
	  $(MSG) "archive: stripping debug symbols -> $(NATIVE_ARCHIVE)" ; \
	  if [ -n "$(strip $(NATIVE_ARCHIVE_STRIP_TARGET))" ] && [ -n "$(strip $(NATIVE_ARCHIVE_STRIP_TARGET_DIRS))" ]; then \
	    find $(addprefix $(NATIVE_ARCHIVE_DIR)/,$(NATIVE_ARCHIVE_STRIP_TARGET_DIRS)) -type f \
	      \( -name '*.a' -o -name '*.o' -o -name '*.so*' \) 2>/dev/null | \
	      while read f; do "$(NATIVE_ARCHIVE_STRIP_TARGET)" --strip-debug "$$f" 2>/dev/null || true ; done ; \
	  fi ; \
	  find $(addprefix $(NATIVE_ARCHIVE_DIR)/,$(NATIVE_ARCHIVE_STRIP_HOST_DIRS)) -type f 2>/dev/null | \
	    while read f; do $(NATIVE_ARCHIVE_STRIP_HOST) --strip-debug "$$f" 2>/dev/null || true ; done ; \
	fi
	@$(MSG) "archive: $(PKG_NAME) -> $(NATIVE_ARCHIVE)"
	tar -C $(NATIVE_ARCHIVE_DIR) $(NATIVE_ARCHIVE_EXCLUDES) -cJf $(NATIVE_ARCHIVE) $(NATIVE_ARCHIVE_KEEP)

endif
